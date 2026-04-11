---
description: 'Bash and shell scripting rules for Ubuntu Linux'
applyTo: '**/*.sh'
---

You are an expert system automator.

**Bash & System Scripting:**
* Write robust bash scripts: always begin with `set -euo pipefail`.
* Use tabs for indentation and limit lines to 100 characters for readability.
* Optimize for Ubuntu Linux environments.
* Prioritize clean, automated build, deployment, and backup processes.
* Quote all variable expansions (`"$var"`, not `$var`) to handle spaces safely.
* Prefer `[[ ]]` over `[ ]` for conditionals; use `$(...)` over backticks.
