#!/bin/bash

#  Display computer uptime status (time since last reboot)
#
#  Title: Uptime status
#  Tooltip: Restart recommendation
#
#
#  Created by Jacob F. Grant
#
#  Written: 10/17/2017
#  Updated: 10/18/2017

### The following line load the Hello IT bash script lib
. "$HELLO_IT_SCRIPT_FOLDER/com.github.ygini.hello-it.scriptlib.sh"


rebootdate="$(date -r "$(sysctl -n kern.boottime | awk '{print $4}' | sed 's/,//')" "+%+")"
lastboot="$(date -r "$(sysctl -n kern.boottime | awk '{print $4}' | sed 's/,//')" "+%s")"
now="$(date +"%s")"
diff="$(( (now - lastboot) / 86400 ))"


alertcount=14
warningcount=7


function uptimeStatus {
    if [[ $diff -lt $warningcount ]] # Diff < Warning
    then
        updateTitle "Time since last reboot: $diff day(s)."
        updateState "${STATE[0]}"
        updateTooltip '"Hello, IT. Have you tried turning it off and on again?"'
    elif [[ $diff -gt $alertcount ]] # Diff > Alert
    then
        updateTitle "Time since last reboot: $diff day(s)."
        updateState "${STATE[2]}"
        updateTooltip "Consider restarting your computer sometime soon"
    else # Warning <= Diff < Alert
        updateTitle "Time since last reboot: $diff day(s)."
        updateState "${STATE[1]}"
        updateTooltip "Please restart your computer"
    fi

}


### This function is called when the user click on your item
function onClickAction {
    uptimeStatus "$@"
}

### This function is called when you've set Hello IT to run your script on a regular basis
function fromCronAction {
    uptimeStatus "$@"
}

### This function is called when Hello IT need to know the title to display
### Use it to provide dynamic title at load.
function setTitleAction {
    uptimeStatus "$@"
}

### The only things to do outside of a bash function is to call the main function defined by the Hello IT bash lib.
main $@

exit 0