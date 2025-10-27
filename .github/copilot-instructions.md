# GitHub Copilot Instructions - Bootcamp Bash (bc_bash)

## Project Overview

This is a comprehensive 8-module Bash scripting bootcamp project designed for learning shell scripting fundamentals through practical exercises and projects.

## Project Structure

- **8 modules**: Inside `bootcamp/` directory - `bootcamp/modulo1/` through `bootcamp/modulo8/`
- **Documentation**: All documentation files go in `_docs/`
- **Scripts**: All utility and automation scripts go in `_scripts/`
- **Exercises**: Each module contains `/ejercicios/` subdirectory
- **Projects**: Each module contains `/proyectos/` subdirectory

## Module Organization

```
bc_bash/
├── _docs/                    # All project documentation
├── _scripts/                 # All utility and automation scripts
├── assets/                   # Logos and visual resources
├── bootcamp/                 # Bootcamp content directory
│   ├── modulo1/             # Module 1: Bash Basics
│   │   ├── ejercicios/      # Hands-on exercises
│   │   ├── proyectos/       # Module projects
│   │   └── README.md        # Module overview
│   ├── modulo2/             # Module 2: Advanced Commands and Pipes
│   ├── modulo3/             # Module 3: Variables and Control Flow
│   ├── modulo4/             # Module 4: Functions and Arrays
│   ├── modulo5/             # Module 5: File Operations and Text Processing
│   ├── modulo6/             # Module 6: Advanced Data Manipulation
│   ├── modulo7/             # Module 7: Optimization and Debugging
│   └── modulo8/             # Module 8: Advanced Projects and Automation
└── README.md                # Main project README
```

## Coding Standards and Best Practices

### Shell Script Guidelines

- Use `#!/bin/bash` shebang for all scripts
- Follow POSIX compliance when possible
- Use meaningful variable names in lowercase with underscores
- Add comments explaining complex logic
- Include error handling with `set -euo pipefail`
- Make scripts executable with proper permissions

### File Naming Conventions

- Scripts: `snake_case.sh`
- Documentation: `kebab-case.md`
- Directories: `lowercase` or `snake_case`
- Examples: `user_input.sh`, `file-operations.md`, `ejercicios/`

### Code Style

- Indent with 2 spaces (no tabs)
- Use double quotes for variables: `"$variable"`
- Prefer `[[ ]]` over `[ ]` for conditionals
- Use `$(command)` instead of backticks
- End lines with LF (Unix line endings)

### Error Handling Pattern

```bash
#!/bin/bash
set -euo pipefail

# Error handling function
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Usage
[[ -f "$file" ]] || error_exit "File not found: $file"
```

## Documentation Standards

### README.md Structure

Each module and project should include:

- Clear description and learning objectives
- Prerequisites and requirements
- Step-by-step instructions
- Expected output examples
- Common troubleshooting tips

### Code Documentation

- Comment complex algorithms and business logic
- Include usage examples in script headers
- Document function parameters and return values
- Add inline comments for non-obvious code

## Module-Specific Guidelines

### Module 1: Bash Basics

- Focus on fundamental commands and syntax
- Simple scripts with basic I/O operations
- Introduction to variables and command substitution
- Basic error handling concepts

### Module 2: Advanced Commands and Pipes

- Command chaining and redirection
- Text processing tools and filters
- Wildcards and pattern matching
- Complex pipe operations

### Module 3: Variables and Control Flow

- Environment variables and parameter expansion
- Conditional statements (if/else, case)
- Loops (for, while, until)
- Script arguments and option parsing

### Module 4: Functions and Arrays

- Function definition and parameter passing
- Local vs global variables
- Array operations and string manipulation
- Function libraries and sourcing

### Module 5: File Operations and Text Processing

- File system operations and permissions
- Text processing with grep, sed, awk
- Regular expressions in Bash
- Data parsing and transformation

### Module 6: Advanced Data Manipulation

- Complex data structures and processing
- CSV, JSON, and XML handling
- Advanced parsing techniques
- Data transformation pipelines

### Module 7: Optimization and Debugging

- Performance optimization techniques
- Debugging and profiling methods
- Security best practices
- Code quality and testing

### Module 8: Advanced Projects and Automation

- Process management and job control
- Debugging and profiling techniques
- Automation patterns and best practices
- Integration with system services

## Exercise Design Principles

### Learning Progression

- Start with simple, single-concept exercises
- Build complexity gradually across modules
- Include both guided and independent exercises
- Provide multiple difficulty levels

### Exercise Structure

```bash
#!/bin/bash
# Exercise: [Title]
# Module: [X]
# Objective: [Learning goal]
# Instructions: [What the student should do]

# Your solution here
```

### Project Guidelines

- Each module should have 1-2 substantial projects
- Projects should integrate multiple concepts from the module
- Include real-world scenarios and use cases
- Provide starter templates and expected outcomes

## Automated Commit Guidelines

This project uses automated conventional commits:

- **feat**: New features, exercises, or projects
- **fix**: Bug fixes and corrections
- **docs**: Documentation updates
- **style**: Code formatting and style improvements
- **test**: Adding or updating tests
- **refactor**: Code restructuring without changing functionality
- **chore**: Maintenance tasks and dependencies

### Scope Mapping

- `module1` through `module8`: Module-specific changes
- `docs`: Documentation in `_docs/`
- `scripts`: Utility scripts in `_scripts/`
- `exercises`: Exercise-related changes
- `projects`: Project-related changes

## AI Assistant Guidelines

### When Creating Exercises

1. Always include clear learning objectives
2. Provide step-by-step instructions
3. Include expected output examples
4. Add common pitfalls and troubleshooting
5. Ensure exercises build upon previous concepts

### When Writing Scripts

1. Follow the established coding standards
2. Include proper error handling
3. Add meaningful comments and documentation
4. Test scripts for common edge cases
5. Ensure cross-platform compatibility when possible

### When Updating Documentation

1. Keep language clear and beginner-friendly
2. Include practical examples and use cases
3. Update related documentation when making changes
4. Maintain consistency across modules
5. Use proper Markdown formatting

## File Organization Rules

### Documentation Placement

- Project-wide docs → `_docs/`
- Module-specific docs → `moduloX/README.md`
- Exercise docs → `moduloX/ejercicios/README.md`
- Project docs → `moduloX/proyectos/[project-name]/README.md`

### Script Placement

- Automation/utility scripts → `_scripts/`
- Exercise solution scripts → `moduloX/ejercicios/`
- Project scripts → `moduloX/proyectos/[project-name]/`
- Module-specific tools → `moduloX/tools/` (if needed)

### Asset Organization

- Images and diagrams → `_docs/assets/`
- Data files for exercises → `moduloX/data/`
- Configuration files → `_scripts/config/`
- Templates → `_docs/templates/`

## Quality Assurance

### Before Committing

- Test all scripts on multiple environments
- Verify documentation links and references
- Check code style and formatting
- Ensure exercises have clear solutions
- Validate markdown syntax

### Review Checklist

- [ ] Follows established naming conventions
- [ ] Includes proper documentation
- [ ] Scripts are executable and error-free
- [ ] Educational value is clear
- [ ] Fits within module progression
- [ ] Uses conventional commit format

Remember: This is an educational project focused on practical Bash scripting skills. Every script, exercise, and project should contribute to the learning journey while maintaining professional coding standards.
