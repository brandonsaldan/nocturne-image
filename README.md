
<h1 align="center">
  <br>
  <a href="http://www.amitmerchant.com/electron-markdownify"><img src="https://raw.githubusercontent.com/brandonsaldan/nocturne-image/refs/heads/main/pictures/nocturne-logo.png" alt="Markdownify" width="200"></a>
  <br>
  nocturne-image
  <br>
</h1>

<h4 align="center">A pre-built Debian 12 image for the <a href="https://carthing.spotify.com/" target="_blank">Spotify Car Thing</a>.</h4>

<p align="center">
  <a href="#how-to-use">How To Use</a> •
  <a href="#download">Download</a> •
  <a href="#troubleshooting">Troubleshooting</a> •
  <a href="#donate">Donate</a> •
  <a href="#credits">Credits</a> •
  <a href="#related">Related</a> •
  <a href="#license">License</a>
</p>

<br>
<img src="https://raw.githubusercontent.com/brandonsaldan/nocturne-image/refs/heads/main/pictures/nocturne-1.png" alt="screenshot">

## How To Use

Unless receiving power through a Linux computer, running Nocturne on your Car Thing requires a host device such as a Raspberry Pi, a microSD card, a microUSB to USB-C cable, a microUSB/your power source's connector, as well as a Spotify Premium account. You will also need [superbird-tool](https://github.com/thinglabsoss/superbird-tool) to flash the image regardless of your computer's operating system.

### Windows

#### Raspberry Pi Setup

