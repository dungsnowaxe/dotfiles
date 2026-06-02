# Dotfiles

Personal dotfiles repository for syncing macOS configuration across machines. This repository contains shell configurations, Homebrew package lists, and various setup files while keeping sensitive data (API keys, SSH keys, credentials) secure through comprehensive `.gitignore` rules.

## 🔒 Security Note

This repository uses a comprehensive `.gitignore` to exclude sensitive files including:
- API keys and credentials
- SSH keys and configurations
- GPG keys
- Password manager databases
- Cloud credentials (AWS, Azure, Google Cloud)
- Application-specific sensitive files
- History files that may contain sensitive commands

**Never commit sensitive data to this repository!**

## 📦 What's Included

- **Shell Configurations**: `.zshrc`, `.zprofile`, `.fzf.bash`, `.fzf.zsh`
- **Tmux Configuration**: `.tmux.conf`
- **Homebrew Packages**: `Brewfile` with all installed formulas and casks
- **Claude AI Configuration**: `.claude.json`
- **Comprehensive `.gitignore`**: Protects sensitive data automatically

## 🚀 Setup on a New Mac

### Step 1: Install Homebrew

If Homebrew isn't installed yet:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Step 2: Clone This Repository

```bash
git clone https://github.com/dungsnowaxe/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Step 3: Install Homebrew Packages

This will install all your applications and command-line tools:

```bash
brew bundle --file=Brewfile
```

### Step 4: Copy Configuration Files

Copy the configuration files to your home directory:

```bash
# Shell configurations
cp .zshrc .zprofile .fzf.bash .fzf.zsh .tmux.conf ~/

# Claude configuration
cp .claude.json ~/
```

### Step 5: Apply Shell Changes

```bash
source ~/.zshrc
```

### Step 6: Set Up Git Configuration

Configure your git user name and email:

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

## 🔄 Updating the Repository

When you make changes to your configuration on your main machine:

```bash
# Navigate to your home directory (or wherever you initialized git)
cd ~

# Add new files or changes
git add .

# Commit changes
git commit -m "Your commit message"

# Push to GitHub
git push
```

### Updating on Other Machines

To pull the latest changes on other machines:

```bash
cd ~/dotfiles
git pull origin main

# Copy updated configuration files
cp .zshrc .zprofile .fzf.bash .fzf.zsh .tmux.conf ~/
cp .claude.json ~/

# Apply changes
source ~/.zshrc
```

## 🛠️ Managing Homebrew Packages

### Adding New Packages

When you install new packages, update the Brewfile:

```bash
# Update the Brewfile with current packages
brew bundle dump --file=~/dotfiles/Brewfile --force

# Commit and push
cd ~/dotfiles
git add Brewfile
git commit -m "Add new packages to Brewfile"
git push
```

### Removing Unused Packages

To remove packages that are no longer in your Brewfile:

```bash
brew bundle cleanup --file=~/dotfiles/Brewfile
```

## 📝 Adding New Configuration Files

When you want to add new configuration files to sync:

1. **Check if the file contains sensitive data** - If yes, add it to `.gitignore` first
2. **Add the file to git**:
   ```bash
   git add ~/.config/your-app/config
   git commit -m "Add your-app configuration"
   git push
   ```

## ⚠️ Important Notes

- **SSH Keys**: These are excluded by `.gitignore` for security. You'll need to set up SSH keys separately on each machine.
- **VS Code Settings**: The extensions are excluded, but you can manually add your settings if needed.
- **System-Specific Paths**: Some configurations may need adjustments for different macOS versions or machine setups.
- **Permissions**: Some system directories require special permissions and are intentionally excluded.

## 🐛 Troubleshooting

### Git Status Shows Many Untracked Files

This is normal! The `.gitignore` file handles ignoring system directories. If you see many untracked files, check your `.gitignore` is working:

```bash
git check-ignore -v path/to/file
```

### Homebrew Bundle Fails

If `brew bundle` fails, try:

```bash
# Update Homebrew first
brew update

# Then try bundle again
brew bundle --file=Brewfile
```

### Shell Configuration Not Applied

If changes to `.zshrc` don't take effect:

```bash
# Reload shell configuration
source ~/.zshrc

# Or restart your terminal
```

## 📚 Additional Resources

- [Homebrew Documentation](https://docs.brew.sh/)
- [Brew Bundle Documentation](https://docs.brew.sh/Manpage#bundle-subcommand)
- [Git Documentation](https://git-scm.com/doc)

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to fork it for your own use!

---

**Last Updated**: June 2, 2026
