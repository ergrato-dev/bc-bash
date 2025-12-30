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
./_scripts/auto-commit.sh
```

### `cron-auto-commit.sh`

Interactive auto-commit script designed for cron execution with user confirmation.

**Features:**

- Cron-compatible execution
- Interactive confirmation when changes are detected
- Desktop notifications support
- Non-interactive mode with GUI terminal spawning
- Lock file management to prevent conflicts
- Multiple action options (commit, defer, manual, etc.)

**Usage:**

```bash
./_scripts/cron-auto-commit.sh              # Auto-detect mode
./_scripts/cron-auto-commit.sh --interactive # Force interactive mode
```

**Cron Integration:**

```bash
# Example cron entries (use setup-cron-commit.sh for easy setup)
*/30 * * * * /path/to/bc-bash/_scripts/cron-auto-commit.sh
0 */2 * * * /path/to/bc-bash/_scripts/cron-auto-commit.sh
```

### `setup-cron-commit.sh`

Interactive setup script for configuring cron-based auto-commit tasks.

**Features:**

- Interactive menu for cron configuration
- Multiple predefined intervals (15min, 30min, 1hour, 2hours, daily)
- Custom cron expression support
- Cron job management (add/remove/list)
- Script testing functionality

**Usage:**

```bash
./_scripts/setup-cron-commit.sh              # Interactive menu
./_scripts/setup-cron-commit.sh add 1hour    # Add hourly cron job
./_scripts/setup-cron-commit.sh remove       # Remove all cron jobs
./_scripts/setup-cron-commit.sh test         # Test the cron script
```

### `notification-handler.sh`

Manages notifications from the cron-based auto-commit system.

**Features:**

- Check for pending commit notifications
- Interactive notification handling
- Automatic cleanup of old notifications
- Integration with cron auto-commit workflow

**Usage:**

```bash
./_scripts/notification-handler.sh           # Handle pending notifications
./_scripts/notification-handler.sh check     # Check for notifications
./_scripts/notification-handler.sh clean     # Clean old notifications
```

### `quick-commit.sh`

Interactive commit script for manual commit type selection.

**Usage:**

```bash
./_scripts/quick-commit.sh          # Interactive mode
./_scripts/quick-commit.sh auto     # Use auto-commit
```

### `smart-commit.sh`

Future AI-enhanced commit script (placeholder).

### `setup-auto-commit.sh`

Setup script for configuration and git hooks.

**Usage:**

```bash
./_scripts/setup-auto-commit.sh
```

## Cron-Based Auto-Commit System

The cron-based auto-commit system provides automated, yet user-controlled commit generation:

### Workflow

1. **Cron Execution**: Cron runs `cron-auto-commit.sh` at scheduled intervals
2. **Change Detection**: Script checks for uncommitted changes
3. **User Notification**: If changes found:
   - Desktop notification sent
   - GUI terminal opened (if available)
   - Notification file created for later handling
4. **User Interaction**: User can:
   - Confirm auto-commit
   - Make manual commit
   - Defer for 1 hour
   - Cancel operation
5. **Commit Execution**: If confirmed, uses standard auto-commit logic

### Setup Process

1. **Configure cron job**:

   ```bash
   ./_scripts/setup-cron-commit.sh
   ```

1. **Test the system**:

   ```bash
   ./_scripts/setup-cron-commit.sh test
   ```

1. **Handle notifications**:

   ```bash
   ./_scripts/notification-handler.sh
   ```

### Benefits

- **Non-intrusive**: Only interrupts when there are actual changes
- **User control**: Always requires confirmation before committing
- **Flexible scheduling**: Multiple interval options
- **GUI integration**: Works well in desktop environments
- **Failsafe**: Lock files prevent multiple simultaneous executions

## Configuration

Configuration is stored in `_scripts/commit-config.json`:

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
# Changes to _scripts/deploy.sh -> script(scripts): update deploy.sh
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
chmod +x _scripts/*.sh
```

1. Run setup:

```bash
./_scripts/setup-auto-commit.sh
```

1. Start using:

```bash
./_scripts/auto-commit.sh
```

## Competition Mode Setup

For software development competitions, the system includes optimized configurations:

### Quick Competition Setup

Use the dedicated competition setup script:

```bash
./_scripts/competition-setup.sh
```

### Competition Profiles

#### 🏃‍♂️ HACKATHON Profile

```bash
./_scripts/competition-setup.sh hackathon
```

- Auto-commit every **1 minute**
- Maximum 20 files per commit
- Optimized for maximum speed
- Minimal user interruption

#### ⚡ SPRINT Profile

```bash
./_scripts/competition-setup.sh sprint
```

- Auto-commit every **5 minutes**
- Maximum 15 files per commit
- Balanced speed and quality
- Quick confirmation prompts

#### 🤝 COLLABORATIVE Profile

```bash
./_scripts/competition-setup.sh collaborative
```

- Auto-commit every **10 minutes**
- Maximum 10 files per commit
- Focus on commit quality
- Full user confirmation

### Competition Features

- **Ultra-fast intervals**: Down to 1-minute commits
- **Aggressive batching**: Handle more files per commit
- **Competition-specific commit types**: `wip`, `quick`
- **Streamlined notifications**: Faster timeout periods
- **One-command setup**: Instant competition configuration

### Recommended Usage by Competition Type

| Competition Type | Recommended Profile | Interval | Use Case                            |
| ---------------- | ------------------- | -------- | ----------------------------------- |
| Hackathon        | `hackathon`         | 1-2 min  | Maximum velocity, rapid prototyping |
| Coding Contest   | `sprint`            | 5 min    | Fast development with some quality  |
| Team Sprint      | `collaborative`     | 10 min   | Coordinated team development        |
| Live Coding      | `hackathon`         | 1 min    | Real-time code demonstration        |
