#!/bin/bash
# Setup script for auto-commit configuration

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/commit-config.json"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[SETUP]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Create default configuration
create_config() {
    log "Creating configuration file: $CONFIG_FILE"
    
    cat > "$CONFIG_FILE" << 'EOF'
{
  "max_files_per_commit": 10,
  "auto_push": false,
  "commit_patterns": {
    "feat": "add new features and functionality",
    "fix": "resolve bugs and issues",
    "docs": "update documentation",
    "style": "improve code formatting and style",
    "refactor": "restructure code without changing functionality",
    "test": "add or update tests",
    "chore": "maintain and update project dependencies",
    "ci": "update CI/CD configuration",
    "config": "update configuration files",
    "script": "update shell scripts and automation",
    "deps": "update project dependencies"
  },
  "scope_mapping": {
    "week-01": "module1",
    "week-02": "module2",
    "week-03": "module3",
    "scripts": "scripts",
    "docs": "docs",
    "ejercicios": "exercises",
    "proyectos": "projects"
  },
  "file_type_mapping": {
    "*.md": "docs",
    "*.txt": "docs",
    "*.rst": "docs",
    "README*": "docs",
    "*test*": "test",
    "*spec*": "test",
    "*.test.sh": "test",
    "*.spec.sh": "test",
    "*.json": "config",
    "*.yml": "config",
    "*.yaml": "config",
    "*.toml": "config",
    "*.ini": "config",
    ".env*": "config",
    "Dockerfile": "config",
    "docker-compose*": "config",
    "*.sh": "script",
    "*.bash": "script",
    "*.zsh": "script",
    "_scripts/*": "script",
    ".gitignore": "ci",
    ".gitattributes": "ci",
    ".github/*": "ci",
    "package.json": "deps",
    "pnpm-lock.yaml": "deps",
    "requirements.txt": "deps",
    "Gemfile": "deps",
    "Gemfile.lock": "deps",
    "*.css": "style",
    "*.scss": "style",
    "*.sass": "style",
    "*.less": "style"
  }
}
EOF

    success "Configuration file created successfully"
}

# Setup git hooks (optional)
setup_git_hooks() {
    local project_root
    project_root="$(cd "$SCRIPT_DIR/.." && pwd)"
    local hooks_dir="$project_root/.git/hooks"
    
    if [[ ! -d "$hooks_dir" ]]; then
        warning "Git hooks directory not found. Skipping git hooks setup."
        return 0
    fi
    
    log "Setting up git hooks..."
    
    # Pre-commit hook for auto-formatting
    cat > "$hooks_dir/pre-commit" << 'EOF'
#!/bin/bash
# Auto-format shell scripts before commit

# Find and format shell scripts
find . -name "*.sh" -not -path "./.git/*" | while read -r file; do
    if command -v shfmt > /dev/null 2>&1; then
        shfmt -w -i 4 -ci "$file"
        git add "$file"
    fi
done

exit 0
EOF

    chmod +x "$hooks_dir/pre-commit"
    success "Git hooks configured"
}

# Create helper scripts
create_helpers() {
    log "Creating helper scripts..."
    
    # Quick commit script
    cat > "$SCRIPT_DIR/quick-commit.sh" << 'EOF'
#!/bin/bash
# Quick commit with conventional commit format

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Simple interactive commit
if [[ $# -eq 0 ]]; then
    echo "Quick Commit Options:"
    echo "1. feat     - New feature"
    echo "2. fix      - Bug fix"
    echo "3. docs     - Documentation"
    echo "4. style    - Code style"
    echo "5. test     - Tests"
    echo "6. chore    - Maintenance"
    echo ""
    read -p "Select type (1-6): " choice
    
    case $choice in
        1) type="feat" ;;
        2) type="fix" ;;
        3) type="docs" ;;
        4) type="style" ;;
        5) type="test" ;;
        6) type="chore" ;;
        *) echo "Invalid choice"; exit 1 ;;
    esac
    
    read -p "Enter scope (optional): " scope
    read -p "Enter description: " description
    
    if [[ -n "$scope" ]]; then
        message="${type}(${scope}): ${description}"
    else
        message="${type}: ${description}"
    fi
    
    git add .
    git commit -m "$message"
    echo "Committed: $message"
