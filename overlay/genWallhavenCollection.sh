#!/usr/bin/env bash

fill_json () {
    urls="$(
    data="$(curl -s "$@")"

    echo "$data" | jq -r '.data | map(.path) | .[]'

    last_page="$(echo "$data" | jq -r '.meta.last_page')"
    if [[ $last_page -gt 1 ]]; then
        for (( i = 2; i <= last_page; i++ )); do
            curl -s "$*?page=$i" | jq -r '.data | map(.path) | .[]'
        done
    fi)"

    for i in $urls; do
        hash="$(nix-prefetch-url "$i")"
        obj='{"url": "'"$i"'", "sha256": "'"$hash"'"}'
        jq --argjson obj "$obj" '. +[$obj]' wallhaven-collection.json > tmp &&
            mv tmp wallhaven-collection.json
    done
}

echo '[]' > wallhaven-collection.json

fill_json "https://wallhaven.cc/api/v1/collections/snrl/1046186"
fill_json "https://wallhaven.cc/api/v1/collections/snrl/1046197"

