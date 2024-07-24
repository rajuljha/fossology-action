#!/bin/bash
# Prepare docker run command with arguments
docker_cmd="docker run --rm --name fossologyscanner -w /opt/repo -v ${PWD}:/opt/repo \
    -e GITHUB_TOKEN=${{ inputs.github_token }} \
    -e GITHUB_PULL_REQUEST=${{ inputs.github_pull_request }} \
    -e GITHUB_REPOSITORY=${{ inputs.github_repository }} \
    -e GITHUB_API=${{ inputs.github_api_url }} \
    -e GITHUB_REPO_URL=${{ inputs.github_repo_url }} \
    -e GITHUB_REPO_OWNER=${{ inputs.github_repo_owner }} \
    -e GITHUB_ACTIONS"

if [ "$KEYWORD_CONF_FILE_PATH" != "" ]; then
docker_cmd+=" -v ${{ github.workspace }}/${{ inputs.keyword_conf_file_path }}:/bin/${{inputskeyword_conf_file_path}}"
fi
if [ "${{ inputs.allowlist_file_path }}" != "" ]; then
docker_cmd+=" -v ${{ github.workspace }}/${{ inputs.allowlist_file_path}}:/bin/${{inputsallowlist_file_path }}"
fi
docker_cmd+=" fossology/fossology:scanner /bin/fossologyscanner"
docker_cmd+=" ${{ inputs.scanners }}"
docker_cmd+=" ${{ inputs.scan_mode }}"
# Add additional conditions
if [ "${{ inputs.scan_mode }}" == "differential" ]; then
docker_cmd+=" --tags ${{ inputs.from_tag }} ${{ inputs.to_tag }}"
fi
if [ "${{ inputs.keyword_conf_file_path }}" != "" ]; then
docker_cmd+=" --keyword-conf ${{ inputs.keyword_conf_file_path }}"
fi
if [ "${{ inputs.allowlist_file_path }}" != "" ]; then
docker_cmd+=" --allowlist-path ${{ inputs.allowlist_file_path }}"
fi
if [ "${{ inputs.report_format }}" != "" ]; then
docker_cmd+=" --report ${{ inputs.report_format }}"
fi
# Run the command
echo $docker_cmd
eval $docker_cmd
