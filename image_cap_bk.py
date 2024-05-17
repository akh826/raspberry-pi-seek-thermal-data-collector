import cv2
import os
import threading

def capimage(path, img):
    cv2.imwrite(path, img) 

def main():
    folder_count = 0
    while True:
        foldername = "image"+str(folder_count)
        if not os.path.exists(foldername):
            break
        folder_count += 1

    os.mkdir(foldername)

    cam_port = 2
    cap = cv2.VideoCapture(cam_port) 


    count = 0
    loop_count = 30
    while True:
        while True:
            ret, image = cap.read()
            if(ret):
                t1 = threading.Thread(target=capimage, args=(foldername+"/"+str(count)+".png", image,))
                t1.start()
                print(count)
                count += 1
                break
            cv2.waitKey(1)

        for i in range(loop_count):
            while True:
                ret, image = cap.read()
                cv2.waitKey(1)
                if(ret):
                    cv2.imshow("Webcam Image", image)
                    break
        t1.join()
        if cv2.waitKey(1) == ord('q'):
            break


    cap.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()