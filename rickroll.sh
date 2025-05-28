#!/bin/bash
# requirements for this script to run:
# - `alsa-utils`, for the aplay command
# - `./frames.tar.gz`, for video
# - './rick.s16', for audio

# audpid=0
printf '\x1b[s'  # Save cursor.

# cleanup() { (( audpid > 1 )) && kill $audpid 2>/dev/null; }
# quit() { echo -e "\x1b[2J \x1b[0H \x1b[38;5;171m<3 \x1b[?25h \x1b[u \x1b[m"; }
# trap "cleanup" INT
# trap "quit" EXIT

# Ignore all attempts to escape
trap '' SIGINT
trap '' SIGTERM
trap '' EXIT

printf "\x1b[?25l \x1b[2J \x1b[H"  # Hide cursor, clear screen.
rm -rf .tmp
mkdir .tmp
gunzip -c frames.tar.gz | tar -xf - -C .tmp
# cat rick.s16 | aplay -Dplug:default -q -f S16_LE -r 8000 & disown # audpid=$!
# Play audio (using nohup for detachment)
# Assumes aplay exists on the target system
# Redirect output to /dev/null to avoid nohup.out file
nohup cat rick.s16 | aplay -Dplug:default -q -f S16_LE -r 8000 > /dev/null 2>&1 & APLAY_PID=$! # PID of the nohup process, not directly aplay

frame=0
length=$(ls .tmp/frames | wc -l)
while [ $frame -le $length ]; do
	(printf "%s\x1b[H" "$(cat ".tmp/frames/$frame")") & sleep 0.04
	frame=$((frame + 1))
done
