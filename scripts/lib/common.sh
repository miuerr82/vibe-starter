#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTER_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

readonly SCRIPT_DIR
readonly STARTER_ROOT

PROJECT_ROOT=""
WORKSPACE_DIR=""
SPECS_DIR=""
HANDOFF_DIR=""
MILESTONES_DIR=""
MILESTONE_TASKS_DIR=""
FEATURES_DIR=""
LAYOUTS_DIR=""
UI_DIR=""
PROTOTYPES_DIR=""
REPORTS_DIR=""
REPORT_DATA_DIR=""
REPORT_HTML_DIR=""
NOTES_DIR=""
STARTER_ARGS=()

print_line() {
  printf '%s\n' "$1"
}

fail() {
  print_line "$1" >&2
  exit 1
}

setup_project_paths() {
  PROJECT_ROOT="$1"
  WORKSPACE_DIR="${PROJECT_ROOT}/vibe-coding"
  SPECS_DIR="${WORKSPACE_DIR}/specs"
  HANDOFF_DIR="${WORKSPACE_DIR}/handoff"
  MILESTONES_DIR="${WORKSPACE_DIR}/milestones"
  MILESTONE_TASKS_DIR="${MILESTONES_DIR}/tasks"
  FEATURES_DIR="${WORKSPACE_DIR}/features"
  LAYOUTS_DIR="${WORKSPACE_DIR}/layouts"
  UI_DIR="${WORKSPACE_DIR}/ui"
  PROTOTYPES_DIR="${WORKSPACE_DIR}/prototypes"
  REPORTS_DIR="${WORKSPACE_DIR}/reports"
  REPORT_DATA_DIR="${REPORTS_DIR}/data"
  REPORT_HTML_DIR="${REPORTS_DIR}/html"
  NOTES_DIR="${WORKSPACE_DIR}/notes"
}

validate_project_root() {
  local candidate="$1"
  local source_label="${2:-專案根目錄}"
  local starter_in_candidate resolved_starter

  [[ -d "${candidate}" ]] || fail "${source_label}不存在：${candidate}"

  starter_in_candidate="${candidate}/vibe-coding/vibe-starter"
  [[ -d "${starter_in_candidate}" ]] || \
    fail "${source_label} ${candidate} 中找不到 vibe-coding/vibe-starter。"

  resolved_starter="$(cd "${starter_in_candidate}" && pwd)"
  [[ "${resolved_starter}" == "${STARTER_ROOT}" ]] || \
    fail "${source_label} ${candidate} 中的 vibe-coding/vibe-starter 與目前執行的 vibe-starter (${STARTER_ROOT}) 不一致。"
}

resolve_project_root() {
  local -a remaining=()
  local explicit_root=""
  local arg=""
  local cwd_path cwd_starter inferred chosen answer custom_path

  while [[ $# -gt 0 ]]; do
    arg="$1"
    case "${arg}" in
      --project-root)
        shift
        [[ $# -gt 0 ]] || fail "--project-root 需要提供路徑參數。"
        explicit_root="$1"
        shift
        ;;
      --project-root=*)
        explicit_root="${arg#--project-root=}"
        shift
        ;;
      *)
        remaining+=("${arg}")
        shift
        ;;
    esac
  done

  STARTER_ARGS=()
  if [[ ${#remaining[@]} -gt 0 ]]; then
    STARTER_ARGS=("${remaining[@]}")
  fi

  if [[ -n "${explicit_root}" ]]; then
    validate_project_root "${explicit_root}" "--project-root"
    PROJECT_ROOT="$(cd "${explicit_root}" && pwd)"
    return 0
  fi

  cwd_path="$(pwd)"
  cwd_starter="${cwd_path}/vibe-coding/vibe-starter"
  if [[ -d "${cwd_starter}" ]] && \
     [[ "$(cd "${cwd_starter}" && pwd)" == "${STARTER_ROOT}" ]]; then
    PROJECT_ROOT="${cwd_path}"
    return 0
  fi

  inferred="$(cd "${STARTER_ROOT}/../.." && pwd)"

  if [[ -t 0 ]]; then
    print_line "目前不在專案根目錄。" >&2
    print_line "依腳本位置推論出的專案根目錄為：" >&2
    print_line "  ${inferred}" >&2
    if read -r -p "是否使用此路徑？[Y/n/其他絕對路徑]: " answer; then
      :
    else
      answer=""
    fi
    case "${answer}" in
      ""|y|Y|yes|YES)
        chosen="${inferred}"
        ;;
      n|N|no|NO)
        if ! read -r -p "請輸入專案根目錄絕對路徑: " custom_path; then
          fail "未提供專案根目錄路徑。"
        fi
        [[ -n "${custom_path}" ]] || fail "未提供專案根目錄路徑。"
        chosen="${custom_path}"
        ;;
      *)
        chosen="${answer}"
        ;;
    esac
  else
    chosen="${inferred}"
  fi

  validate_project_root "${chosen}" "解析到的專案根目錄"
  PROJECT_ROOT="$(cd "${chosen}" && pwd)"
}

bootstrap_starter() {
  resolve_project_root "$@"
  setup_project_paths "${PROJECT_ROOT}"
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
