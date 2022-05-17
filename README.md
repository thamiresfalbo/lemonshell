# Marula

A static blog generator using the magic of pandoc and bash. It's still very alpha, use at your own risk.

# Installation

Create a folder and clone the repository. Run the script with `bash ./marula.sh`, or change the permissions to execute without bash : `chmod +x ./marula.sh`. After executing, the script will create an `index.md` in the root folder and an `example-post.md` in the `_drafts` folder.

## Dependencies
- [Pandoc](https://pandoc.org/installing.html)
- [Bash](https://www.gnu.org/software/bash/)
- [GNU sed](https://www.gnu.org/software/sed/) - Needed if you are using MacOS.

# TODO
- Offline usage.
- Check if pandoc and gsed exists in OS.
- Make color schemes to CSS.
- Auto Dark Mode.
- Command line for starter, posts and pages.