Download and open [Raspberry Pi Imager](https://downloads.raspberrypi.org/imager/imager_latest.exe), select Raspberry Pi OS (Legacy, 64-bit) Lite, select "Edit Settings", check "Set hostname", check "Set username and password" (set a password), check "Configure wireless LAN", (enter your network's SSID and password), check "Set local settings". Open the Services tab, enable SSH, and use password authentication. Write the configured OS to your microSD card and insert it into your Raspberry Pi.

#### Flashing Process

If you haven't already, download [superbird-tool](https://github.com/thinglabsoss/superbird-tool) and run the setup process detailed [here](https://github.com/thinglabsoss/superbird-tool?tab=readme-ov-file#supported-platforms).

Download and unzip the latest image from [Releases](https://github.com/brandonsaldan/nocturne-image/releases), connect Car Thing to your computer in USB Mode (hold preset buttons 1 and 4 while connecting), and run the following from your command line:

```bash
# Go into the superbird-tool repository
$ cd C:\path\to\superbird-tool-main

# Find device
$ python superbird_tool.py --find_device

# Flash Nocturne image, without resetting the data partition 
$ python superbird_tool.py --dont_reset --restore_device C:\path\to\nocturne-image\image 
```
After the flashing completes, connect your Raspberry Pi to your computer, and change directories to the scripts folder.

```bash
# Go into the setup-scripts folder
$ cd \path\to\nocturne-image\setup-scripts
```

There are two different ways to use Nocturne. You can either use it at your desk, or in your car. 

<details>
<summary>Using Nocturne at your desk</summary>
<br>
Connect your Car Thing to the Raspberry Pi and run the following from your command line:

```bash
# Transfer setup_host_rpi.sh to Raspberry Pi
$ scp \path\to\nocturne-image\setup-scripts\setup_host_rpi.sh pi@raspberrypi.local:/home/pi/

# SSH into Raspberry Pi
$ ssh pi@raspberrypi.local

# Make setup_host_rpi.sh executable
$ chmod +x /home/pi/setup_host_rpi.sh

# Execute setup_host_rpi.sh
$ sudo ./setup_host_rpi.sh

# Reboot Raspberry Pi
$ sudo reboot
```
</details>

<details>
<summary>Using Nocturne in your car</summary>
<br>
Connect your Car Thing to the Raspberry Pi and run the following from your command line:

```bash
# Transfer setup_host_rpi.sh to Raspberry Pi
$ scp \path\to\nocturne-image\setup-scripts\setup_host_rpi.sh pi@raspberrypi.local:/home/pi/

# SSH into Raspberry Pi
$ ssh pi@raspberrypi.local

# Make setup_host_rpi.sh executable
$ chmod +x /home/pi/setup_host_rpi.sh

# Execute setup_host_rpi.sh
$ sudo ./setup_host_rpi.sh

# Reboot Raspberry Pi
$ sudo reboot
```

After, you will need to run the `setup_hotspot.py` script: 
```bash
# Transfer setup_hotspot.py to Raspberry Pi
$ scp \path\to\nocturne-image\setup-scripts\setup_hotspot.py pi@raspberrypi.local:/home/pi/

# SSH into Raspberry Pi
$ ssh pi@raspberrypi.local

# Execute setup_hotspot.py
$ sudo python3 ./setup_hotspot.py
```

The script will ask you to input the name of your hotspot, as well as the password for the hotspot.

After the script completes, Nocturne is almost ready to be used in your car!

</details>
<br  >

Continue setting up Nocturne by following the steps outlined [here](https://github.com/usenocturne/nocturne-ui?tab=readme-ov-file#spotify-developer-setup). Then, select `Login with Phone`, scan the QR Code, and enter the Client ID and the Client Secret, and login to Spotify. After logging in, you are ready to use Nocturne!

### macOS

#### Raspberry Pi Setup

Download and open [Raspberry Pi Imager](https://downloads.raspberrypi.org/imager/imager_latest.dmg), select Raspberry Pi OS (Legacy, 64-bit) Lite, select "Edit Settings", check "Set hostname", check "Set username and password" (set a password), check "Configure wireless LAN", (enter your network's SSID and password), check "Set local settings". Open the Services tab, enable SSH, and use password authentication. Write the configured OS to your microSD card and insert it into your Raspberry Pi.

#### Flashing Process

If you haven't already, download [superbird-tool](https://github.com/thinglabsoss/superbird-tool) and run the setup process detailed [here](https://github.com/thinglabsoss/superbird-tool?tab=readme-ov-file#supported-platforms).

Download and unzip the latest image from [Releases](https://github.com/brandonsaldan/nocturne-image/releases), connect Car Thing to your computer in USB Mode (hold preset buttons 1 and 4 while connecting), and run the following from your command line:

```bash
# Go into the superbird-tool repository
$ cd /path/to/superbird-tool-main

# Find device
$ /opt/homebrew/bin/python3 superbird_tool.py --find_device

# Flash Nocturne image, without resetting the data partition 
$ /opt/homebrew/bin/python3 superbird_tool.py --dont_reset --restore_device /path/to/nocturne-image/image 
```
After the flashing completes, connect your Raspberry Pi to your computer, and change directories to the scripts folder.

```bash
# Go into the setup-scripts folder
$ cd /path/to/nocturne-image/setup-scripts
```

There are two different ways to use Nocturne. You can either use it at your desk, or in your car. 

<details>
<summary>Using Nocturne at your desk</summary>
<br>
Connect your Car Thing to the Raspberry Pi and run the following from your command line:

```bash
# Transfer setup_host_rpi.sh to Raspberry Pi
$ scp /path/to/nocturne-image/setup-scripts/setup_host_rpi.sh pi@raspberrypi.local:/home/pi/

# SSH into Raspberry Pi
$ ssh pi@raspberrypi.local

# Make setup_host_rpi.sh executable
$ chmod +x /home/pi/setup_host_rpi.sh

# Execute setup_host_rpi.sh
$ sudo ./setup_host_rpi.sh

# Reboot Raspberry Pi
$ sudo reboot
```
</details>

<details>
<summary>Using Nocturne in your car</summary>
<br>
Connect your Car Thing to the Raspberry Pi and run the following from your command line:

```bash
# Transfer setup_host_rpi.sh to Raspberry Pi
$ scp /path/to/nocturne-image/setup-scripts/setup_host_rpi.sh pi@raspberrypi.local:/home/pi/

# SSH into Raspberry Pi
$ ssh pi@raspberrypi.local

# Make setup_host_rpi.sh executable
$ chmod +x /home/pi/setup_host_rpi.sh

# Execute setup_host_rpi.sh
$ sudo ./setup_host_rpi.sh

# Reboot Raspberry Pi
$ sudo reboot
```

After, you will need to run the `setup_hotspot.py` script: 
```bash
# Transfer setup_hotspot.py to Raspberry Pi
$ scp /path/to/nocturne-image/setup-scripts/setup_hotspot.py pi@raspberrypi.local:/home/pi/

# SSH into Raspberry Pi
$ ssh pi@raspberrypi.local

# Execute setup_hotspot.py
$ sudo python3 ./setup_hotspot.py
```

The script will ask you to input the name of your hotspot, as well as the password for the hotspot.

After the script completes, Nocturne is almost ready to be used in your car!

</details>
<br  >

Continue setting up Nocturne by following the steps outlined [here](https://github.com/usenocturne/nocturne-ui?tab=readme-ov-file#spotify-developer-setup). Then, select `Login with Phone`, scan the QR Code, and enter the Client ID and the Client Secret, and login to Spotify. After logging in, you are ready to use Nocturne!

### Linux

#### Raspberry Pi Setup

A Raspberry Pi is not required on Linux, unless you want to use Nocturne in your car.

Download and open [Raspberry Pi Imager](https://downloads.raspberrypi.org/imager/imager_latest.dmg), select Raspberry Pi OS (Legacy, 64-bit) Lite, select "Edit Settings", check "Set hostname", check "Set username and password" (set a password), check "Configure wireless LAN", (enter your network's SSID and password), check "Set local settings". Open the Services tab, enable SSH, and use password authentication. Write the configured OS to your microSD card and insert it into your Raspberry Pi.

#### Flashing Process

If you haven't already, download [superbird-tool](https://github.com/thinglabsoss/superbird-tool) and run the setup process detailed [here](https://github.com/thinglabsoss/superbird-tool?tab=readme-ov-file#supported-platforms).

Download and unzip the latest image from [Releases](https://github.com/brandonsaldan/nocturne-image/releases), connect Car Thing to your computer in USB Mode (hold preset buttons 1 and 4 while connecting), and run the following from your command line:

```bash
# Go into the superbird-tool repository
$ cd /path/to/superbird-tool-main

# Find device
$ sudo python3 ./superbird_tool.py --find_device

# Flash Nocturne image, without resetting the data partition 
$ sudo python3 ./superbird_tool.py --dont_reset --restore_device /path/to/nocturne-image/image
```
After the flashing completes, unplug and replug your Car Thing, and change directories to the scripts folder.

```bash
# Go into the setup-scripts folder
$ cd /path/to/nocturne-image/setup-scripts
```

There are two different ways to use Nocturne. You can either use it at your desk, or in your car. 

<details>
<summary>Using Nocturne at your desk</summary>
<br>

At this point, there are two different scripts that you can use. The first one, `setup_host_apt.sh`, is used on Linux distros that utilize apt as it's package manager. The second one, `setup_host_pacman.sh`, is used on Linux distros that utilize Pacman as it's package manager. If you use Pacman, replace `setup_host_apt.sh` in the following commands with `setup_host_pacman.sh` to continue with setup.

It is important to note that `setup_host_pacman.sh` has not been tested very well, so it may not work as intended for setup. 

``` bash
# Make setup_host_apt.sh executable
$ chmod +x setup_host_apt.sh

# Execute setup_host_apt.sh
$ sudo ./setup_host_apt.sh
```
</details>

<details>
<summary>Using Nocturne in your car</summary>
<br>
To use Nocturne in your car, you will need to have a Raspberry Pi to provide network.  

Connect your Raspberry Pi to your computer, your Car Thing to the Raspberry Pi, and run the following from your command line:

```bash
# Transfer setup_host_rpi.sh to Raspberry Pi
$ scp /path/to/nocturne-image/setup-scripts/setup_host_rpi.sh pi@raspberrypi.local:/home/pi/

# SSH into Raspberry Pi
$ ssh pi@raspberrypi.local

# Make setup_host_rpi.sh executable
$ chmod +x /home/pi/setup_host_rpi.sh

# Execute setup_host_rpi.sh
$ sudo ./setup_host_rpi.sh

# Reboot Raspberry Pi
$ sudo reboot
```
</details>
<br>

Continue setting up Nocturne by following the steps outlined [here](https://github.com/usenocturne/nocturne-ui?tab=readme-ov-file#spotify-developer-setup). Then, select `Login with Phone`, scan the QR Code, and enter the Client ID and the Client Secret, and login to Spotify. After logging in, you are ready to use Nocturne!

## Troubleshooting

If you are having issues flashing Nocturne to your Car Thing, check out the guides below. 
<br>

<details>
<summary>superbird-tool: USBTimeoutError</summary>
<br>

If you are running into this error while flashing your Car Thing, try using the option `--slow_burn` or `--slower_burn` in the command used to flash. 

This will look like the following:
```bash
$ python ./superbird_tool.py --dont_reset --slow_burn --restore_device /path/to/nocturne/image
``` 

If this still does not resolve the error, then you will have to edit line 164 (the one that says `MULTIPLIER = 8`) in `superbird_device.py` 

<br>

If your flashing is failing at `executing bulkcmd: "amlmmc part 1"`, then try running the following command manually. This may take a few tries to succeed.

```bash
$ python ./superbird_tool.py --bulkcmd "amlmmc part 1"
``` 

 `python` in the above commands depends on what OS you are running. 

For Windows, it will be `python`. 

For macOS, it will be `/opt/homebrew/bin/python3`. 

For Linux, it will be `python3`

</details>

<br>

<details>
<summary>superbird-tool: "bulkcmd timed out or failed!" after system_b </summary>
<br>

If you are running into this error while flashing your Car Thing, you must replace the `superbird_partitions.py` file in the `superbird-tool` folder with the one provided in this repo. 

This error occurs since some devices have a smaller data partition, causing the error when attempting to flash the data partition.
</details>

<br>

<details>
<summary>superbird-tool: AssertionError </summary>
<br>

If you are running into this error while flashing your Car Thing, you must install the `libusbk` driver in Zadig. You can do this with the steps found [here](https://github.com/thinglabsoss/superbird-tool?tab=readme-ov-file#windows), and replacing `libusb-win32` with `libusbk` instead.
</details>

<br>

If your issue is not listed here, or if you need help, join our Discord [here!](https://discord.gg/GTP9AawHPt)

## Download

You can download the latest flashable version of Nocturne for Windows, macOS and Linux [here](https://github.com/brandonsaldan/nocturne-image/releases/latest).

## Donate

Nocturne is a massive endeavor, and the team have spent everyday over the last few months making it a reality out of our passion for creating something that people like you love to use.

All donations are split between the four members of the Nocturne team, and go towards the development of future features. We are so grateful for your support!

[Buy Me a Coffee](https://buymeacoffee.com/brandonsaldan) |
[Ko-Fi](https://ko-fi.com/brandonsaldan)

## Credits

This software was made possible only through the following individuals and open source programs:

- [Benjamin McGill](https://www.linkedin.com/in/benjamin-mcgill/), for giving me a Car Thing to develop with
- [shadow](https://github.com/68p), for testing, troubleshooting, and crazy good repo maintainence
- [Dominic Frye](https://x.com/itsnebulalol), for debugging, testing, and marketing
- [bbaovanc](https://x.com/bbaovanc), for OS development, debugging, and testing
- [bishopdynamics](https://github.com/bishopdynamics), for creating the original [superbird-tool](https://github.com/bishopdynamics/superbird-tool), [superbird-debian-kiosk](https://github.com/bishopdynamics/superbird-debian-kiosk), and modifying [aml-imgpack](https://github.com/bishopdynamics/aml-imgpack)
- [Thing Labs' fork of superbird-tool](https://github.com/thinglabsoss/superbird-tool), for their contributions on the original superbird-tool


## Related

[nocturne](https://github.com/brandonsaldan/nocturne) - The web application that this Debian image runs

## License

This project is licensed under the **MIT** license.

---

> [brandons.place](https://brandons.place/) &nbsp;&middot;&nbsp;
> GitHub [@brandonsaldan](https://github.com/brandonsaldan) &nbsp;&middot;&nbsp;
> Twitter [@brandonsaldan](https://twitter.com/brandonsaldan)

