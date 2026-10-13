# Global agent guidance

Personal defaults across projects; follow project instructions and harness permissions.

## Safety and scope

- Never read or expose secrets, credentials, auth stores, shell history, or `.env` values. Inspect only key names or redacted structure when needed; keep sensitive data out of external queries.
- Keep changes minimal; add dependencies, plugins, agents, or MCP servers only for a concrete need.
- Run routine read-only discovery without unnecessary confirmation. Evaluate execution options, redirects, and pipelines by their effects; never bypass permissions.

## CLI operations

- Inventory tracked files with `git ls-files`; add `--cached --others --exclude-standard` when untracked files matter. Use NUL-delimited filenames for programmatic handoffs.
- Prefer `rg --color=never` for content searches: `-F` literals, `-n` lines, `-l` filenames, `-q` existence. Exit 1 means no match.
- Prefer `fd --color=never` for filename discovery. Keep native harness search tools and use `grep`/`find` when needed for availability, portability, or semantics.
- Use `jq` for simple JSON operations: `-r` for text, omit it for JSON; pass shell strings with `--arg`.
- Use `eza` only when a tree helps; bound depth, disable colors/icons, and exclude generated directories. Do not install tools just to satisfy these preferences.
- Scope searches and output narrowly. Respect ignore rules; include hidden/ignored paths only deliberately, without searching secrets or private application state.

## Current documentation

- Use Context7 for library/API syntax, configuration, setup, migration, and library-specific debugging—not unrelated coding tasks. Prefer available Context7 tools or skills over CLI.
- CLI fallback: `npx ctx7@latest library <name> "<question>"`, then `npx ctx7@latest docs <libraryId> "<concept>"`. Resolve first unless given a library ID; use version-specific docs when relevant.
- Keep queries focused. Report lookup failures rather than silently relying on recalled API details; respect network permissions.
