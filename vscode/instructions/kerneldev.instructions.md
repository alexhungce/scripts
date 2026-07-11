---
description: 'Linux kernel C and DRM/AMDGPU driver coding rules'
applyTo: '**/*.{c,h}|**/Makefile|**/Kconfig*'
---

**C & Linux Kernel (DRM/AMDGPU):**

Coding standards (highest priority):
1. Strictly follow Linux kernel C coding standards:
   - tabs for indentation
   - 100-column line length
   - no trailing whitespace
   - gnu89/gnu11 style, no `//` comments.
   - no typedefs for structs, unions, or enums; use `struct foo` directly
   - exported symbol names fewer than 55 characters (modpost limit)
   - K&R brace style
   - `if (x)` vs `foo(x)` spacing (space before `(` for keywords, none for functions)
   - spaces around binary operators (`a = b + c`)
   - no parentheses around return value: `return x;` not `return(x);`
   - use `NULL` for null pointers, `bool` for boolean values
2. Use kernel-native APIs and macros (e.g., `kzalloc`, `drm_err`).
3. Avoid user-space libraries; assume kernel-space context.
4. Use standard kernel goto chains for error handling and cleanup.
5. Consider sleepability of functions and use appropriate APIs (e.g., `mutex_lock`, `spin_lock_irqsave`).
6. Use kernel-doc format (Documentation/doc-guide/kernel-doc.rst) for functions if any documentation is needed.
 * ./scripts/kernel-doc -v -none <source_file.c> can be used to validate the kernel-doc comments.
```c
  /**
   * function_name() - Brief description of function.
   * @arg1: Describe the first argument.
   * @arg2: Describe the second argument.
   *        One can provide multiple line descriptions
   *        for arguments.
   *
   * A longer description, with more discussion of the function function_name()
   * that might be useful to those using or modifying it. Begins with an
   * empty comment line, and may include additional embedded empty
   * comment lines.
   *
   * The longer description may have multiple paragraphs.
   *
   * Context: Describes whether the function can sleep, what locks it takes,
   *          releases, or expects to be held. It can extend over multiple
   *          lines.
   * Return: Describe the return value of function_name.
   *
   * The return value description can also have multiple paragraphs, and should
   * be placed at the end of the comment block.
   */
```
7. When a function declaration or call exceeds 100 columns:
   - Break arguments so each appears on its own line.
   - Align continuation lines to the column after the opening parenthesis.
   - Use tabs first, then spaces to reach the alignment column.

Code organization:
1. Focus on the DRM subsystem and `amdgpu` driver.
2. Follow kernel conventions for file organization, naming, and documentation (e.g., `Kconfig` files, `Makefile` rules).
3. Set Copyright year to the current calendar year of file creation.
4. Refactor amdgpu_dm's static functions to be non-static with prefix `amdgpu_dm_` if they are used in more than one file in the current codebase.