else
    # Use auto-commit script
    "$SCRIPT_DIR/auto-commit.sh"
fi
EOF

    chmod +x "$SCRIPT_DIR/quick-commit.sh"
    
    # Commit with AI assistance script (placeholder for future enhancement)
    cat > "$SCRIPT_DIR/smart-commit.sh" << 'EOF'
#!/bin/bash
# Smart commit with AI-generated messages (placeholder)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Smart commit feature coming soon..."
echo "For now, using auto-commit..."

"$SCRIPT_DIR/auto-commit.sh"
EOF

    chmod +x "$SCRIPT_DIR/smart-commit.sh"
    
    success "Helper scripts created"
}

# Create usage documentation
create_docs() {
    log "Creating documentation..."
    
    cat > "$SCRIPT_DIR/README.md" << 'EOF'
# Auto-Commit Scripts

Automated commit generation with conventional commit standards and best practices.

## Scripts

### `auto-commit.sh`
Main auto-commit script that analyzes changes and generates conventional commits automatically.

**Features:**
- Automatic commit type detection based on file patterns
- Conventional commit format (type(scope): description)
- Smart batching for large commits
- Configurable via JSON configuration

**Usage:**
```bash
./scripts/auto-commit.sh
```

### `quick-commit.sh`
Interactive commit script for manual commit type selection.

**Usage:**
```bash
./scripts/quick-commit.sh          # Interactive mode
./scripts/quick-commit.sh auto     # Use auto-commit
```

### `smart-commit.sh`
Future AI-enhanced commit script (placeholder).

### `setup-auto-commit.sh`
Setup script for configuration and git hooks.

**Usage:**
```bash
./scripts/setup-auto-commit.sh
```

## Configuration

Configuration is stored in `scripts/commit-config.json`:

```json
{
  "max_files_per_commit": 10,
  "auto_push": false,
  "commit_patterns": { ... },
  "scope_mapping": { ... },
  "file_type_mapping": { ... }
}
```

### Configuration Options

- `max_files_per_commit`: Maximum files per commit (default: 10)
- `auto_push`: Automatically push after commit (default: false)
- `commit_patterns`: Templates for commit messages
- `scope_mapping`: Directory to scope mapping
- `file_type_mapping`: File patterns to commit type mapping

## Commit Types

Following conventional commit standards:

- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes
- `config`: Configuration changes
- `script`: Shell script changes
- `deps`: Dependency updates

## Examples

### Automatic Detection
```bash
# Changes to week-01/README.md -> docs(module1): update README.md
# Changes to scripts/deploy.sh -> script(scripts): update deploy.sh
# Multiple files -> feat: add new features and components
```

### Manual Override
```bash
git add specific-files
git commit -m "feat(module2): add new exercise solution"
```

## Best Practices

1. **Keep commits small and focused**
2. **Use descriptive commit messages**
3. **Stage related changes together**
4. **Review changes before committing**
5. **Follow conventional commit format**

## Dependencies

Optional dependencies for enhanced functionality:
- `jq`: JSON parsing for configuration
- `shfmt`: Shell script formatting
- `git`: Version control (required)

## Installation

1. Make scripts executable:
```bash
chmod +x scripts/*.sh
```

2. Run setup:
```bash
./scripts/setup-auto-commit.sh
```

3. Start using:
```bash
./scripts/auto-commit.sh
```
EOF

    success "Documentation created"
}

# Main setup function
main() {
    log "Setting up auto-commit system..."
    
    create_config
    create_helpers
    create_docs
    
    # Ask about git hooks
    read -p "Do you want to setup git hooks? (y/N): " setup_hooks
    if [[ "$setup_hooks" =~ ^[Yy]$ ]]; then
        setup_git_hooks
    fi
    
    # Make scripts executable
    chmod +x "$SCRIPT_DIR"/*.sh
    
    success "Auto-commit system setup completed!"
    echo ""
    echo "Usage:"
    echo "  ./_scripts/auto-commit.sh      # Automatic commits"
    echo "  ./_scripts/quick-commit.sh     # Interactive commits"
    echo "  ./_scripts/smart-commit.sh     # AI-enhanced commits (coming soon)"
    echo ""
    echo "Configuration: _scripts/commit-config.json"
    echo "Documentation: _scripts/README.md"
}

main "$@"
