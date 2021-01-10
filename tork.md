# Tork (draft page)

Based on:

- Torify: https://github.com/ericpaulbishop/iptables_torify
- Sshuttle: https://github.com/sshuttle/sshuttle

Tork is an appliance who provides an SSH VPN thanks to sshuttle software.

Tork redirects all connections through Tor Network.

You can download the appliance here:

http://apd.altervista.org/iso/Tork.iso

## Live ISO credentials:

Username: kali

Password: kali

## Installation:

You can install the appliance like a normal Kali Linux distribution.

## Usage:

First, connect to the appliance with Live ISO credentials or user you have created during installation, then type "/tork.sh".

![connect](https://github.com/randomtable/ToorLink/blob/main/img/img-1.png)

Here, press 1 to install and enable the Service or 2 to disable it:

![script](https://github.com/randomtable/ToorLink/blob/main/img/img-2.png)

On your client machine, just install sshuttle software with (debian example):

### sudo apt-get install sshuttle

Once you have installed the software, you can connect to server with this command (requires root privileges):

### sshuttle --dns -r username@tork_machine_ip 0/0 -x tork_machine_ip

example

### sshuttle --dns -r toor@8.8.8.8 0/0 -x 8.8.8.8

And that's it, you have a remote transparent router to Tor Network!

![tor](https://github.com/randomtable/ToorLink/blob/main/img/img-3.PNG)
