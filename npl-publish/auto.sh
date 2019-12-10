#/bin/bash


work_path="D:/Cerberus/";


git_checkout()
{
	if [ $2x = x ]; then
		echo "Switch to Which Branch?";
		exit 1;
	fi
	cd $work_path/$1;
	git switch $2
	if [ "$?" = "0" ]; then
		echo -e "Git Switch $2 \033[32m SUCCESS \033[0m";
	else
		echo -e "Git Switch $2 \033[31m Failed \033[0m";
	fi
}


git_pull()
{
	cd $work_path/$1;
	git pullall
}


usage()
{
	echo "Usage ./auto.sh [-cpg] [branch name]";
}


echo "Current Work Path:$work_path"


if [ $# -lt 1 ]; then
	usage;
	exit -1;
fi


while getopts "c:p:g" arg
do
	case $arg in
		c)
			git_checkout npl-launcher $OPTARG
			git_checkout npl-sdk-prj $OPTARG
			;;
		p)
			git_pull npl-launcher
			git_pull npl-sdk-prj
			git_pull dependence
            git_pull ezlib
			;;
		g)
			cd $work_path
			if [ -f tags ]; then
				echo "delete old tag file";
				rm tags;
			fi
			echo "generate new tag file";
			;;
		?)
			usage;
			;;
	esac
done