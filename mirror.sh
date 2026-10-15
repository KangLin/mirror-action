#!/usr/bin/env bash
set -e

GIT_PUSH_ARGS=${INPUT_GIT_PUSH_ARGS:-"--tags --force --prune"}
MIRROR_NUMBER=0

function mirror {
    if [ $# -lt 3 ]; then
        echo "Parameters: remote_name soruce_repository destination_repository1 destination_repository2 ..."
        return
    fi

    MIRROR_NUMBER=`expr ${MIRROR_NUMBER} + 1`
    
    index=0
    
    for des_rep in "$@"
    do
        index=`expr $index + 1`
        
        if [ 1 = $index ]; then
            echo "-------------------------------------------------------------------"
            echo "Mirror ${MIRROR_NUMBER}: $des_rep"
            echo "step1: mkdir -p $des_rep"
            mkdir -p $1
            cd $1
            continue
        fi
        if [ 2 = $index ]; then
            echo "step2: git fetch source from $des_re"
            echo "git fetch $des_rep"
            git init > /dev/null
            git remote add origin "$2"
            git fetch --all > /dev/null 2>&1
            continue
        fi

        echo "step${index}: mirror`expr $index - 2` to ${des_rep}"
        echo "git remote add $1_${index} "$des_rep""
        git remote add $1_`expr $index - 2` "$des_rep";
        echo "eval git push ${GIT_PUSH_ARGS} $1_`expr $index - 2` "\"refs/remotes/origin/*:refs/heads/*\"""
        eval git push ${GIT_PUSH_ARGS} $1_`expr $index - 2` "\"refs/remotes/origin/*:refs/heads/*\""

    done

}

# "remote_name soruce_repository destination_repository1 destination_repository2 ..."
rep=("RabbitRemoteControl https://github.com/KangLin/RabbitRemoteControl.git ssh://kl222@git.code.sf.net/p/rabbitremotecontrol/code git@bitbucket.org:kl222/rabbitremotecontrol.git ssh://git@codeberg.org/KangLin/RabbitRemoteControl.git")
rep+=("SerialPortAssistant https://github.com/KangLin/SerialPortAssistant.git ssh://kl222@git.code.sf.net/p/serialportassistant/code git@bitbucket.org:kl222/serialportassistant.git ssh://git@codeberg.org/KangLin/TransformCoordinate.git")
rep+=("RabbitIm https://github.com/KangLin/RabbitIm.git ssh://kl222@git.code.sf.net/p/rabbitim/code")
rep+=("LunarCalendar https://github.com/KangLin/LunarCalendar.git ssh://kl222@git.code.sf.net/p/lunarcalendar/code git@bitbucket.org:kl222/lunarcalendar.git ssh://git@codeberg.org/KangLin/LunarCalendar.git")
rep+=("Calendar https://github.com/KangLin/Calendar.git ssh://kl222@git.code.sf.net/p/rabbitcalendar/code ssh://git@codeberg.org/KangLin/Calendar")
rep+=("chinesechesscontrol https://github.com/KangLin/ChineseChessControl.git ssh://kl222@git.code.sf.net/p/chinesechesscontrol/code git@bitbucket.org:kl222/chinesechesscontrol.git ssh://git@codeberg.org/KangLin/ChineseChessControl.git")
rep+=("RabbitProxyServer https://github.com/KangLin/RabbitProxyServer.git ssh://kl222@git.code.sf.net/p/rabbitproxyserver/code")
rep+=("RabbitCommon https://github.com/KangLin/RabbitCommon.git ssh://kl222@git.code.sf.net/p/rabbitcommon/code git@bitbucket.org:kl222/rabbitcommon.git ssh://git@codeberg.org/KangLin/RabbitCommon.git")
rep+=("FaceRecongnizer https://github.com/KangLin/FaceRecongnizer.git ssh://kl222@git.code.sf.net/p/facerecognizer/code")

#rep+=("RabbitRemoteControl https://github.com/KangLin/RabbitRemoteControl.git git@invent.kde.org:kanglin/RabbitRemoteControl.git")
#rep+=("SerialPortAssistant https://github.com/KangLin/SerialPortAssistant.git git@invent.kde.org:kanglin/SerialPortAssistant.git")
#rep+=("LunarCalendar https://github.com/KangLin/LunarCalendar.git git@invent.kde.org:kanglin/LunarCalendar.git")
#rep+=("Calendar https://github.com/KangLin/Calendar.git git@invent.kde.org:kanglin/Calendar.git")
#rep+=("FaceRecongnizer https://github.com/KangLin/FaceRecongnizer.git git@invent.kde.org:kanglin/facerecognizer.git")
#rep+=("RabbitCommon https://github.com/KangLin/RabbitCommon.git git@invent.kde.org:kanglin/rabbitcommon.git")
#rep+=("chinesechesscontrol https://github.com/KangLin/ChineseChessControl.git git@invent.kde.org:kanglin/ChineseChessControl.git")

for i in "${rep[@]}";
do
    mirror $i;
done

echo "Total repository: ${MIRROR_NUMBER}"
