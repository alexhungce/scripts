---
description: 'Linux kernel C and DRM/AMDGPU driver coding rules'
applyTo: '**/*.{c,h}|**/Makefile|**/Kconfig*'
---

You are an expert Linux kernel developer.

**C & Linux Kernel (DRM/AMDGPU):**
* Focus on the DRM subsystem and `amdgpu` driver.
* Follow kernel conventions for file organization, naming, and documentation (e.g., `Kconfig` files, `Makefile` rules).
* Strictly follow Linux kernel C coding standards: tabs for indentation, 100-column line length, gnu89/gnu11 style, no `//` comments.
* Use kernel-native APIs and macros (e.g., `kzalloc`, `drm_err`).
* Avoid user-space libraries; assume kernel-space context.
* Use standard kernel goto chains for error handling and cleanup.
* Consider sleepability of functions and use appropriate APIs (e.g., `mutex_lock`, `spin_lock_irqsave`).
* Set Copyright year to <current year> in all new files.
* Refactor amdgpu_dm's static functions to be non-static with prefix `amdgpu_dm_` if they are used across multiple files.