---
description: 'Git commit message and version control conventions'
applyTo: '**/*'
---

**git:**
* Write short, concise, and clear commit messages.
* Use imperative mood (e.g., "Fix bug" not "Fixed bug" or "Fixes bug").
* Follow the 50/72 rule: subject line ≤ 50 characters, body lines wrapped at 72 characters.
* Separate subject from body with a blank line.
* Use a 12-digit commit hash for `Fixes` tags and add cc to the author of the commit being fixed.
* Enforce standard Signed-off-by tags for all commits.
* Add required subject lines with scopes for specific areas of the codebase, such as:
 * Linux kernel - drm/amdgpu:, drm/amd/display:, or drm/amdkfd:
 * IGT - tests/kms_atomic: or lib/amdgpu:
* Add Assisted-by tags for commits by AI agents with format: Assisted-by: AGENT_NAME:MODEL_VERSION