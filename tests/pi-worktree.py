#!/usr/bin/env python3
"""Launcher regression tests; uses disposable Git repos and a fake Pi process."""
import json
import os
from pathlib import Path
import pty
import select
import subprocess
import tempfile
import time
import unittest

LAUNCHER = Path(__file__).resolve().parents[1] / 'bin' / 'pi-launch'


class WorktreeTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name).resolve()
        self.main = self.base / 'repo'
        self.tree = self.base / 'repo-task'
        self.main.mkdir()
        self.git(self.main, 'init', '-q')
        self.git(self.main, '-c', 'user.name=Test', '-c', 'user.email=test@example.invalid',
                 'commit', '-q', '--allow-empty', '-m', 'initial')
        self.git(self.main, 'worktree', 'add', '-q', '-b', 'pi/task', str(self.tree))
        self.fakebin = self.base / 'bin'
        self.fakebin.mkdir()
        fake = self.fakebin / 'pi'
        fake.write_text('#!/usr/bin/env python3\nimport json, os, sys\n'
                        'print("PI_RUN=" + json.dumps([os.getcwd(), sys.argv[1:]]), flush=True)\n'
                        'sys.exit(int(os.environ.get("FAKE_PI_EXIT", "0")))\n')
        fake.chmod(0o755)
        self.env = {**os.environ, 'HOME': str(self.base),
                    'PATH': str(self.fakebin) + os.pathsep + os.environ['PATH'],
                    'PI_CODING_AGENT_DIR': str(self.base / 'agent')}
        self.env.pop('PI_CODING_AGENT_SESSION_DIR', None)
        self.session = self.base / 'agent' / 'sessions' / '--worktree--' / 'session.jsonl'
        self.session.parent.mkdir(parents=True)
        self.session.write_text(json.dumps({'type': 'session', 'id': 'abc123',
                                            'cwd': str(self.tree)}) + '\n')

    def git(self, cwd, *args):
        return subprocess.check_output(['git', '-C', str(cwd), *args], stderr=subprocess.STDOUT)

    def run_pi(self, cwd, args=(), replies=(), exit_code=0, executable=LAUNCHER):
        master, slave = pty.openpty()
        process = subprocess.Popen([str(executable), *args], cwd=cwd,
                                   env={**self.env, 'FAKE_PI_EXIT': str(exit_code)},
                                   stdin=slave, stdout=slave, stderr=slave)
        os.close(slave)
        self.addCleanup(lambda: process.poll() is None and process.kill())
        output = b''
        pending = list(replies)
        deadline = time.monotonic() + 10
        try:
            while time.monotonic() < deadline:
                if select.select([master], [], [], 0.1)[0]:
                    try:
                        chunk = os.read(master, 65536)
                    except OSError:
                        break
                    if not chunk:
                        break
                    output += chunk
                    if pending and pending[0][0].encode() in output:
                        _, answer = pending.pop(0)
                        os.write(master, (answer + '\n').encode())
                if process.poll() is not None:
                    # Drain remaining output, including cleanup messages.
                    continue
            try:
                status = process.wait(timeout=1)
            except subprocess.TimeoutExpired:
                self.fail(output.decode(errors='replace'))
            self.assertFalse(pending, output.decode(errors='replace'))
            return status, output.decode(errors='replace')
        finally:
            os.close(master)

    def test_retained_worktree_prompts_again_and_preserves_exit_code(self):
        for code in (0, 7):
            status, output = self.run_pi(self.tree, ['--continue'], [('on exit? [y/N]', 'n')], code)
            self.assertEqual(status, code)
            self.assertIn('Kept "task"', output)
            self.assertTrue(self.tree.exists())

    def test_named_worktree_creation_uses_same_cleanup_lifecycle(self):
        created = self.base / 'repo-new'
        status, output = self.run_pi(self.main, ['new'], [('on exit? [y/N]', 'n')],
                                     executable=LAUNCHER.with_name('pi-worktree'))
        self.assertEqual(status, 0)
        self.assertIn(json.dumps([str(created), []]), output)
        self.assertTrue(created.exists())

    def test_switch_resumes_original_session_and_prompts_for_cleanup(self):
        status, output = self.run_pi(self.main, ['--session', 'abc123'],
                                     [('Choice [s/f/c]:', 's'), ('on exit? [y/N]', 'n')])
        self.assertEqual(status, 0)
        self.assertIn(json.dumps([str(self.tree), ['--session', str(self.session)]]), output)
        self.assertTrue(self.tree.exists())

    def test_path_switch_can_remove_dirty_worktree_and_branch(self):
        (self.tree / 'untracked').write_text('work')
        status, output = self.run_pi(self.main, ['--session', str(self.session)],
                                     [('Choice [s/f/c]:', ''), ('on exit? [y/N]', 'yes')])
        self.assertEqual(status, 0)
        self.assertIn('uncommitted changes', output)
        self.assertFalse(self.tree.exists())
        self.assertNotIn(b'refs/heads/pi/task', self.git(self.main, 'show-ref'))

    def test_fork_keeps_current_directory(self):
        _, output = self.run_pi(self.main, ['--session', 'abc'], [('Choice [s/f/c]:', 'f')])
        self.assertIn(json.dumps([str(self.main), ['--fork', str(self.session)]]), output)
        self.assertNotIn('on exit?', output)

    def test_cancel_does_not_start_pi(self):
        _, output = self.run_pi(self.main, ['--session', 'abc123'], [('Choice [s/f/c]:', 'c')])
        self.assertNotIn('PI_RUN=', output)

    def test_failed_removal_does_not_delete_branch(self):
        self.git(self.main, 'worktree', 'lock', str(self.tree))
        _, output = self.run_pi(self.tree, replies=[('on exit? [y/N]', 'y')])
        self.assertIn('removal failed; branch retained', output)
        self.assertTrue(self.tree.exists())
        self.assertIn(b'refs/heads/pi/task', self.git(self.main, 'show-ref'))

    def test_print_and_maintenance_do_not_prompt(self):
        for args in (['--print', 'hello'], ['update'], ['--mode', 'json']):
            _, output = self.run_pi(self.tree, args)
            self.assertIn('PI_RUN=', output)
            self.assertNotIn('on exit?', output)

    def test_noninteractive_does_not_prompt(self):
        result = subprocess.run([str(LAUNCHER), '--session', 'abc123'], cwd=self.main,
                                env=self.env, input='', capture_output=True, text=True, timeout=10)
        self.assertEqual(result.returncode, 0)
        self.assertIn(json.dumps([str(self.main), ['--session', 'abc123']]), result.stdout)
        self.assertNotIn('Choice', result.stderr)


if __name__ == '__main__':
    unittest.main()
