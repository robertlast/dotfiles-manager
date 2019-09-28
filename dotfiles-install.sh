#!/bin/bash
# Installs dotfiles from a directory organized by application.
usage () {
    cat <<HELP_USAGE
    $0  [-i <dotfiles-path>] [-v]

    -i  Source directory containing dotfiles.
    -v  Verbose mode.

HELP_USAGE
exit 0
}

# Get the directory of this script:
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Directory with dotfiles organized by app:
DOTFILES_SOURCE_SUBDIR_DEFAULT="dotfiles"
DOTFILES_SOURCE_PATH_DEFAULT=$SCRIPT_PATH/$DOTFILES_SOURCE_SUBDIR_DEFAULT
dotfiles_source_path=$DOTFILES_SOURCE_PATH_DEFAULT
# Copy ('cp') command options:
cp_opts="-riT"

# Parse command line arguments:
while [[ "$#" -gt 0 ]]; do case $1 in
  # Get help:
  -h|--help) usage; shift;;
  # Use a specified config file:
  -i|--dotfile-dir) dotfiles_source_path="$2"; shift;;
  # Use -v option for 'cp':
  -v|--verbose) cp_opts="${cp_opts}v";; 
  *) echo "Unknown parameter: $1"; exit 1;;
esac; shift; done

# Copy the dotfiles from each source directories to the user's home:
for app_dir in $dotfiles_source_path/*/
do
    # Get subdir name:
    app_name=$(basename $app_dir)
    # Prompt user to install dotfiles for this app:
    echo -n "Install dotfiles for $app_name [y/N]?: "
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        # Copy this app's relavant dotfiles to user's home directory: 
        cp $cp_opts $app_dir $HOME
    fi
done