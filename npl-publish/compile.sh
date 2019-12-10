#!/bin/bash
. config.sh

# add_symbols $symbol_path $symbol_root $symbol_info $version 
function add_symbols()
{
    # 添加symbol文件到指定目录
    local symbol_path=$1
    local version=$4

    $cur_dir/tools/7z.exe a $cur_dir/symbols/$project-$date-v$version.zip -tzip $symbol_path
    winpty $cur_dir/tools/symstore.cmd $@
}

function add_signature()
{
    winpty $cur_dir/tools/csigntool.cmd $@
}

# product name is "Boltrend Platform"
# add_property $file $file_version $product_name $product_version $commitId
function add_property()
{
    local file=$1
    local file_version=$2

    local product_name=$3
    local product_version=$4

    local commitId=$5

    echo "*** update $file properties ***"
    echo "  - FileVersion:          $file_version"
    echo "  - ProductName：         $product_name"
    echo "  - ProductVersion：      $product_version"
    echo "  - Commit ID:            $commitId $date"
    echo "  - LegalCopyright：  © Boltrend Corporation. All rights reserved."

    $cur_dir/tools/rcedit.exe $file --set-file-version "$file_version"
    $cur_dir/tools/rcedit.exe $file --set-product-version "$product_version"
    $cur_dir/tools/rcedit.exe $file --set-version-string "ProductName" "$product_name"
    $cur_dir/tools/rcedit.exe $file --set-version-string "LegalCopyright" "© Boltrend Corporation. All rights reserved."
    $cur_dir/tools/rcedit.exe $file --set-version-string "FileDescription" "$commitId $date"
}

# add_tag $version $tagid 
function add_tag()
{
    local version=$1
    local tagid=$2
    local tagname=$version

    if [ -z $tagid ]; then
        log_error "commit id doesn't exist"
        return 1
    fi

    if [ $(git tag -l "v$version") ]; then
        log_error "Error - tag v$version has been exist. this version is released."
        return 2
    fi

    pwd
    git tag --message="$version $date" --force $tagname $tagid
    echo "git tag --message=\"$version $date\" --force $tagname $tagid ===>>>> $?"
    if [ $? != 0 ]; then
        return 3
    fi

    git push -f origin $tagname
    echo "git push origin -f $tagname ===>>> $?"
    if [ $? != 0 ]; then
        return 3
    fi

    echo "$version $tagid" > version

    log_info "add tag successful."
}

# check_version $branch $version
function check_version()
{
    local branch=$1
    local version=$2
    local relative=$3

    # 取本地文件
    if [ -f "version" ]; then
        local version_info=($(cat version))
    fi

    # 取分支和提交指针
    git_branch=$(git symbolic-ref --short -q HEAD)

    if [ "$branch" != "$git_branch" ]; then
        log_error "发布所请求的分支不一致。请求发布$branch, 当前分支$git_branch"
        return 1
    fi

    # 判断是否有未提交的代码
    if [ "$check" != "false" ] && [[ ! -z "$(git status --porcelain)" ]]; then
        log_error "本地有未提交的代码！"
        return 1
    fi

    # 判断本地分支是否与远程分支一致
    git_commit=$(git rev-parse HEAD)
    git_commit_origin=$(git rev-parse origin/$git_branch)

    if [ "$check" != "false" ] && [ "$git_commit" != "$git_commit_origin" ]; then
        log_error "本地分支与远程分支不一致！"
        return 1
    fi

    # 检查本次发布与上次发布的版本是否一致
    if [ -n "${version_info[*]}" ]; then
        if [ "$version" == ${version_info[0]} ] && [ "$git_commit" == "${version_info[1]}" ]; then
            log_info "提交指针较上次发布无任何变更！"
            return 1
        fi
    fi

    return 0
}

