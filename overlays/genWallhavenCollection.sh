#!/usr/bin/env bash

f_name=wallhaven-collection.json

get_urls() {
    data="$(curl -s "$*")"

    echo "$data" | jq -r '.data | map(.path) | .[]'

    last_page="$(echo "$data" | jq -r '.meta.last_page')"
    if [[ $last_page -gt 1 ]]; then
        for ((i = 2; i <= last_page; i++)); do
            curl -s "$*?page=$i" | jq -r '.data | map(.path) | .[]'
        done
    fi
}

get_pairs() {
    for url in $(get_urls "$*"); do
        sleep 0.2 # don't spam much
        nix-prefetch-url "$url" | sed -E "s#.*#$url=&#" &
    done
    wait
}

fill_file() {
    for line in $(get_pairs "$*"); do
        jq --arg url "${line%=*}" \
            --arg hash "${line#*=}" \
            '. + [{ url: $url, sha256: $hash }]' \
            $f_name >tmp && mv tmp $f_name
    done
}

echo '[]' >$f_name

fill_file "https://wallhaven.cc/api/v1/collections/snrl/1046186"
fill_file "https://wallhaven.cc/api/v1/collections/snrl/1046197"

# sort result
jq -s '.[] | sort_by(.url)' $f_name >tmp && mv tmp $f_name
