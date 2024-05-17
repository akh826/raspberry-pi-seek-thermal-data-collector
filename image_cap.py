import cv2
import os
import threading
import subprocess
import time

def cap_image_only():
	folder_count = 0
	while True:
		foldername = "image/image"+str(folder_count)
		if not os.path.exists(foldername):
			break
		folder_count += 1

	try:
		os.mkdir('image')
	except Exception:
		pass
	os.mkdir(foldername)
    
	count = 0
	while True:
		time.sleep(10)
		subprocess.run(["ffmpeg", "-f", "v4l2", "-i", "/dev/video2", "-frames", "1",foldername+"/"+str(count)+".jpeg" ])
		count += 1
        
if __name__ == '__main__':
    try:
        cap_image_only()
    except Exception:
        exit()
