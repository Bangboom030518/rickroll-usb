rm -rf .tmp
mkdir -p .tmp/frames
while IFS= read -r -d "$" frame; do
	echo "$frame" > ".tmp/frames/$i"
done < <(echo "$(cat astley.bz2 | bunzip2 -q 2> /dev/null)" | sed "s|\x1b\[H|$|g")
