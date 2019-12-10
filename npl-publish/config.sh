#!/bin/bash
cur_time=$(date "+%Y%m%d%H%M")
release_qa='/w/Npl/QA'
symbols_qa='/w/Npl/QA/Symbols'

release_offical='/w/Npl/Release'
symbols_offical='/w/Npl/Release/Symbols'

declare -A options=(
    ["ezlib_version"]=""
    ["sdk_version"]=""
    ["stub_version"]=""
    ["clear"]="n"
    ["build"]="all"
    ["sign"]="n"
    ["package"]="y"
)

ezlib_files=(
    "npl-common.dll"
    "npl-net.dll"
    "npl-net_module.dll"
    "npl-database.dll"
)

sdk_files=(
    "npl-base.dll"
    "npl-sdk.dll" 
    "npl-client.exe"
)

launcher_files=(
    "npl-stub.dll" 
    "npl-platform.exe"
)

launcher_files_x86=(
    "npl-launcher32.exe"
    "npl-overlay_renderer32.dll"
)

launcher_files_x64=(
    "npl-launcher64.exe"
    "npl-overlay_renderer64.dll"
)

function log_info()
{
    local msg="$*"
    echo "$msg" >> D:/Cerberus/npl-publish/tools/uploadfile/$cur_time.log
    echo -e "\033[33m$msg\033[0m"
}

function log_error()
{
    local msg="$*"
    echo "$msg" >> D:/Cerberus/npl-publish/tools/uploadfile/$cur_time.log
    echo -e "\033[31m$msg\033[0m"
}

function pause_exit()
{
    echo "Press any key to continue" >> D:/Cerberus/npl-publish/tools/uploadfile/$cur_time.log
    read -rsp $'Press any key to continue...\n' -n1 key
}