#!/bin/bash

cleanup()
# example cleanup function
{
	sudo docker stop -t 1 $CH $HUB > /dev/null
	sudo docker rm $CH $HUB > /dev/null
	return $?
}

control_c()
# run if user hits control-c
{
	echo -en "\n*** Ouch! Exiting ***\n"
	cleanup
	exit $?
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT

echo "Creating Selenium Hub Container"
HUB=$(sudo docker run -d --name selenium-hub -p 4444:4444 selenium/hub:2.44.0)

echo "Created Hub: $HUB"
echo "Creating Selenium Chrome Node"
CH=$(sudo docker run -d --name=ch \
    --link selenium-hub:hub \
    -v /e2e/uploads:/e2e/uploads \
    selenium/node-chrome:2.44.0)

echo "Created Node: $CH"

# Wait for Grid to be ready
sleep 2

node ./selenium.js $1 $2 $3 || true

cleanup

sudo docker run --rm -v $PWD:/shots --name giffing jujhars13/docker-imagemagick /shots/convert.sh

rm ./screenshots/out.mp4 -f
sudo docker run --rm -v $PWD:/shots -it jrottenberg/ffmpeg \
													-framerate 2 \
													-i /shots/screenshots/%03d.png.jpg \
													-c:v libx264 \
													-r 30 \
													-pix_fmt yuv420p \
													-s 944x844 \
													/shots/screenshots/out.mp4

rm ./screenshots/*.jpg -f
