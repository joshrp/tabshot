Tab Shot
--------

Tool for automatically tabbing through a site and taking screenshots along
the way, resulting in a video.

`node selenium.js http://bbc.co.uk/iplayer 100 50`

This will tab 100 times taking a screenshot at each step and leave
out.mp4 in ./screenshots.

The second and third arguments are optional and default to 50 screenshots
with 200ms between them.

Running
-------

You will need NPM to install the web driver and docker to run the containers.

Your first run will be **slow**. This is because when docker tries to run the
images it will first download them, after that they're cached.

How it works
------------

It runs selenium using selenium grid. It runs them on docker to save the hell
that is configuring selenium. These are graciously provided by selenium themselves at:

https://registry.hub.docker.com/repos/selenium/

Running both the Grid and a chrome node in the background while it executes.

The node script on your machine then connects to the Grid and runs the tests, executing screenshots.

This is then farmed off to an imagemagick docker container for resizing, again to avoid that hell.

Then it's off to an ffmpeg encoder to convert to an MP4, this is a special kind of hell in compiling ffmpeg.
