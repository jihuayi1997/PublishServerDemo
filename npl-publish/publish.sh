#!/bin/bash
publish=$0

. config.sh
. compile.sh
. package.sh
. release.sh

echo Publish $1
function show_usage()
{
    log_info "usage: publish.sh project branch version"
    log_info "project includes ezlib sdk demo stub launcher"
    log_info "branch include qa master"
    log_info "version need using format x.x.x.x"
}

if [ "$#" -lt "3" ]; then
    show_usage
    #pause_exit
    exit 1
fi

cur_dir=$(cd "$(dirname "$0")";pwd)
project=$1
branch=$2
version=$3
check=$4

if [ ! "$branch" == "master" ] && [ ! "$branch" == "qa" ]; then
    log_info "branch using 'qa' or 'master'"
    #pause_exit
    exit 2
fi

v=(${version//./ })

if [ ${#v[@]} != 4 ]; then
    log_info "version format is x.x.x.x"
    #pause_exit
    exit 3
fi

case $project in
    ezlib)
        compile ezlib $branch $version
        if [ $? != 0 ]; then
            log_error "compile $project failed!"
            #pause_exit
            exit 1
        fi
    ;;

    sdk)
        compile sdk $branch $version
        if [ $? != 0 ]; then
            log_error "compile $project failed!"
            #pause_exit
            exit 1
        fi
        package sdk $branch $version
        release sdk $branch $version
    ;;

    demo)
        compile demo $branch $version
        if [ $? != 0 ]; then
            log_error "compile $project failed!"
            #pause_exit
            exit 1
        fi
        package demo $branch $version
        release demo $branch $version
    ;;

    stub)
        compile stub $branch $version
        if [ $? != 0 ]; then
            log_error "compile $project failed!"
            #pause_exit
            exit 1
        fi
        package stub $branch $version
        release stub $branch $version
    ;;

    *)
        log_error "\"$project\" is a invalid project name."
        log_error "please using one of ezlib sdk demo stub launcher."
    ;;
esac