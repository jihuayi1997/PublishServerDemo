cur_dir=$(dirname $(readlink -f $0))
cur_time=$(date "+%Y%m%d%H%M%S")
zip -j W:/Npl/QA/demo/npl-demo-$cur_time-X64 \
$cur_dir/../npl-sdk-prj/bin/X64/Release/npl-demo* \
$cur_dir/../npl-sdk-prj/bin/X64/Release/npl-game*