# dotfiles-manager
Scripts for batch installing and saving of dotfiles on a \*nix system.

Usage
-----

    ./dotfiles-collect.sh  [-i <config-file>] [-o <dotfiles-path>] [-f] [-v]

    -i  JSON-formatted config file, contains the locations of dotfiles.
    -o  Directory where dotfiles will be copied.
    -f  Existing files will be overwritten.
    -v  Verbose mode.
    
    
    ./dotfiles-install.sh  [-i <dotfiles-path>] [-v]

    -i  Source directory containing dotfiles.
    -f  Don't prompt before deploying dotfiles for each app (non-interactive mode). 
    -v  Verbose mode.

Dependencies
------------

- GNU grep (with -P option) 

Configuration File
------------------

Dotfile locations are defined in file-locations.json
