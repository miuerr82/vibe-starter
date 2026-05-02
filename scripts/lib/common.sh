#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTER_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
PROJECT_ROOT="$(pwd)"
WORKSPACE_DIR="${PROJECT_ROOT}/vibe-coding"
SPECS_DIR="${WORKSPACE_DIR}/specs"
HANDOFF_DIR="${WORKSPACE_DIR}/handoff"
MILESTONES_DIR="${WORKSPACE_DIR}/milestones"
MILESTONE_TASKS_DIR="${MILESTONES_DIR}/tasks"

readonly SCRIPT_DIR
readonly STARTER_ROOT
readonly PROJECT_ROOT
readonly WORKSPACE_DIR
readonly SPECS_DIR
readonly HANDOFF_DIR
readonly MILESTONES_DIR
readonly MILESTONE_TASKS_DIR

print_line() {
  printf '%s\n' "$1"
}

fail() {
  print_line "$1" >&2
  exit 1
}

ensure_project_root() {
  if [[ ! -d "${PROJECT_ROOT}/vibe-coding/vibe-starter" ]]; then
    fail "找不到 ./vibe-coding/vibe-starter，請從產品專案根目錄執行。"
  fi

  if [[ "$(cd "${PROJECT_ROOT}/vibe-coding/vibe-starter" && pwd)" != "${STARTER_ROOT}" ]]; then
    fail "目前執行位置與腳本所在的 vibe-starter 不一致，請回到產品專案根目錄後重試。"
  fi
}

ensure_dir() {
  mkdir -p "$1"
}

append_unique_line() {
  local file_path="$1"
  local expected_line="$2"

  touch "${file_path}"
  if ! grep -Fxq "${expected_line}" "${file_path}"; then
    printf '%s\n' "${expected_line}" >> "${file_path}"
  fi
}

prompt_yes_no() {
  local prompt="$1"
  local answer

  while true; do
    if ! read -r -p "${prompt} [y/N]: " answer; then
      return 1
    fi
    case "${answer}" in
      y|Y|yes|YES) return 0 ;;
      n|N|no|NO|"") return 1 ;;
      *) print_line "請輸入 y 或 n。" ;;
    esac
  done
}

handle_existing_file() {
  local target_path="$1"
  local alt_path_var="$2"

  printf -v "${alt_path_var}" '%s' ""

  if [[ ! -e "${target_path}" ]]; then
    return 0
  fi

  print_line "檔案已存在，是否覆寫？"
  if prompt_yes_no "> ${target_path}"; then
    return 0
  fi

  while true; do
    local choice
    if ! read -r -p "若不覆寫，請選擇：提供其他檔名 / 略過 [rename/skip]: " choice; then
      return 2
    fi
    case "${choice}" in
      rename)
        local dir_path alt_name
        dir_path="$(dirname "${target_path}")"
        if ! read -r -p "請提供其他檔名（預設保留在 ${dir_path}/ 下）: " alt_name; then
          return 2
        fi
        [[ -n "${alt_name}" ]] || {
          print_line "檔名不可為空。"
          continue
        }
        printf -v "${alt_path_var}" '%s' "${dir_path}/${alt_name}"
        return 1
        ;;
      skip)
        return 2
        ;;
      *)
        print_line "請輸入 rename 或 skip。"
        ;;
    esac
  done
}

copy_template_with_conflict_policy() {
  local source_path="$1"
  local target_path="$2"
  local summary_var="$3"
  local alt_path=""
  local status=0
  local existed_before="false"

  ensure_dir "$(dirname "${target_path}")"

  if [[ -e "${target_path}" ]]; then
    existed_before="true"
    handle_existing_file "${target_path}" alt_path || status=$?
    case "${status}" in
      1)
        ensure_dir "$(dirname "${alt_path}")"
        cp "${source_path}" "${alt_path}"
        printf -v "${summary_var}" '%s' "改名: ${alt_path}"
        return 0
        ;;
      2)
        printf -v "${summary_var}" '%s' "略過: ${target_path}"
        return 0
        ;;
      *)
        ;;
    esac
  fi

  cp "${source_path}" "${target_path}"
  if [[ "${existed_before}" == "true" ]]; then
    printf -v "${summary_var}" '%s' "覆寫: ${target_path}"
  else
    printf -v "${summary_var}" '%s' "建立: ${target_path}"
  fi
}

print_summary() {
  local title="$1"
  shift

  print_line "${title}"
  for item in "$@"; do
    print_line "- ${item}"
  done
}
