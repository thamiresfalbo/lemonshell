#!/bin/bash
# Marula Blog

# MARK Configurations
function CONSTANTS() {
    SITE_URL=""
    TITLE=""
    DESCRIPTION=""
    POST_TEMPLATE='post.html'
    TEMPLATE='template.html'
    DRAFTS_FOLDER='_drafts/'
    PUBLIC_FOLDER='public/'
    POSTS_FOLDER="posts/"
    RSS=false
    PASSED='\033[1;32m[X]'
    WARNING='\033[1;31m[!]'
    CSS='style.css'
}

# TODO Complete the makePost
function makePost() {
    name=$2
    date=$(date '+%F %R')
    printf "---\ntitle: A good thing\ndate: %s \n---" "$date" >> a-good-thing.md
}

# MARK transformDrafts
function transformDrafts() {
    echo -e "$PASSED Moving to drafts..."
    if [[ -f ../links.md ]]; then :>../links.md; fi # Cleans the links file so it doesn't mess it up.
    printf "## Blog\n\n" >> ../links.md
    for i in *.md; do
        # Parsing the posts links to a separate file to be joined to index.
        # sed -i "s|^date:.*|date: $(date '+%F %R')|g" $i
        draftDate=$(grep -i 'date:' $i)
        draftTitle=$(grep -i 'title:' $i)
        printf " - [ %s - %s ](${i%.*}.html)\n" "${draftDate/date: }" "${draftTitle/title: }"  >> ../links.md
        pandoc --lua-filter=../scripts/filter.lua -s --template=../templates/$POST_TEMPLATE "$i" -o "${i%.*}.html"
        mv -f "${i%.*}".html ../${PUBLIC_FOLDER}
        echo -e "$PASSED File $i transformed and moved to posts/."
    done
}

# MARK checkMarkdown
function checkMarkdown() {
    count=$(find . -maxdepth 1 -name '*.md' 2>/dev/null | wc -l)
    if [ $count != 0 ]; then
    echo -e "$PASSED Markdown files exists."; else
        echo -e "$WARNING Eeek! No files found!"
        exit
    fi
}

# MARK transform File
function transformFile() {
    indexFile="index.md"
    if [[ -f "$indexFile" ]]; then
        echo -e "$PASSED Transforming the index..."
        pandoc --lua-filter=scripts/filter.lua -s --template=templates/$TEMPLATE -i "$indexFile" "links.md" -o "${indexFile%.*}.html"
        sed -n "s|${DRAFTS_FOLDER}|$POSTS_FOLDER|g" "${indexFile%.*}.html" # Updating links so that it doesn't screw up
        mv ${indexFile%.*}.html $PUBLIC_FOLDER
    else
        echo -e "$WARNING Eek! No index.md found!"
    fi
}

# MARK checkFolder
function checkFolder() {
    if [[ ! -d $(pwd)/$DRAFTS_FOLDER ]]; then
        echo -e "$PASSED Directory drafts/ does not exist. Creating it..."
        mkdir _drafts && echo "Please create a post and rerun the command." && exit
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

function buildSite() {
    checkFolder
    cd $DRAFTS_FOLDER || exit
    checkMarkdown
    transformDrafts
    cd ../
    transformFile
    if $RSS; then makeRSS; fi
    echo -e "$PASSED Done."
}

function main() {
    CONSTANTS
    buildSite
    echo -e "$PASSED Nothing to be done."
}

# MARK main
main