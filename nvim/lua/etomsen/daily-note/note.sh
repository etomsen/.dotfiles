#!/bin/sh
while getopts u:a:f: flag
do
    case "${flag}" in
        d) directory=${OPTARG};;
    esac
done

noteFilename="$HOME/Documents/notes/diary/note-$(date +%Y-%m-%d).md"

if [ ! -f $noteFilename ]; then
  echo "# Notes for $(date +%Y-%m-%d)" > $noteFilename
fi

nvim -c "norm Go" \
  -c "norm Go## $(date +%H:%M)" \
  -c "norm G2o" \
  -c "norm zz" \
  -n \
  -c "startinsert" $noteFilename
