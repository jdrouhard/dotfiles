#!/bin/bash

echo '{ "version": 1, "stop_signal": 10, "cont_signal": 12, "click_events": true }'
echo "[[]"
conky -d

IFS="}"
while read; do
    IFS=" "
    STR=`echo $REPLY | sed -e s/[{}]//g -e "s/ \"/\"/g" | awk '{n=split($0,a,","); for (i=1; i<=n; i++) {m=split(a[i],b,":"); if (b[1] == "\"name\"") {NAME=b[2]} if (b[1] == "\"x\"") {X=b[2]} if (b[1] == "\"y\"") { Y=b[2]} } print NAME " " X " " Y}'`
    read NAME X Y <<< $STR
    X=$(($X-150))
    Y=$(($Y-230))
    case "${NAME}" in
        \"date\")
            yad --geometry=+$X+$Y --class "YADWIN" --calendar >/dev/null 2>/dev/null
            ;;
        \"weather\")
            google-chrome http://www.weather.com/weather/today/l/Olathe+KS+66061 2>&1 >/dev/null
            ;;
        \"lunch\")
            url=$(get_lunch.py --url)
            if [[ "$url" != "" ]]; then
                google-chrome $(get_lunch.py --url) 2>/dev/null >/dev/null
            fi
            ;;
    esac
    IFS="}"
done
