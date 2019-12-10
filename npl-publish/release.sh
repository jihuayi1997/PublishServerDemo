#!/bin/bash
. config.sh

function release()
{
    local project=$1
    local branch=$2
    local version=$3

    local release_dir=$release_qa

    if [ "$branch" == "master" ]; then
        release_dir=$release_offical
    fi

    mkdir -p $release_dir/$project/
    log_info Release $project $branch $version
    case $project in
        sdk)
            cp -d $cur_dir/package/$project/npl-$date-v$version-base.zip $release_dir/$project/
            cp -d $cur_dir/package/$project/npl-$date-v$version-sdk.zip  $release_dir/$project/
        ;;

        demo)
            cp -d $cur_dir/package/$project/npl-$date-v$version-demo.zip $release_dir/$project/
        ;;

        stub)
            cp -d $cur_dir/package/$project/npl-$date-v$version-stub.zip $release_dir/$project/
            cp -d $cur_dir/package/$project/npl-$date-v$version-platform-x86.zip $release_dir/$project/
            cp -d $cur_dir/package/$project/npl-$date-v$version-platform-x64.zip $release_dir/$project/
        ;;

        *)
            log_error "$project is not a valid package name."
        ;;
    esac
}

if [ -z $publish ]; then
    cur_dir=$(cd "$(dirname "$0")";pwd)
    echo $@
    release $@
fi