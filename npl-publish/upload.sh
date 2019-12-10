function upload()
{
    local files=($(ls -1 /W/Npl/Release/sdk/ | grep ^npl) $(ls -1 /W/Npl/Release/stub/ | grep ^npl))
    local -a build
    local -a group

    local index=0
   
    for file in ${files[@]}; do
        local full=$file
        echo $full

        local skip="${file%%-*}"; file="${file#*-}"
        local date="${file%%-*}"; file="${file#*-}"
        local version="${file%%-*}"; file="${file#*-}"
        local part="${file%%.*}"; file="${file#*.}"

        build[$index]="$date,$version,$part,$full"
        eval "V$date=(\${V$date[@]} $file)"
        let index++
    done

    
    local t_build=$(printf '%s\n' "${build[@]}" | sort -t ',' -k 1r -u)
    build=(${t_build[@]})

    local start=0
    local count=${#build[@]}

    while :; do
        clear
        echo '------------------------------'
        for (( show=start; show<count && show-start<10; show++ )) do
            local row=(${build[$show]//,/ })
            local date="${row[0]:0:4}/${row[0]:4:2}/${row[0]:6:2}"
            local time="${row[0]:8:2}:${row[0]:10:2}:${row[0]:12:2}"

            echo -e "$(($(($show+1))%10)). | ${row[1]} | $date $time | ${row[2]}"
        done
        echo '------------------------------'
        echo 'a. sort by date'
        echo 'b. sort by version'
        echo '------------------------------'
        echo '-. page up'
        echo '=. page down'
        echo '------------------------------'
        echo 'q. quit'

        read -rsn1 input
        echo get $input

        case $input in
            [0-9])
                local row=(${build[$[start+input-1]]//,/ })
                echo "upload to server"
                local loc=${row[3]}
                if [ -f "/W/Npl/Release/sdk/$loc" ]; then
                    loc="/W/Npl/Release/sdk/$loc"
                    echo 1 $loc
                else
                    loc="/W/Npl/Release/stub/$loc"
                    echo 2 $loc
                fi

                local key=npl-${row[1]:1}-${row[2]}.zip

                echo loc = $loc

                echo "upload $loc ==> $key"
                $cur_dir/tools/tool.sh -putfile $loc npl-download-inner -key $key -replace true

                echo "upload complated. press any key to continue..."
                read -rsn1 input
            ;;
            a)
                local t_build=$(printf '%s\n' "${build[@]}" | sort -t ',' -k 1r -n)
                start=0
                build=(${t_build[@]})
            ;;
            b)
                local t_build=$(printf '%s\n' "${build[@]}" | sort -t ',' -k 2.1r)
                start=0
                build=(${t_build[@]})
            ;;
            -)
                echo page up
                start=$[start-10]
                if [ $start -lt 0 ]; then
                    start=0
                fi
            ;;
            =)
                echo page down
                if [ $[count - start] -gt 10 ]; then
                    start=$[start+10]
                fi
            ;;
            q)
                return
            ;;
            *)
                read -t 2 -p 'please make your choice by menu.'
            ;;
        esac
    done
}

cur_dir=$(cd "$(dirname "$0")";pwd)
upload