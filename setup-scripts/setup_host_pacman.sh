#!/usr/bin/env bash

# setup a linux host machine using pacman package manager to provide internet for USB device connected
# this should be run ONCE on the host machine
# this script also has not been tested fully, so expect some issues (mainly the inactive interface detection probably)

set -e  # bail on any errors

# install needed packages
#   NOTE: the flag "--break-system-packages" only exists on recent debian/ubuntu versions,
#   so we have to try with, and if there is an error try again without the flag

export DEBIAN_FRONTEND=noninteractive
pacman -S net-tools git htop cmake python3 python-devtools python-pip iptables android-tools
python3 -m pip install --break-system-packages virtualenv nuitka ordered-set || {
    python3 -m pip install virtualenv nuitka ordered-set
}
python3 -m pip install --break-system-packages git+https://github.com/superna9999/pyamlboot || {
    python3 -m pip install git+https://github.com/superna9999/pyamlboot
}


HOST_NAME="superbird"
USBNET_PREFIX="192.168.7"  # usb network will use .1 as host device, and .2 for superbird
INACTIVE_INTERFACE=$(ifconfig | grep -E '^[a-zA-Z0-9]+: ' | awk '{print $1}' | sed 's/://g' | while read iface; do
    if ! ifconfig $iface | grep -q 'inet '; then
        echo $iface
    fi
done)

# need to be root
if [ "$(id -u)" != "0" ]; then
    echo "Must be run as root"
    exit 1
fi

if [ "$(uname -s)" != "Linux" ]; then
    echo "Only works on Linux!"
    exit 1
fi

if [ -z "$INACTIVE_INTERFACE" ]; then
    echo "No inactive network interface found. This may occur if the script was already ran, or if your Spotify Car Thing is not plugged in."
    exit 1
fi

function remove_if_exists() {
    # remove a file if it exists
    FILEPATH="$1"
    if [ -f "$FILEPATH" ]; then
        echo "found ${FILEPATH}, removing"
        rm "$FILEPATH"
    fi
}

function append_if_missing() {
    # append string to file only if it does not already exist in the file
    STRING="$1"
    FILEPATH="$2"
    grep -q "$STRING" "$FILEPATH" || {
        echo "appending \"$STRING\" to $FILEPATH"
        echo "$STRING" >> "$FILEPATH"
        return 1
    }
    echo "Already found \"$STRING\" in $FILEPATH"
    return 0
}

function forward_port() {
    # usage: forward_port <host port> <superbird port>
    # forward a tcp port to access service on superbird via host
    #   if no superbird port is provided, same port number is used for both
    SOURCE="$1"
    DEST="$2"
    if [ -z "$DEST" ]; then
        DEST="$SOURCE"
    fi
    iptables -t nat -A PREROUTING -p tcp -i eth0 --dport "$SOURCE" -j DNAT --to-destination "${USBNET_PREFIX}.2:$DEST"
    iptables -t nat -A PREROUTING -p tcp -i wlan0 --dport "$SOURCE" -j DNAT --to-destination "${USBNET_PREFIX}.2:$DEST"
    iptables -A FORWARD -p tcp -d "${USBNET_PREFIX}.2" --dport "$DEST" -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
}


# detect if car thing is plugged in
if lsusb | grep -q "Google Inc."
then
    echo "Car Thing detected, proceeding with setup"
else
    echo "Car Thing not detected. Please plug in the Car Thing and try again"
    exit 1
fi

# fix usb enumeration when connecting superbird in maskroom mode
echo '# Amlogic S905 series can be booted up in Maskrom Mode, and it needs a rule to show up correctly' > /etc/udev/rules.d/70-carthing-maskrom-mode.rules
echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="1b8e", ATTR{idProduct}=="c003", MODE:="0666", SYMLINK+="worldcup"' >> /etc/udev/rules.d/70-carthing-maskrom-mode.rules

# prevent systemd / udev from renaming usb network devices by mac address
remove_if_exists /lib/systemd/network/73-usb-net-by-mac.link
remove_if_exists /lib/udev/rules.d/73-usb-net-by-mac.rules

#  allow IP forwarding
append_if_missing "net.ipv4.ip_forward = 1" /etc/sysctl.conf || {
    sysctl -p  # reload from conf
}

# forwarding rules
mkdir -p /etc/iptables

# clear all iptables rules
iptables -F
iptables -X
iptables -Z 
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X

# rewrite iptables rules
iptables -P FORWARD ACCEPT
iptables -A FORWARD -o eth0 -i eth1 -s "${USBNET_PREFIX}.0/24" -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -o eth0 -i eth1 -s "${USBNET_PREFIX}.0/24" -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A POSTROUTING -t nat -j MASQUERADE -s "${USBNET_PREFIX}.0/24"

# port forwards:
#   2022: ssh on superbird
#   5900: vnc on superbird
#   9222: chromium remote debugging on superbird

forward_port 2022 22
forward_port 5900
forward_port 9222

# persist rules to file
iptables-save > /etc/iptables/rules.v4

# inform user of manual steps that they must complete
echo "Setup complete, but there are a few manual steps that you must complete:"
echo "1. Open your settings, and navigate to the network settings."
echo "2. Delete any profiles that may be under USB Ethernet."
echo "3. Click the cog icon that is under USB Ethernet, and set the following settings:"
echo "   - IPv4 Method: Manual"
echo "   - Addresses: ${USBNET_PREFIX}.1"
echo "   - Netmask: 255.255.255.0"
echo "4. Click on Apply to save the settings. More detailed instructions with screenshots can be found in the README."

# add superbird to /etc/hosts
append_if_missing "${USBNET_PREFIX}.2  ${HOST_NAME}"  "/etc/hosts"

echo "Need to reboot for all changes to take effect!"