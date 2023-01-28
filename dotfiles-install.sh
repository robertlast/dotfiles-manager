#!/bin/bash
# Installs dotfiles from a directory organized by application.
usage () {
    cat <<HELP_USAGE
    $0  [-i <dotfiles-path>] [-v] []

    -i  Source directory containing dotfiles.
    -y  Don't prompt (non-interactive mode).    
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
cp_opts="-rT"

# Parse command line arguments:
while [[ "$#" -gt 0 ]]; do case $1 in
  # Get help:
  -h|--help) usage; shift;;
  # Use a specified config file:
  -i|--dotfile-dir) dotfiles_source_path="$2"; shift;;
  # Don't prompt before deploying dotfiles for each app:
  -f|--force) no_prompt=true;;
  # Use -v option for 'cp':
  -v|--verbose) verbose_mode="true";;  
  *) echo "Unknown parameter: $1"; exit 1;;
esac; shift; done

if [ "$no_prompt" != "true" ] ;then
    cp_opts="${cp_opts}i"
fi

if [ "$verbose_mode" == "true" ] ;then
    cp_opts="${cp_opts}v"
fi

# Copy the dotfiles from each source directories to the user's home:
[ "$verbose_mode" == "true" ] && echo "Deploying dotfiles from: ${dotfiles_source_path}"
for app_dir in $dotfiles_source_path/*/
do
    # Get subdir name:
    app_name=$(basename $app_dir)
    if [ "$no_prompt" == "true" ] ;then
        answer=y
    else
        # Prompt user to install dotfiles for this app:
        echo -n "Install dotfiles for $app_name [y/N]?: "
        read answer
    fi

    if [ "$answer" != "${answer#[Yy]}" ] ;then
        # Copy this app's relavant dotfiles to user's home directory: 
        cp $cp_opts $app_dir $HOME
        echo "copying"
    fi
done