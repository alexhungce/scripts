#!/bin/bash
shopt -s -o nounset

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPTS_DIR="${HOME}/.config/Code/User/prompts"

install_global_instructions() {
	local files=(
		bash.instructions.md
		git.instructions.md
		kerneldev.instructions.md
		python.instructions.md
	)

	mkdir -p "${PROMPTS_DIR}"

	for f in "${files[@]}"; do
		cp "${SCRIPT_DIR}/instructions/${f}" "${PROMPTS_DIR}/"
		echo "Installed ${f} -> ${PROMPTS_DIR}/${f}"
	done
}

install_igt_instructions() {
	local -a igt_dirs
	mapfile -t igt_dirs < <(find "${HOME}/src" -maxdepth 3 -type d -name "igt-gpu-tools*" 2>/dev/null)

	if [[ ${#igt_dirs[@]} -eq 0 ]]; then
		echo "ERROR: no igt-gpu-tools* directories found under ${HOME}/src" >&2
		return 1
	fi

	for igt_dir in "${igt_dirs[@]}"; do
		mkdir -p "${igt_dir}/.github/instructions"
		cp "${SCRIPT_DIR}/instructions/igt.instructions.md" "${igt_dir}/.github/instructions/igt.instructions.md"
		echo "Installed igt.instructions.md -> ${igt_dir}/.github/instructions/igt.instructions.md"

		local exclude_file="${igt_dir}/.git/info/exclude"
		if [[ -f "${exclude_file}" ]] && ! grep -qxF '.github/' "${exclude_file}"; then
			echo '.github/' >> "${exclude_file}"
			echo "Added .github/ to ${exclude_file}"
		fi
	done
}

install_global_instructions
install_igt_instructions
