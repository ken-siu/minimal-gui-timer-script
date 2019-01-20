#!/bin/bash
input=`zenity \
        --forms \
        --title="Timer Setup" \
        --text="Count down time length" \
        --add-entry="hours" \
        --add-entry="minutes" \
        --add-entry="seconds"`

hours=`echo $input | cut -d"|" -f 1`
minutes=`echo $input | cut -d"|" -f 2`
seconds=`echo $input | cut -d"|" -f 3`

total=$((seconds + minutes * 60 + hours * 60 * 60))

curr_hours=0
curr_minutes=0
curr_seconds=0

function output {
    i=0
    while (( $i <= $total )); do
        echo "#Target:\n$hours h $minutes m $seconds s\nLapsed:\n$curr_hours h $curr_minutes m $curr_seconds s"
        echo "$(((i * 100) / $total))" # Updates the progress bar

        increment_time
        i=$((i + 1))
        sleep 1
    done
}

function increment_time {
    if (( "$curr_seconds" < 59 )); then
        curr_seconds=$((curr_seconds+1))
    else
        curr_seconds=0
        if (( "$curr_minutes" < 59 )); then
            curr_minutes=$((curr_minutes+1))
        else
            curr_minutes=0
            curr_hours=$((curr_hours+1))
        fi
    fi
}

output | \
    zenity \
        --auto-close \
        --title="Timer" \
        --progress && \
    zenity \
        --no-wrap \
        --info \
        --title="Timer" --text="The time is up"
