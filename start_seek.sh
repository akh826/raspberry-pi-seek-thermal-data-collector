#!/bin/bash
sudo depmod -a
sudo modprobe v4l2loopback video_nr=2
sudo /var/thermal/v4l2loopback/utils/v4l2loopback-ctl set-fps /dev/video2 10
sudo seek_viewer --colormap=13 --rotate=90 --mode=v4l2 --output=/dev/video2

