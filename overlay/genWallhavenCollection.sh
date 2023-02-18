#!/usr/bin/env bash

get_urls () {
    data="$(curl -s "$*")"

    echo "$data" | jq -r '.data | map(.path) | .[]'

    last_page="$(echo "$data" | jq -r '.meta.last_page')"
    if [[ $last_page -gt 1 ]]; then
        for (( i = 2; i <= last_page; i++ )); do
            curl -s "$*?page=$i" | jq -r '.data | map(.path) | .[]'
        done
    fi
}

get_pairs () {
    for url in $(get_urls "$*"); do
        nix-prefetch-url "$url" | sed -E "s#.*#$url=&#" &
    done
    wait
}

fill_json () {
    for line in $(get_pairs "$*"); do
        jq --arg url "${line%=*}" \
            --arg hash "${line#*=}" \
            '. + [{ url: $url, sha256: $hash }]' \
            wallhaven-collection.json > tmp-col &&
            mv tmp-col wallhaven-collection.json
    done
}

echo '[]' > wallhaven-collection.json

fill_json "https://wallhaven.cc/api/v1/collections/snrl/1046186"
fill_json "https://wallhaven.cc/api/v1/collections/snrl/1046197"
