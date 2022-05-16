#!/bin/bash
# Marula Blog

function transformDrafts() {
    for i in *.md; do
        pandoc --lua-filter=../scripts/filter.lua --template=../templates/post.html -f markdown -t html "$i" -o "${i%.*}.html"
        mv -f "${i%.*}.html" ../posts
        echo "File $i transformed and moved to posts/."
    done
}

if [[ ! -d $(pwd)/posts ]]; then
    echo "[!] Directory posts/ does not exist. Creating it..."
    mkdir posts
elif [[ ! -d $(pwd)/drafts ]]; then
    echo "[!] Directory drafts/ does not exist. Creating it..."
    mkdir drafts
else
    echo "[X] Directory drafts/ and posts/ exists. Continuing..."
fi

echo "[X] Moving to drafts..."
cd drafts/

count=`ls -1 *.flac 2>/dev/null | wc -l`

if [ $count != 0 ]; then
    echo "[X] Markdown files exists."
    transformDrafts 
    else
    echo "[!] Eeek! No files found!"
fi

# echo "Transforming the root files..."

# for i in *.md; do
#     if [ "$i" == "README.md" ]; then
#         echo "Skipping the ${i} ..."
#         continue
#     else
#         sed -n 's/(drafts/(posts/g' "$i"
#         pandoc --lua-filter=filter.lua --template=templates/template.html -f markdown -t html "$i" -o "${i%.*}.html"
#     fi
#     echo "Done."
# done

cd ../
echo "Done."