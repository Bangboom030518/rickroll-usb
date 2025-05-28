#!/bin/bash
# requirements for this script to run:
# - `alsa-utils`, for the aplay command
# - `./frames.tar.gz`, for video
# - './rick.s16', for audio

audpid=0
echo -en '\x1b[s'  # Save cursor.

cleanup() { (( audpid > 1 )) && kill $audpid 2>/dev/null; }
quit() { echo -e "\x1b[2J \x1b[0H \x1b[38;5;171m<3 \x1b[?25h \x1b[u \x1b[m"; }

trap "cleanup" INT
trap "quit" EXIT
echo -en "\x1b[?25l \x1b[2J \x1b[H"  # Hide cursor, clear screen.
rm -rf .tmp
mkdir .tmp
tar -xzf frames.tar.gz -C .tmp

cat rick.s16 | aplay -Dplug:default -q -f S16_LE -r 8000 & audpid=$!
i=$(ls .tmp/frames | wc -l)
for frame in $(seq 0 $i); do
	(printf "%s\x1b[H" "$(cat ".tmp/frames/$frame")") & sleep 0.04
done
