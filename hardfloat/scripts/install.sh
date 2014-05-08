#!/bin/bash
vlsi_bashrc="/scratch/cad/tools/vlsi.bashrc" #current location of vcs toolchain refs

if grep "$vlsi.bashrc" ~/.bash_profile
then
    echo "vlsi.bashrc already added to bash_profile SKIPPING"
else
    echo "adding vlsi.bashrc to .bash_profile"
    echo $'\nsource '${vlsi_bashrc}';'>> ~/.bash_profile #add to profile if not already
    echo "" >> ~/.bash_profile
    source ~/.bash_profile
fi

source build.sh #set up jhauser folder with appropriate symbolic links

