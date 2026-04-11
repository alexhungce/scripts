---
description: 'IGT GPU Tools (igt-gpu-tools) test and library coding rules'
applyTo: 'tests/**/*.{c,h}|lib/**/*.{c,h}|benchmarks/**/*.{c,h}|tools/**/*.{c,h}|**/meson.build'
---

You are an expert IGT GPU Tools developer.

**IGT General:**
* Follow Linux kernel C coding style: tabs for indentation, 100-column line length, gnu89/gnu11 style, no `//` comments.
* Use Meson as the build system; prefer it over legacy Autotools.
* Run `checkpatch.pl --emacs --strict --show-types --max-line-length=100 --ignore=BIT_MACRO,SPLIT_STRING,LONG_LINE_STRING,BOOL_MEMBER` before submitting patches.
* Submit patches to `igt-dev@lists.freedesktop.org` with `--subject-prefix="PATCH i-g-t"` (auto-configured by `meson.sh`).
* Format patch subjects as `tests/test-name: short description` or `lib/lib-name: short description`.

**Test Structure:**
* Each test is a standalone executable (one `.c` file under `tests/`) built and run by `igt_runner`.
* Organize subtests with `igt_subtest`, `igt_fixture`, and `igt_subtest_group`; use `igt_subtest_with_dynamic` when the subtest set is not known at compile time.
* Use hyphens (`-`) as word separators in subtest and test names, never underscores.
* Document every test and subtest with structured testplan comments (preferred over legacy `igt_describe()`):
  ```c
  /**
   * TEST: brief description of the test program
   * Mega-feature: <driver feature area>
   * Sub-category: <category>
   *
   * SUBTEST: subtest-name
   * Description: What is being validated (focus on intent, not implementation).
   */
  ```
* Do **not** use deprecated documentation fields: `Functionality`, `Test category`, `Run type`.
* Descriptions must capture the spirit of the test (why it exists), not a C-to-English translation.

**Test Flow Macros:**
* Use `igt_assert*` (`igt_assert_eq`, `igt_assert_fd`, etc.) to fail a subtest on unexpected results.
* Use `igt_require*` to skip a subtest when a prerequisite is not met (driver feature absent, hardware not present).
* Use `igt_skip` for explicit, conditional skips.
* Use `igt_info` / `igt_debug` for diagnostic output; never use raw `printf` in tests.

**Library (`lib/`) Rules:**
* Write a new library function only when it will have at least two distinct callers (tests or tools).
* If a library function internally uses `igt_assert` / `igt_require` / `igt_skip`, also provide a `__function()` variant that omits those macros and returns an error code instead, for use in non-test contexts.
* `igt_runner` must not call lib functions; keep runner code independent of the IGT library.
* Tools under `tools/` should report errors via `fprintf(stderr, ...)` and exit gracefully—do not use IGT test-flow macros.

**Kernel Interface Compatibility:**
* Tests that exercise kernel uapi, sysfs, or debugfs interfaces must include fallback paths for older stable kernels when a newer interface may not be present.