# setup_ezlib $platform $version $commitId
function setup_ezlib()
{
    local platform=$1
    local version=$2
    local commitId=$3

    for file in ${ezlib_files[@]}; do
        # add symbol file
        echo "*** store symbol file ***"
        add_symbols ../ezlib/bin/Release-$platform/${file%.*}.pdb $symbols_qa $commitId $version

        echo "*** update version info ***"
        add_property ../ezlib/bin/Release-$platform/$file $version "Boltrend EZLIB." $version $commitId

        # signature
        echo "*** signature for $file ***"
        add_signature ../ezlib/bin/Release-$platform/$file
        echo "*** end of file ***"
    done
}

#build_ezlib $branch $version
function build_ezlib()
{
    local branch=$1
    local version=$2

    cd $cur_dir/../ezlib

    log_info "$version"
    if [ -z "$version" ]; then 
        log_error "你必须为EZLib指定一个版本号。"
        return 1
    fi

    # check version 
    check_version $branch $version

    if [ "$?" != "0" ]; then
        log_error "未能通过版本校验。"
        return 1
    fi

    # compile ezlib.
    winpty $cur_dir/build_basic.bat build win32 Release
    if [ "$?" != "0" ]; then
        log_error "EZLIB构建错误!"
        return 1
    fi

    winpty $cur_dir/build_basic.bat build x64 Release 
    if [ "$?" != "0" ]; then
        log_error "EZLIB构建错误!"
        return 1
    fi

    setup_ezlib x86 $version $git_commit
    setup_ezlib x64 $version $git_commit

    if [ "$branch" == "master" ]; then
        add_tag $version $git_commit
        if [ "$?" != "0" ]; then
            log_error "add tag error!"
            return 1
        fi
    fi

    cd $cur_dir
}

# setup_sdk $platform $version $commitId
function setup_sdk()
{
    local platform=$1
    local version=$2
    local commitId=$3

    for file in ${sdk_files[@]}; do
        # add symbol file
        echo "*** store symbol file ***"
        add_symbols $cur_dir/../npl-sdk-prj/bin/$platform/Release/${file%.*}.pdb $symbols_qa $commitId $version

        echo "*** update version info ***"
        add_property $cur_dir/../npl-sdk-prj/bin/$platform/Release/$file $version "Boltrend NPL SDK." $version $commitId

        # signature
        echo "*** signature for $file ***"
        add_signature $cur_dir/../npl-sdk-prj/bin/$platform/Release/$file
    done
}

# build_sdk $branch $version
function build_sdk()
{
    local branch=$1
    local version=$2

    cd $cur_dir/../npl-sdk-prj

    log_info "$version"
    if [ -z "$version" ]; then 
        log_error "你必须为SDK指定一个版本号。"
        return 1
    fi

    # 检查分支和版本
    check_version $branch $version
    
    if [ "$?" != "0" ]; then
        log_error "未能通过版本校验，请检查分支是否已与远程代码同步。"
        return 1
    fi

    # 编译SDK
    winpty $cur_dir/build_sdk.bat build win32 Release 
    if [ "$?" != "0" ]; then
        log_error "build x86 npl-sdk failed!"
        return 1
    fi

    winpty $cur_dir/build_sdk.bat build x64 Release 
    if [ "$?" != "0" ]; then
        log_error "build x64 npl-sdk failed!"
        return 1
    fi

    setup_sdk x86 $version $git_commit
    setup_sdk x64 $version $git_commit

    if [ "$branch" == "master" ]; then
        add_tag $version $git_commit
        if [ "$?" != "0" ]; then
            log_error "add tag error!"
            return 1
        fi
    fi

    cd $cur_dir
}

