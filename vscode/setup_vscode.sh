#!/bin/bash
shopt -s -o nounset

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPTS_DIR="${HOME}/.config/Code/User/prompts"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log_unchange() {
	printf "%b%s%b\n" "${GREEN}" "$*" "${NC}"
}

log_change() {
	printf "%b%s%b\n" "${RED}" "$*" "${NC}"
}

install_global_instructions() {
	local files=(
		bash.instructions.md
		git.instructions.md
		kerneldev.instructions.md
		python.instructions.md
	)

	mkdir -p "${PROMPTS_DIR}"

	for f in "${files[@]}"; do
		local src="${SCRIPT_DIR}/instructions/${f}"
		local dst="${PROMPTS_DIR}/${f}"
		if [[ ! -f "${dst}" ]] || ! diff -q "${src}" "${dst}" > /dev/null 2>&1; then
			cp "${src}" "${dst}"
			log_change "Updated ${f} -> ${dst}"
		else
			log_unchange "Unchanged ${f}"
		fi
	done
}

install_igt_instructions() {
	local -a igt_dirs
	mapfile -t igt_dirs < <(find "${HOME}/src" -maxdepth 3 -type d -name "igt-gpu-tools*" 2>/dev/null)

	if [[ ${#igt_dirs[@]} -eq 0 ]]; then
		log_change "ERROR: no igt-gpu-tools* directories found under ${HOME}/src" >&2
		return 1
	fi

	for igt_dir in "${igt_dirs[@]}"; do
		mkdir -p "${igt_dir}/.github/instructions"
		local src="${SCRIPT_DIR}/instructions/igt.instructions.md"
		local dst="${igt_dir}/.github/instructions/igt.instructions.md"
		if [[ ! -f "${dst}" ]] || ! diff -q "${src}" "${dst}" > /dev/null 2>&1; then
			cp "${src}" "${dst}"
			log_change "Updated igt.instructions.md -> ${dst}"
		else
			log_unchange "Unchanged igt.instructions.md in ${igt_dir}"
		fi

		local exclude_file="${igt_dir}/.git/info/exclude"
		if [[ -f "${exclude_file}" ]] && ! grep -qxF '.github/' "${exclude_file}"; then
			echo '.github/' >> "${exclude_file}"
			log_change "Added .github/ to ${exclude_file}"
		fi
	done
}

install_global_instructions
install_igt_instructions
