# Development Setup

This guide targets macOS and assumes the repository is located at:

```text
/Users/erwinklithdingcoong/Desktop/StudyMate AI
```

Run commands one block at a time. Do not continue when a verification command
fails.

## 1. Install Apple's command-line tools

```bash
xcode-select --install
git --version
```

## 2. Install Homebrew

Use the current installation command from https://brew.sh, then verify:

```bash
brew --version
brew update
```

## 3. Install Node.js LTS

Use `nvm` so the Node version can be controlled per project:

```bash
brew install nvm
mkdir -p "$HOME/.nvm"
```

Add the initialization lines printed by Homebrew to `~/.zshrc`, restart the
terminal, and run:

```bash
nvm install --lts
nvm use --lts
node --version
npm --version
```

## 4. Install Flutter

```bash
brew install --cask flutter
flutter doctor
```

Complete every required item reported by `flutter doctor`. For iOS development,
install Xcode from the App Store, open it once, and accept its license. For
Android development, install Android Studio and the Android SDK.

Verify:

```bash
flutter doctor -v
dart --version
```

## 5. Install MySQL

```bash
brew install mysql
brew services start mysql
mysql --version
mysql_secure_installation
```

Create a local development database and a dedicated user. Do not use the root
account from the application:

```sql
CREATE DATABASE studymate_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'studymate'@'localhost' IDENTIFIED BY 'replace-with-a-local-password';
GRANT ALL PRIVILEGES ON studymate_dev.* TO 'studymate'@'localhost';
FLUSH PRIVILEGES;
```

## 6. Recommended VS Code extensions

- Flutter
- Dart
- ESLint
- Prettier
- Error Lens
- GitLens
- Thunder Client

## 7. Verify the complete toolchain

From the repository root:

```bash
git status
node --version
npm --version
flutter --version
dart --version
mysql --version
```

## 8. Security rules

- Put secrets only in ignored `.env` files.
- Commit an `.env.example` containing names but no secret values.
- Keep AI API keys in the backend; never embed them in Flutter.
- Validate file type and size on both the client and server.
- Treat uploaded documents as private user data.
