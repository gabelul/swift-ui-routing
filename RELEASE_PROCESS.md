# Release process guide

This document describes how to release a new version of `swift-ui-routing`.

## 📋 Release steps

### 1. Develop on a release branch

```bash
# Switch to the release branch (example: release/v1.0.12)
git checkout release/v1.0.12
git pull origin release/v1.0.12
```

### 2. Update `CHANGELOG.md`

During development, record changes under the "Unreleased" section:

```markdown
## [Unreleased]

### Added
- Description of new features

### Fixed
- Description of bug fixes
```

### 3. Prepare the release

When you're ready to release, convert "Unreleased" into a versioned section:

```markdown
## [1.0.12] - 2025-11-08

### Added
- Description of new features

### Fixed
- Description of bug fixes
```

**Important**: The version number must match the branch name (`release/v1.0.12` → `[1.0.12]`).

### 4. Commit and push changes

```bash
git add CHANGELOG.md
git commit -m "chore: prepare for v1.0.12 release"
git push origin release/v1.0.12
```

### 5. Merge the PR into `main`

```bash
# Merge the PR (this triggers the automated release)
gh pr merge <PR番号> --squash
```

**This merge automatically:**
1. Creates the `v1.0.12` tag
2. Creates the GitHub Release `v1.0.12`
3. Creates the next release branch `release/v1.0.13`
4. Creates a draft PR for the next release

### 6. Verify the release

```bash
# Check the GitHub Release
gh release view v1.0.12

# Check the next draft PR
gh pr list --state all --limit 1
```

## 🔢 Versioning rules

Follows [Semantic Versioning](https://semver.org/): `MAJOR.MINOR.PATCH`

| 変更内容 | バージョン | 例 |
|---------|-----------|-----|
| Bug fixes only | PATCH | 1.0.12 → 1.0.13 |
| New features (backwards compatible) | MINOR | 1.0.13 → 1.1.0 |
| Breaking changes | MAJOR | 1.1.0 → 2.0.0 |

**Note**: The current workflow automatically increments PATCH. For MINOR/MAJOR bumps, adjust the next release branch name manually.

## 📝 How to write the changelog

Follow the [Keep a Changelog](https://keepachangelog.com/) format.

### Change categories

- **Added**: new features
- **Changed**: changes to existing functionality
- **Deprecated**: features that will be removed soon
- **Removed**: removed features
- **Fixed**: bug fixes
- **Security**: security-related changes

### Good example

```markdown
## [1.0.12] - 2025-11-08

### Added
- **New themes**: add 7 built-in themes such as Ocean, Forest, Sunset

### Fixed
- **Dark mode**: fix an issue where card shadows were not rendered correctly in dark mode
```

**Why it’s good:**
- specific and detailed
- clear user value
- uses bold to emphasize important points

### Bad example

```markdown
## [1.0.12] - 2025-11-08

### Changed
- fixed some things
- fixed bugs
```

**Why it’s bad:**
- unclear what changed
- unclear user value

## ⚙️ How the automation works

### auto-release-on-merge.yml

**Trigger**: when a release branch (`release/vX.Y.Z`) is merged into `main`

**What it does:**
1. Extract the version from the branch name
2. Validate that `CHANGELOG.md` contains a section for that version
3. Create and push the tag automatically
4. Extract the matching version section from `CHANGELOG.md`
5. Generate release notes
6. Create the GitHub Release
7. Calculate the next version (increment PATCH)
8. Create the next release branch
9. Add an "Unreleased" section to `CHANGELOG.md`
10. Create a draft PR for the next release

### Flow diagram

```
PR merge (release/vX.Y.Z → main)
  ↓
run auto-release-on-merge.yml
  ↓
create tag → create GitHub Release → prepare next release
```

## 🔧 Troubleshooting

### Changelog validation error

**Error**: `❌ Error: Could not find version [X.Y.Z] section in CHANGELOG.md`

**Fix**:
1. Update `CHANGELOG.md` on the release branch
2. Confirm the format: `## [X.Y.Z] - YYYY-MM-DD`
3. Commit/push again and merge the PR

### GitHub Release creation fails

**Cause**: insufficient workflow permissions

**Fix**:
1. Repository settings > Actions > General
2. Set "Workflow permissions" to "Read and write permissions"

### If you used the wrong version number

**Before merge**: close the PR, fix `CHANGELOG.md`, then open a new PR

**After merge**:
```bash
# Delete the tag
git push origin :refs/tags/vX.Y.Z

# Delete the GitHub Release manually (via the web UI)

# Fix `CHANGELOG.md` on `main` and commit
# Create a new release branch with the correct version and merge it
```

## 📚 References

- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)

## 📁 Related files

- [.github/workflows/auto-release-on-merge.yml](.github/workflows/auto-release-on-merge.yml) - release automation workflow
- [CHANGELOG.md](CHANGELOG.md) - changelog
