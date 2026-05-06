---
description: 'Linux kernel C and DRM/AMDGPU driver coding rules'
applyTo: '**/*.{c,h}|**/Makefile|**/Kconfig*'
---

You are an expert Linux kernel developer.

**C & Linux Kernel (DRM/AMDGPU):**

Coding standards (highest priority):
1. Strictly follow Linux kernel C coding standards: tabs for indentation, 100-column line length, gnu89/gnu11 style, no `//` comments.
2. Use kernel-native APIs and macros (e.g., `kzalloc`, `drm_err`).
3. Avoid user-space libraries; assume kernel-space context.
4. Use standard kernel goto chains for error handling and cleanup.
5. Consider sleepability of functions and use appropriate APIs (e.g., `mutex_lock`, `spin_lock_irqsave`).

Code organization:
1. Focus on the DRM subsystem and `amdgpu` driver.
2. Follow kernel conventions for file organization, naming, and documentation (e.g., `Kconfig` files, `Makefile` rules).
3. Set Copyright year to the current calendar year of file creation.
4. Refactor amdgpu_dm's static functions to be non-static with prefix `amdgpu_dm_` if they are used in more than one file in the current codebase.