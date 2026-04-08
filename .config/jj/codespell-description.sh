#!/usr/bin/env bash
set -euo pipefail

if ! command -v codespell >/dev/null 2>&1; then
    echo "codespell is not installed. Install it first, then rerun 'jj codespell'." >&2
    exit 1
fi

codespell_args=()
if [ -f "$PWD/.codespellrc" ]; then
    codespell_args+=(--config "$PWD/.codespellrc")
fi

overall_status=0
printed_block=0

while IFS= read -r -d $'\x1e' record || [ -n "$record" ]; do
    description="${record#*$'\x1f'}"

    set +e
    if [ "${#codespell_args[@]}" -eq 0 ]; then
        codespell_output="$(
            printf '%s\n' "$description" | codespell --enable-colors --stdin-single-line -
        )"
    else
        codespell_output="$(
            printf '%s\n' "$description" | codespell "${codespell_args[@]}" --enable-colors --stdin-single-line -
        )"
    fi
    codespell_status=$?
    set -e

    if [ "$codespell_status" -ne 0 ]; then
        overall_status=$codespell_status
    fi

    if [ -z "$codespell_output" ]; then
        continue
    fi

    if [ "$printed_block" -eq 1 ]; then
        printf '%s\n' '-'
    fi
    printed_block=1

    printf '%s\n' "$description"
    printf '%s\n' "$codespell_output"
done < <(
    jj log --ignore-working-copy --no-graph -r 'trunk()..@' -T 'commit_id.short() ++ "\x1f" ++ description ++ "\x1e"'
)

exit "$overall_status"
