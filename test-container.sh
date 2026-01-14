#! /bin/bash

set -Eeuxo pipefail

: "${workspace_location:=.}"
: "${component_to_analyze:=platform::ZCU102.Impl}"
: "${project_path:=}"
: "${output_path:=./Resolute_output.json}"
: "${validation_only:=}"
: "${csv_output:=}"
: "${exit_on_warning:=}"
: "${supplementary_aadl:=}"
: "${GITHUB_WORKSPACE:=/home/runner/work}"

docker run --rm -v $1:${GITHUB_WORKSPACE} \
    -v ./:/home/runner \
    -e GITHUB_WORKSPACE=${GITHUB_WORKSPACE} \
    -e GITHUB_OUTPUT='/dev/stdout' \
    --entrypoint /home/runner/entrypoint.sh \
    ghcr.io/loonwerks/inspecta-tools:4.20250825.20d1bda \
    "${workspace_location}" "${component_to_analyze}" "${project_path}" "${output_path}" \
    "${validation_only}" "${csv_output}" "${exit_on_warning}" "${supplementary_aadl}"

