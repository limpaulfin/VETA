#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV="${ROOT}/.venv"

[ ! -d "${VENV}" ] && python3 -m venv "${VENV}"
source "${VENV}/bin/activate"
[ -f requirements.txt ] && pip install -q -r requirements.txt
python3 "${ROOT}/main-fc70324b.py" "$@"
