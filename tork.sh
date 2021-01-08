#!/bin/bash
echo 'Welcome to TorK!'
echo ''
PS3='Please enter your choice: '
options=("Make this system an Onion Router or Restart Service" "Disable Service" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Make this system an Onion Router or Restart Service")
            echo "Starting operation..."
            eval "sudo systemctl enable ssh"
            eval "sudo systemctl start ssh"
            eval "sudo apt-get install sshuttle"
            eval "git clone https://github.com/ericpaulbishop/iptables_torify.git"
            eval "cd iptables_torify && sudo sh debian_install.sh"
            echo "Done!"
            exit
            ;;
        "Disable Service")
            echo "Starting operation..."
            eval "sudo systemctl enable ssh"
            eval "sudo systemctl start ssh"
            eval "sudo apt-get install sshuttle"
            eval "git clone https://github.com/ericpaulbishop/iptables_torify.git"
            eval "cd iptables_torify && sudo sh debian_install.sh"
            eval "sudo /etc/init.d/torify stop"
            echo "Done!"
            exit
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
