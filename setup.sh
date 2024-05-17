sudo apt update -y && sudo apt full-upgrade -y

sudo apt -y install cmake libopencv-dev libusb-1.0-0-dev ffmpeg v4l-utils
sudo apt -y install build-essential
sudo apt -y install qtwayland5
# sudo raspi-config #ssh, vnc, autologin, i2c

sudo mkdir /var/thermal
sudo chmod -R 777 /var/thermal
# upload file to /var/thermal

cd /var/thermal
# install python env
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate

#Setup v4l2loopback
cd /var/thermal
git clone https://github.com/umlaeute/v4l2loopback
cd v4l2loopback
make && sudo make install
sudo depmod -a
sudo modprobe v4l2loopback video_nr=2
sudo ./utils/v4l2loopback-ctl set-fps /dev/video2 10
#Setup Seek Thermal
cd /var/thermal
git clone https://github.com/OpenThermal/libseek-thermal
cd libseek-thermal
git apply ../dead_pixel.patch
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig

sudo udevadm control --reload

#set up service
cd /var/thermal/service
chmod 777 /var/thermal/start_seek.sh 

#systemctl --user daemon-reload

sudo cp seek_camera.service /etc/systemd/system
sudo systemctl enable seek_camera.service
sudo systemctl start seek_camera.service

sudo cp thermal_record.service /usr/lib/systemd/user
systemctl --user enable thermal_record.service
systemctl --user restart thermal_record.service

sudo cp display_thermal.service /usr/lib/systemd/user
systemctl --user enable display_thermal.service
systemctl --user restart display_thermal.service
