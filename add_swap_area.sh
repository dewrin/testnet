#!/bin/bash

echo -e '\nIs adding swap area...\n'

# Checking if 'swapfile' entry already exists in /etc/fstab
grep -q "swapfile" /etc/fstab

# Checking the exit code of the grep command
if [[ ! $? -ne 0 ]]; then
    # If swapfile entry already exists, print a message and skip to the next steps
    echo -e '\nSwap file exists, skipping.\n'
else
    # If swapfile entry doesn't exist, start the process of creating a swapfile
    cd $HOME

    # Allocating 8GB of space for the swapfile
    sudo fallocate -l 8G $HOME/swapfile

    # Filling the swapfile with zeros using dd
    sudo dd if=/dev/zero of=swapfile bs=1K count=8M

    # Setting permissions for the swapfile
    sudo chmod 600 $HOME/swapfile

    # Creating swap on the swapfile
    sudo mkswap $HOME/swapfile

    # Activating the swapfile
    sudo swapon $HOME/swapfile

    # Displaying information about the swap
    sudo swapon --show

    # Adding an entry for the swapfile in /etc/fstab
    echo $HOME'/swapfile swap swap defaults 0 0' >> /etc/fstab

    # Printing a completion message
    echo -e '\nAdded successfully\n'
fi
