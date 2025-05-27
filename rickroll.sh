#!/bin/bash
# requirements for this script to run:
# - `alsa-utils`, for the aplay command
# - `./astley.bz2`, for video
# - './rick.s16', for audio

audpid=0
echo -en '\x1b[s'  # Save cursor.

cleanup() { (( audpid > 1 )) && kill $audpid 2>/dev/null; }
quit() { echo -e "\x1b[2J \x1b[0H \x1b[38;5;171m<3 \x1b[?25h \x1b[u \x1b[m"; }

trap "cleanup" INT
trap "quit" EXIT
echo -en "\x1b[?25l \x1b[2J \x1b[H"  # Hide cursor, clear screen.

cat rick.s16 | aplay -Dplug:default -q -f S16_LE -r 8000 & audpid=$!
# fps=25;
# buffer="";
# frame=0;
# next_frame=0;
# i=0;
# begin=$(date +%s%N)

# while IFS="\x1b[H" read -r line; do
# 	# if [ $((i%32)) -eq 0 ]; then
# 		((frame++))
# 		echo $buffer
# 		buffer=""
# 		now=$(date +%s%N)
# 		elapsed=$((now - begin))
# 		total_time=$(((frame * 10**9) / fps))
# 		sleep_time=$((total_time - elapsed))
# 		if [ $sleep_time -gt 0 ]; then
# 			sleep $(printf "%.9f" $(( $sleep_time ))e-9)
# 		fi
# 		# next_frame=$((($elapsed * $fps) / 10 ** 9))
# 	# fi
# 	# if [ $frame -ge $next_frame ]; then
# 		buffer+=$line
# 	# fi
# done < <(cat astley.bz2 | bunzip2 -q 2> /dev/null)

fps=25;
buffer="";
frame=0;
next_frame=0;
i=0;
begin=$(date +%s%N)
for frame in $(seq 0 6374); do
	(clear && printf "%s\x1b[H" "$(cat "frames/$frame.txt")") & sleep 0.04
	
	# now=$(date +%s%N)
	# elapsed=$((now - begin))
	# total_time=$(((frame * 10**9) / fps))
	# sleep_time=$((total_time - elapsed))
	# if [ $sleep_time -gt 0 ]; then
	# 	sleep $(printf "%.9f" $(( $sleep_time ))e-9)
	# fi
done

# Sync FPS to reality as best as possible. Mac's freebsd version of date cannot
# has nanoseconds so inject python. :/
# python <(cat <<EOF
# import sys, time;
# fps = 25;
# buf = ''; frame = 0; next_frame = 0
# begin = time.time()
# try:
#   for i, line in enumerate(sys.stdin):
#     if i % 32 == 0:
#       frame += 1
#       sys.stdout.write(buf); buf = ''
#       elapsed = time.time() - begin
#       repose = (frame / fps) - elapsed
#       if repose > 0.0:
#         time.sleep(repose)
#       next_frame = elapsed * fps
#     if frame >= next_frame:
#       buf += line
# except KeyboardInterrupt:
#   pass
# EO
# ) < <(cat astley.bz2 | bunzip2 -q 2> /dev/null)
