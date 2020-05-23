# dotfiles-manager
Scripts for batch installing and saving of dotfiles on a \*nix system.

Usage
-----

    ./dotfiles-collect.sh  [-i <config-file>] [-o <dotfiles-path>] [-f] [-v]

    -i  JSON-formatted config file, contains the locations of dotfiles
    -o  File to write all the log lines
    -f  Existing files will be overwritten.
    -v  Verbose mode.
    
    
    ./dotfiles-install.sh  [-i <dotfiles-path>] [-v]

    -i  Source directory containing dotfiles.
    -v  Verbose mode.

Dependencies
------------

- GNU grep (with -P option) 

Configuration File
------------------

Dotfile locations are defined in file-locations.json
