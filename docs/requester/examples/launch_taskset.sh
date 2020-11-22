CROWDAQ_FILE=/Users/qiangn/Research/COVID19-Event/crowdaq/config-beta.json
#CROWDAQ_USER=qiang
PROFILE=allennlp-mturk
#PROFILE=qiangn-crowdaq
TASK_NAME=$1
MTURK_CONFIG=$2
HITS=$3

cd /Users/qiangn/Research/mturk-qualification-workflow/client

set -e

if [ -z "$CROWDAQ_FILE" ]
then
	echo "Using local development config"
	CROWDAQ_FILE="local.json"
else
	echo "Using config $CROWDAQ_FILE"
fi

#if [ -z "$CROWDAQ_USER" ]
#then
#	echo "Using local development config"
#	CROWDAQ_USER="_"
#else
#	echo "Using config $CROWDAQ_USER"
#fi


if [ -z "$TASK_NAME" ]
then
	echo "No task name given"
	exit 1
fi

#function list_task_repo_url_prefix {
#  cat $CROWDAQ_FILE | jq -r '.site_url + "/api/task_report/" + .user  '
#}


#function task_url {
#  echo $1
#	cat $CROWDAQ_FILE | jq -r '.site_url + "/w/task/" + .user  ' | xargs -I {} echo {}/$TASK_NAME/$1
#}

if [ -f /tmp/CROWDAQ_TASK_LIST_$TASK_NAME.txt ]; then
	echo "/tmp/CROWDAQ_TASK_LIST_$TASK_NAME.txt exists, click ENTER to delete it, or CTRL+C to cancel"
	read
	rm /tmp/CROWDAQ_TASK_LIST_$TASK_NAME.txt
fi

python cli.py -c $CROWDAQ_FILE login
echo Login

#python cli.py -c $CROWDAQ_FILE get `list_task_repo_url_prefix`/$TASK_NAME | jq -r '.assignment_count[] | select(.count<3) | .task_id' > /tmp/unfinished_tasks.txt
#python cli.py -c $CROWDAQ_FILE get `list_task_repo_url_prefix`/$TASK_NAME | jq -r '.assignment_count[] | .task_id' > /tmp/unfinished_tasks.txt
python cli.py -c $CROWDAQ_FILE gen-unfinished-urls $TASK_NAME $HITS > /tmp/CROWDAQ_TASK_LIST_$TASK_NAME.txt


#while read p; do
#    URL_BASE=`cat $CROWDAQ_FILE | jq -r '.site_url + "/w/task/" + .user  '`
#    echo $URL_BASE/$TASK_NAME/$p >> /tmp/CROWDAQ_TASK_LIST_$TASK_NAME.txt
#done < /tmp/unfinished_tasks.txt

#echo DONE

python mturk_cli.py -p $PROFILE launch-task $MTURK_CONFIG --url_file /tmp/CROWDAQ_TASK_LIST_$TASK_NAME.txt --logdir /Users/qiangn/Research/COVID19-Event/logs