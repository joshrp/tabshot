#!/bin/bash
for a in /shots/screenshots/*.png; do
	convert -resize 90% -quality 80% $a $a.jpg;
	rm $a -f
done;
