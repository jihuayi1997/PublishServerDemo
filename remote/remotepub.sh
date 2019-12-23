project=$1
branch=$2
version=$3
cur_time=$(date "+%Y%m%d%H%M")

case $project in
    ezlib)
        if [[ $branch == "qa" ]];then
            curl http://192.168.80.154:9090/dep
            curl -d "software=ezlib&branch=master&version=$version" http://192.168.80.154:9090/publish
            curl -o $cur_time.log http://192.168.80.154:8080/$cur_time.log
            cat $cur_time.log
        else
            echo "Don't input wrong branches..."
        fi
    ;;

    sdk)
        if [[ $branch == "qa" ]];then
            curl http://192.168.80.154:9090/sdkqa
            curl -d "software=sdk&branch=qa&version=$version" http://192.168.80.154:9090/publish
            curl -o $cur_time.log http://192.168.80.154:8080/$cur_time.log
            cat $cur_time.log
        elif [[ $branch == "master" ]];then
            curl http://192.168.80.154:9090/sdkmaster
            curl -d "software=sdk&branch=master&version=$version" http://192.168.80.154:9090/publish
            curl -o $cur_time.log http://192.168.80.154:8080/$cur_time.log
            cat $cur_time.log
        else
            echo "Don't input wrong branches..."
        fi
    ;;

    stub)
        if [[ $branch == "qa" ]];then
            curl http://192.168.80.154:9090/launcherqa
            curl -d "software=stub&branch=qa&version=$version" http://192.168.80.154:9090/publish
            curl -o $cur_time.log http://192.168.80.154:8080/$cur_time.log
            cat $cur_time.log
        elif [[ $branch == "vg" ]];then
            curl http://192.168.80.154:9090/launchervg
            curl -d "software=stub&branch=vg&version=$version" http://192.168.80.154:9090/publish
            curl -o $cur_time.log http://192.168.80.154:8080/$cur_time.log
            cat $cur_time.log
        elif [[ $branch == "master" ]];then
            curl http://192.168.80.154:9090/launchermaster
            curl -d "software=stub&branch=master&version=$version" http://192.168.80.154:9090/publish
            curl -o $cur_time.log http://192.168.80.154:8080/$cur_time.log
            cat $cur_time.log
        else
            echo "Don't input wrong branches..."
        fi
    ;;
esac