# build_demo $branch $version
function build_demo()
{
    local branch=$1
    local version=$2

    echo "build csharp"
    cd $cur_dir
    cp -d $cur_dir/../ezlib/bin/Release-x86/npl-common.dll $cur_dir/../npl-sdk-prj/npl-sdk-csharp/Assets/Plugins/x86
    cp -d $cur_dir/../ezlib/bin/Release-x64/npl-common.dll $cur_dir/../npl-sdk-prj/npl-sdk-csharp/Assets/Plugins/x86_64
    cp -d $cur_dir/../ezlib/bin/Release-x86/npl-net.dll    $cur_dir/../npl-sdk-prj/npl-sdk-csharp/Assets/Plugins/x86
    cp -d $cur_dir/../ezlib/bin/Release-x64/npl-net.dll    $cur_dir/../npl-sdk-prj/npl-sdk-csharp/Assets/Plugins/x86_64
    cp -d $cur_dir/../npl-sdk-prj/bin/X86/Release/npl-sdk.dll    $cur_dir/../npl-sdk-prj/npl-sdk-csharp/Assets/Plugins/x86
    cp -d $cur_dir/../npl-sdk-prj/bin/X64/Release/npl-sdk.dll    $cur_dir/../npl-sdk-prj/npl-sdk-csharp/Assets/Plugins/x86_64
    cp -d $cur_dir/../npl-sdk-prj/bin/X86/Release/npl-base.dll   $cur_dir/../npl-sdk-prj/npl-sdk-csharp/Assets/Plugins/x86
    cp -d $cur_dir/../npl-sdk-prj/bin/X64/Release/npl-base.dll   $cur_dir/../npl-sdk-prj/npl-sdk-csharp/Assets/Plugins/x86_64

    winpty $cur_dir/build_unity.bat
    if [ "$?" != "0" ]; then
        log_error "build unity demo failed!"
        return 1
    fi
}

# setup_launcher $platform $version $commit
function setup_launcher()
{
    local platform=$1
    local version=$2
    local commit=$3

    launcher_platform_files=$(eval echo '${'"launcher_files_$platform"'[@]}')

    for file in ${launcher_files[@]} ${launcher_platform_files[@]}; do
        # add symbol file
        echo "*** store symbol file ***"
        add_symbols $cur_dir/../npl-launcher/bin/$platform/Release/${file%.*}.pdb $symbols_qa $commit $version

        echo "*** update version info ***"
        add_property $cur_dir/../npl-launcher/bin/$platform/Release/$file $version "Boltrend Stub for NGL." $version $commit

        # signature
        echo "*** signature for $file ***"
        add_signature $cur_dir/../npl-launcher/bin/$platform/Release/$file
    done
}

function build_stub()
{
    local branch=$1
    local version=$2

    cd $cur_dir/../npl-launcher

    log_info "$version"
    if [ -z "$version" ]; then 
        log_error "你必须为Launcher指定一个版本号。"
        return 1
    fi

    # 检查分支和版本
    check_version $branch $version
    
    if [ "$?" != "0" ]; then
        log_error "未能通过版本校验，请检查分支是否已与远程代码同步。"
        return 1
    fi

    winpty $cur_dir/build_launcher.bat build win32 Release 
    if [ "$?" != "0" ]; then
        log_error "build x86 npl-launcher failed!"
        return 1
    fi

    winpty $cur_dir/build_launcher.bat build x64 Release 
    if [ "$?" != "0" ]; then
        log_error "build x64 npl-launcher failed!"
        return 1
    fi

    setup_launcher x86 $version $git_commit
    setup_launcher x64 $version $git_commit

    if [ "$branch" == "master" ]; then
        add_tag $version $git_commit
        if [ "$?" != "0" ]; then
            log_error "add tag error!"
            return 1
        fi
    fi

    cd $cur_dir
}

# compile $project $branch $version
function compile()
{
    local project=$1
    local branch=$2
    local version=$3

    log_info '------------------------------'
    log_info "build project $project"

    cd $cur_dir
    mkdir -p $cur_dir/symbols/

    date=`date '+%Y%m%d%H%M%S'`

    case $project in
        ezlib)
            build_ezlib $branch $version
        ;;
        
        sdk)
            build_sdk $branch $version
        ;;

        demo)
            build_demo $branch $version
        ;;

        stub)
            build_stub $branch $version
        ;;
        
        *)
            log_error "module doesn't exist."
            return 1
        ;;
    esac
}

if [ -z "$publish" ]; then
    cur_dir=$(cd "$(dirname "$0")";pwd)
    compile $@
fi