#!/usr/bin/env bash

token="token"
host="your.site"
screenshot="$(openssl rand -hex 6).png"

flameshot gui -r > "/tmp/$screenshot"

if [[ $(file --mime-type -b "/tmp/$screenshot") != "image/png" ]]; then
    rm "/tmp/$screenshot"
    notify-send "Screenshot aborted" -a "Flameshot" && exit 1
fi

res=$(curl --silent --show-error \
    --form "image=@/tmp/$screenshot" \
https://$host/u?token=$token 2>&1)

if [[ ${res} =~ 'Success' ]]; then
    echo -n "https://$host/i/$screenshot" | xclip -selection clipboard
    rm "/tmp/$screenshot"
    notify-send "Success! Link is copied to your clipboard." -a "Flameshot" && exit 1
else
    rm "/tmp/$screenshot"
    notify-send "Oopsie! $res" -a "Flameshot" && exit 1
fi
