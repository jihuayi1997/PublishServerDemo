#!/bin/bash
. config.sh

#package_stub_binary $platform $target_dir
function package_stub_binary()
{
    echo "copy npl-stub-binary"
    cd $cur_dir 
    local platform=$1
    local target_dir=$2

    # create package directory
    mkdir -p $target_dir/
    mkdir -p $target_dir/deps/
    mkdir -p $target_dir/deps/x64
    mkdir -p $target_dir/deps/x86

    # copy files from source directory
    cp -d $cur_dir/../ezlib/bin/Release-$platform/npl-common.dll                    $target_dir/
    cp -d $cur_dir/../ezlib/bin/Release-$platform/npl-net.dll                       $target_dir/
    cp -d $cur_dir/../ezlib/bin/Release-$platform/npl-net_module.dll                $target_dir/
    cp -d $cur_dir/../npl-launcher/bin/x86/Release/npl-overlay_renderer32.dll       $target_dir/
    cp -d $cur_dir/../npl-launcher/bin/x64/Release/npl-overlay_renderer64.dll       $target_dir/
    cp -d $cur_dir/../npl-launcher/bin/x86/Release/npl-launcher32.exe               $target_dir/
    cp -d $cur_dir/../npl-launcher/bin/x64/Release/npl-launcher64.exe               $target_dir/

    cp -d $cur_dir/../npl-launcher/bin/$platform/Release/npl-stub.dll               $target_dir/

    # copy dependence
    cp -rd $cur_dir/../dependence/nim/bin/$platform/*.dll                           $target_dir/
    cp -rd $cur_dir/../dependence/cc_voice/bin/*                                    $target_dir/
    cp -rd $cur_dir/../dependence/d3d/DLL/x64/*                                     $target_dir/deps/x64/
    cp -rd $cur_dir/../dependence/d3d/DLL/x86/*                                     $target_dir/deps/x86/
}

#package_stub $target_dir $target_zip
function package_stub()
{
    echo "###############################################################"
    echo "package stub library"

    cd $cur_dir
    local version=$1
    local target_dir=$2
    local target_zip=$3

    echo package stub to $target_dir ....

    mkdir -p $target_dir/
    mkdir -p $target_dir/include
    mkdir -p $target_dir/lib/x86
    mkdir -p $target_dir/lib/x64
    mkdir -p $target_dir/bin/x86
    mkdir -p $target_dir/bin/x64

    package_stub_binary x86 $target_dir/bin/x86
    package_stub_binary x64 $target_dir/bin/x64

    cp -rd $cur_dir/../dependence/luajit/bin/x86/*.dll                  $target_dir/bin/x86
    cp -rd $cur_dir/../dependence/luajit/bin/x64/*.dll                  $target_dir/bin/x64

    cp -d $cur_dir/../npl-launcher/npl-stub/npl-stub.h                  $target_dir/include/
    cp -d $cur_dir/../npl-launcher/npl-stub/npl-stub-macro.h            $target_dir/include/
    cp -d $cur_dir/../npl-launcher/npl-stub/npl-stub-interface.h        $target_dir/include/

    cp -d $cur_dir/../npl-launcher/lib/x86/Release/npl-stub.lib         $target_dir/lib/x86/
    cp -d $cur_dir/../npl-launcher/lib/x64/Release/npl-stub.lib         $target_dir/lib/x64/

    $cur_dir/tools/7z.exe a $target_zip -tzip $target_dir
}

#package_launcher $platform $target_dir $target_zip
function package_launcher()
{
    local version=$1
    local platform=$2
    local target_dir=$3
    local target_zip=$4

    cd $cur_dir

    # create package directory
    mkdir -p $target_dir/
    mkdir -p $target_dir/overlay-ui/

    package_stub_binary $platform $target_dir

    # copy files from source directory
    cp -rd $cur_dir/../npl-launcher/bin/$platform/Release/npl-platform.exe  $target_dir/
    cp -rd $cur_dir/../dependence/luajit/bin/$platform/*.dll                $target_dir/
    cp -rd $cur_dir/npl-platform/*                                          $target_dir/

    # copy overlay ui component
    cp -rd /W/Npl/overlay-ui/overlay-ui/*                                   $target_dir/overlay-ui/ | grep -v .git

    # copy htmlsurface component
    # if [ "$platform" == "x86" ]; then
        # cp -rd $cur_dir/../dependence/htmlsurface/*                         $target_dir
    # fi
	cp -rd $cur_dir/../dependence/htmlsurface/*                         $target_dir

    rm -rf $target_dir/overlay-ui/.git
    
    rm -rf $target_dir/npl*.ini
    cp -rd $cur_dir/npl-platform/npl_eu.ini                                 $target_dir/npl.ini

    $cur_dir/tools/7z.exe a $target_zip -tzip $target_dir
}

# package_base $target_dir $target_zip
function package_base()
{
    echo "###################################################################################################################"
    echo "copy npl-base"

    local version=$1
    local target_dir=$2
    local target_zip=$3

    cd $cur_dir 
    mkdir -p $target_dir
    echo package base to $target_dir

    function copy_files() 
    {
        local platform=$1

        mkdir -p $target_dir/bin/$platform/
        mkdir -p $target_dir/lib/$platform/

        cp -d $cur_dir/../ezlib/bin/Release-$platform/npl-common.dll       $target_dir/bin/$platform/
        cp -d $cur_dir/../ezlib/bin/Release-$platform/npl-net.dll          $target_dir/bin/$platform/
        cp -d $cur_dir/../npl-sdk-prj/bin/$platform/Release/npl-base.dll   $target_dir/bin/$platform/
        cp -d $cur_dir/../npl-sdk-prj/lib/$platform/Release/npl-base.lib   $target_dir/lib/$platform/
    }

    copy_files x86
    copy_files x64

    mkdir -p $target_dir/include/
    cp -rd ../npl-sdk-prj/npl-base/npl-app.h                    $target_dir/include/
    cp -rd ../npl-sdk-prj/npl-base/npl-base.h                   $target_dir/include/
    cp -rd ../npl-sdk-prj/npl-base/npl-base-c-interface.h       $target_dir/include/
    cp -rd ../npl-sdk-prj/npl-base/npl-cais.h                   $target_dir/include/
    cp -rd ../npl-sdk-prj/npl-base/npl-callback.h               $target_dir/include/
    cp -rd ../npl-sdk-prj/npl-base/npl-exception.h              $target_dir/include/

    cp -rd ../npl-sdk-prj/npl-common/npl-defines.h              $target_dir/include/
    cp -rd ../npl-sdk-prj/npl-common/npl-errors.h               $target_dir/include/
    cp -rd ../npl-sdk-prj/npl-common/npl-macros.h               $target_dir/include/

    # 记得补上C#的头文件
    # create zip file
    if [ ! -z "$target_zip" ]; then
        $cur_dir/tools/7z.exe a $target_zip -tzip $target_dir
    fi
}

# package_sdk $target_dir $target_zip
function package_sdk()
{
    local version=$1
    local target_dir=$2
    local target_zip=$3

    echo "###################################################################################################################"
    echo "copy npl-sdk to $target_dir"

    cd $cur_dir 

    # package base first
    package_base $version $target_dir

    function copy_files() 
    {
        local platform=$1

        mkdir -p $target_dir/bin/$platform/
        mkdir -p $target_dir/lib/$platform/

        cp -d $cur_dir/../npl-sdk-prj/bin/$platform/Release/npl-sdk.dll     $target_dir/bin/$platform/
        cp -d $cur_dir/../npl-sdk-prj/lib/$platform/Release/npl-sdk.lib     $target_dir/lib/$platform/
        cp -d $cur_dir/../npl-sdk-prj/lib/$platform/Release/npl-demo.exe    $target_dir/bin/$platform/
    }

    copy_files x86 
    copy_files x64 

    mkdir -p $target_dir/include/
    mkdir -p $target_dir/csharp/

    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl.h                         $target_dir/include/
    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl-c-interface.h             $target_dir/include/
    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl-friend.h                  $target_dir/include/
    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl-gameServer.h              $target_dir/include/
    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl-htmlsurface.h             $target_dir/include/
    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl-leaderboard.h             $target_dir/include/
    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl-matchmaking.h             $target_dir/include/
    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl-network.h                 $target_dir/include/
    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl-sensitiveword.h           $target_dir/include/
    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl-serverMatchmaking.h       $target_dir/include/
    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl-storage.h                 $target_dir/include/
    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl-user.h                    $target_dir/include/
    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl-utils.h                   $target_dir/include/
    cp -d $cur_dir/../npl-sdk-prj/npl-sdk/npl-voice.h                   $target_dir/include/

    # CSharp wapper
    cp -rd $cur_dir/../npl-sdk-prj/npl-sdk-csharp/Assets/Npl/Src/*.cs    $target_dir/csharp/

    echo "###################################################################################################################"
    echo "copy tutorials"

    cd $cur_dir
    tutorials_dir=$target_dir/tutorials
    
    mkdir -p $tutorials_dir
    cp -rd $cur_dir/../npl-sdk-prj/npl-client/*.h    $tutorials_dir
    cp -rd $cur_dir/../npl-sdk-prj/npl-client/*.cpp  $tutorials_dir
    cp -rd $cur_dir/../npl-sdk-prj/npl-client/CMakeLists.txt $tutorials_dir/CMakeLists.txt

    echo "###################################################################################################################"
    echo "copy tutorials-demo"

    tutorials_dir=$target_dir/tutorials_demo

    mkdir -p $tutorials_dir
    cp -rd $cur_dir/../npl-sdk-prj/npl-demo/* $tutorials_dir
    cp -df $cur_dir/tutorials_demo/* $tutorials_dir

    $cur_dir/tools/7z.exe a $target_zip -tzip $target_dir
}

#package_demo $target_dir $target_zip
function package_demo()
{
    echo "###################################################################################################################"
    echo "copy csharp-demo"

    local target_dir=$1
    local target_zip=$2
    cd $cur_dir

    mkdir -p $target_dir
    mkdir -p $target_dir/bin

    mkdir -p $target_dir/src/Assets/Npl/
    mkdir -p $target_dir/src/Assets/Plugins/

    pwd

    cp -rd $cur_dir/../npl-sdk-prj/npl-sdk-csharp/CSharp/*           $target_dir/bin/
    cp -rd $cur_dir/../npl-sdk-prj/npl-sdk-csharp/Assets/Npl/*       $target_dir/src/Assets/Npl/
    cp -rd $cur_dir/../npl-sdk-prj/npl-sdk-csharp/Assets/Plugins/*   $target_dir/src/Assets/Plugins/

    $cur_dir/tools/7z.exe a $target_zip -tzip $target_dir
}

# package $branch $project $version
function package()
{
    local project=$1
    local branch=$2
    local version=$3

    echo "create package"
    # step copy zip
    cd $cur_dir
    mkdir -p $cur_dir/package/$project/$version

    date=`date '+%Y%m%d%H%M%S'`

    case $project in
        sdk)
            package_base    $version $cur_dir/package/$project/$version/npl-base $cur_dir/package/$project/npl-$date-v$version-base.zip
            package_sdk     $version $cur_dir/package/$project/$version/npl-sdk  $cur_dir/package/$project/npl-$date-v$version-sdk.zip
            rm -rf $cur_dir/package/$project/$version
        ;;

        demo)
            package_demo    $version $cur_dir/package/$project/$version/npl-demo $cur_dir/package/$project/npl-$date-v$version-demo.zip
        ;;

        stub)
            package_stub    $version $cur_dir/package/$project/$version/npl-stub $cur_dir/package/$project/npl-$date-v$version-stub.zip
            package_launcher $version x86 $cur_dir/package/$project/$version/npl-platform-x86 $cur_dir/package/$project/npl-$date-v$version-platform-x86.zip
            package_launcher $version x64 $cur_dir/package/$project/$version/npl-platform-x64 $cur_dir/package/$project/npl-$date-v$version-platform-x64.zip
        ;;

        *)
            log_error "$project is not a valid package name."
        ;;
    esac

    # $cur_dir/tools/7z.exe a $cur_dir/package/$version/npl-$date-v$version-pdb.zip -tzip $cur_dir/symbols/$product_version
}

if [ -z $publish ]; then
    cur_dir=$(cd "$(dirname "$0")";pwd)
    package $@
fi