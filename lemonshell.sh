#!/bin/bash
# LemonShell Blog

# MARK Configurations
function CONSTANTS() {
    SITE_URL="https://example.org"
    TITLE="Handsome Gorilla"
    DESCRIPTION="The tales of a gorilla who is too cool to stand still!"
    # Folders
    INPUT_FOLDER='src/'
    OUTPUT_FOLDER='public/'
    POSTS_FOLDER='posts/'
    # Templates
    BASE_TEMPLATE='_includes/templates/base.html'
    POST_TEMPLATE='_includes/templates/post.html'
    RSS=false
    PASSED='\033[1;32m[X]'
    WARNING='\033[1;31m[!]'
    CSS='holiday.css'
}

# TODO Complete the makePost
function makePost() {
    name=$2
    date=$(date '+%F %R')
    printf "---\ntitle: A good thing\ndate: %s \n---" "$date" >>a-good-thing.md
}

# MARK transformDrafts
function transformDrafts() {
    if [[ -f ../links.md ]]; then : >../links.md; fi # Check and cleans the file to add the post list.
    printf "## Blog\n\n" >>../links.md
    # Inverts the post list.
    function revert() { array=("${BASH_ARGV[@]}"); }
    for i in *.md; do array+=("$i"); done
    shopt -s extdebug
    revert "${array[@]}"
    shopt -u extdebug

    for itens in "${array[@]}"; do
        draftDate=$(grep -i 'date:' $itens)
        draftTitle=$(grep -i 'title:' $itens)
        printf " - %s   [ %s ]($POSTS_FOLDER${itens%.*}.html)\n" "${draftDate/date: /}" "${draftTitle/title: /}" >>../links.md
        pandoc -s --template=../$POST_TEMPLATE "$itens" -o "${itens%.*}.html"
        mv -f "${itens%.*}".html ../../${OUTPUT_FOLDER}${POSTS_FOLDER}
        echo -e "$PASSED File $itens transformed and moved to posts/."
    done
}

# MARK checkMarkdown
function checkMarkdown() {
    count=$(find . -maxdepth 1 -name '*.md' 2>/dev/null | wc -l)
    if [ $count != 0 ]; then
        echo -e "$PASSED Markdown files exists."
    else
        echo -e "$WARNING Eeek! No files found!"
        exit
    fi
}

# MARK transform File
function transformFile() {
    indexFile="index.md"
    if [[ -f "$indexFile" ]]; then
        echo -e "$PASSED Transforming the index..."
        pandoc -s --template=$BASE_TEMPLATE -i "nav.md" "$indexFile" "links.md" -o "${indexFile%.*}.html"
        # --lua-filter=../scripts/filter.lua  // sed -n "s|${POSTS_FOLDER}|$POSTS_FOLDER|g" "${indexFile%.*}.html" # Updating links so that it doesn't screw up
        mv ${indexFile%.*}.html ../$OUTPUT_FOLDER
    else
        echo -e "$WARNING Eek! No index.md found!"
    fi
}

# MARK checkFolder
function checkFolder() {
    if [[ ! -d $(pwd)/${INPUT_FOLDER}${POSTS_FOLDER} ]]; then
        echo -e "$PASSED Directory posts/ does not exist. Creating it..."
        mkdir $INPUT_FOLDER$POSTS_FOLDER
    fi
    if [[ ! -d $(pwd)/$OUTPUT_FOLDER ]]; then
        echo -e "$PASSED Directory public/ and public/posts does not exist. Creating it..."
        mkdir $OUTPUT_FOLDER && mkdir $OUTPUT_FOLDER$POSTS_FOLDER
    fi
}

# MARK makeRSS
function makeRSS() {
    echo -e "\033[1;35mMaking the RSS Feed..."
    : >rss.xml # Clears the file
    touch rss.xml
    echo "<?xml version= 1.0?>
    <rss version= 2.0>
    <channel>
        <title>$TITLE</title>
        <link>$SITE_URL</link>
        <description>$DESCRIPTION</description>
        <updated>$(date -R)</updated>" >>rss.xml
    cd posts/ || echo "Eek! No files found." exit
    for files in *.html; do
        postTitle=$(grep -i '<title>' ${files})
        postDescription=$(grep -i '<description>' ${files})
        echo "    <item>
      $postTitle
      <link>/posts/lorem-ipsum.md</link>
      $postDescription
    </item>" >>../rss.xml
    done
    echo "</channel></rss>" >>../rss.xml
    echo -e "RSS Feed Completed \033[0m"
}

function copyFolders() {
    echo -e "Moving folders..."
    cp -R css $OUTPUT_FOLDER
    cp -R js $OUTPUT_FOLDER
    cp -R img $OUTPUT_FOLDER
}

function buildSite() {
    rm -rf $OUTPUT_FOLDER
    checkFolder
    cd ${INPUT_FOLDER}${POSTS_FOLDER} || exit
    checkMarkdown
    transformDrafts
    cd ../ && transformFile
    cd ../ && copyFolders
    if $RSS; then makeRSS; fi
    echo -e "$PASSED Done." && exit
}

function main() {
    CONSTANTS
    buildSite
    echo -e "$PASSED Nothing to be done."
}

# MARK main
main
