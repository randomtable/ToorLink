#!/bin/bash
echo ''
echo  '#######                      #                       '
echo  '   #     ####   ####  #####  #       # #    # #    # '
echo  '   #    #    # #    # #    # #       # ##   # #   #  '
echo  '   #    #    # #    # #    # #       # # #  # ####   '
echo  '   #    #    # #    # #####  #       # #  # # #  #   '
echo  '   #    #    # #    # #   #  #       # #   ## #   #  '
echo  '   #     ####   ####  #    # ####### # #    # #    # '
echo ''
echo 'Welcome to ToorLink!'
echo ''
echo 'With this project you can build your own system'
echo 'and distribute it to multiple machine'
echo ''
echo 'You can even build your own ISO.'
echo "Let's begin!"
echo ''
PS3='Please enter your choice: '
options=("Change IP address" "Modify interfaces" "Enable SSH on boot" "Create Packages List (Search in repository)" "View/Manage packages list" "Install packages list" "Create/Manage Machines List" "Distribute Packages" "Create a script" "Run multiple scripts" "Distribute scripts" "Create Commands List" "Run all commands" "Build your ISO" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Change IP address")
            echo "This is the procedure for changing machine IP address"
            echo "If you want to change addressing manually, then chose option 2"
            echo "Enter IP address:"
            read IP
            sudo bash -c "echo 'auto lo' > /etc/network/interfaces"
            sudo bash -c "echo 'iface lo inet loopback' >> /etc/network/interfaces"
            sudo bash -c "echo '' >> /etc/network/interfaces"
            sudo bash -c "echo 'allow-hotplug eth0' >> /etc/network/interfaces"
            sudo bash -c "echo '' >> /etc/network/interfaces"
            sudo bash -c "echo '# The primary network interface' >> /etc/network/interfaces"
            sudo bash -c "echo 'auto eth0' >> /etc/network/interfaces"
            sudo bash -c "echo 'iface eth0 inet static' >> /etc/network/interfaces"
            sudo bash -c "echo 'address $IP' >> /etc/network/interfaces"
            echo "Enter netmask:"
            read mask
            sudo bash -c "echo 'netmask $mask' >> /etc/network/interfaces"
            echo "Enter gateway:"
            read gw
            sudo bash -c "echo 'gateway $gw' >> /etc/network/interfaces"
            echo "Enter Primary DNS:"
            read pdns
            echo "Enter Secondary DNS:"
            read sdns
            sudo bash -c "echo 'dns-nameservers $pdns $sdns' >> /etc/network/interfaces"
            sudo bash -c "systemctl restart networking.service"
            echo "Done!"
            exit
            ;;
        "Modify interfaces")
            sudo nano /etc/network/interfaces
            exit
            ;;
        "Enable SSH on boot")
            echo "SSH will be enabled on boot"
            sudo systemctl enable ssh
            sudo systemctl start ssh
            echo "Done!"
            exit
            ;;
        "Create Packages List (Search in repository)")
            echo '' > packages.txt
            while true
            do
            echo 'Which packet you would like to install (Leave blank for start install)?'
            read package
            if [[ $package != "" ]]; then
            searched=$(apt-cache showpkg $package)
            if [[ $searched != "" ]]; then
            echo $package >> packages.txt
            echo 'Package found, it will be installed!'
            else
            echo 'Sorry, package not found.'
            fi
            else
            exit
            fi
            done
            ;;
        "View/Manage packages list")
            nano packages.txt
            exit
            ;;
        "Install packages list")
            input="packages.txt"
            while IFS= read -r line
            do
            sudo apt-get install "$line" -y
            done < "$input"
            exit
            ;;
        "Create/Manage Machines List")
            echo "Insert data in this form: machineIP;username;password (one machine at line)"
            read -p "Continue? (Y/N) " -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]; then
              nano machines.txt
            fi
            exit
            ;;
        "Distribute Packages")
            input="machines.txt"
            while IFS= read -r line
            do
            IFS=';'
            read -a strarr <<< "$line"
            echo "La macchina è ${strarr[0]}, con nome utente ${strarr[1]} e password ${strarr[2]}"
            input="packages.txt"
            while IFS= read -r line
            do
            sshpass -p "${strarr[2]}" ssh -t -oStrictHostKeyChecking=no ${strarr[1]}@${strarr[0]} sudo -S <<< "${strarr[2]}" apt-get install "$line" -y
            done < "$input"
            done < "$input"
            exit
            ;;
        "Create a script")
            mkdir -p "scripts"
            echo ""
            echo "PLEASE NOTE THAT THE SCRIPT WILL BE CREATED IN THE 'SCRIPTS' FOLDER, SO THIS WILL BE RUN WITH THE 'RUN MULTIPLE SCRIPTS' OPTION."
            echo ""
            echo "Please enter the name of your script:"
            echo ""
            read scriptname
            nano scripts/$scriptname
            echo $scriptname >> scripts.txt
            exit
            ;;
        "Run multiple scripts")
            echo "All the scripts in the 'scripts' folder will be run!"
            echo ""
            ls scripts | xargs -n 1 basename > scripts.txt
            input="scripts.txt"
            while IFS= read -r line
            do
            chmod +x scripts/$line
            sh scripts/$line
            done < "$input"
            echo ""
            echo "Done!"
            exit
            ;;
        "Distribute scripts")
            echo "All the scripts in the 'scripts' folder will run on the remote systems!"
            echo ""
            input="machines.txt"
            while IFS= read -r line
            do
            IFS=';'
            read -a strarr <<< "$line"
            echo "La macchina è ${strarr[0]}, con nome utente ${strarr[1]} e password ${strarr[2]}"
            input="scripts.txt"
            while IFS= read -r line
            do
            sshpass -p "${strarr[2]}" scp "scripts/$line" ${strarr[1]}@${strarr[0]}:~/
            sshpass -p "${strarr[2]}" ssh -t -oStrictHostKeyChecking=no ${strarr[1]}@${strarr[0]} sudo -S <<< "${strarr[2]}" sh "$line"
            done < "$input"
            done < "$input"
            exit
            ;;
        "Create Commands List")
            echo '' > commands.txt
            nano commands.txt
            exit
            ;;
        "Run all commands")
            echo "All commands in the 'commands' folder will run on the remote systems!"
            echo ""
            input="machines.txt"
            while IFS= read -r line
            do
            IFS=';'
            read -a strarr <<< "$line"
            echo "La macchina è ${strarr[0]}, con nome utente ${strarr[1]} e password ${strarr[2]}"
            input="commands.txt"
            while IFS= read -r line
            do
            sshpass -p "${strarr[2]}" ssh -t -oStrictHostKeyChecking=no ${strarr[1]}@${strarr[0]} sudo -S <<< "${strarr[2]}" "$line"
            done < "$input"
            done < "$input"
            exit
            ;;
        "Build your ISO")
            
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
