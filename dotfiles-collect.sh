#!/bin/bash
# Collects dotfiles from the current system and stores them in a directory organized by application.
usage () {
    cat <<HELP_USAGE
    $0  [-i <config-file>] [-o <dotfiles-path>] [-f] [-v]

    -i  JSON-formatted config file, contains the locations of dotfiles
    -o  File to write all the log lines
    -f  Existing files will be overwritten.
    -v  Verbose mode.

HELP_USAGE
exit 0
}

# Path of this script:
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Path where the collected dotfiles will be stored:
DOTFILES_TARGET_SUBDIR_DEFAULT="dotfiles"
DOTFILES_TARGET_PATH_DEFAULT=$SCRIPT_PATH/$DOTFILES_TARGET_SUBDIR_DEFAULT
dotfiles_target_path=$DOTFILES_TARGET_PATH_DEFAULT
# JSON-formatted config file, contains the locations of the dotfiles:
CONFIG_FILE_DEFAULT="file-locations.json"
CONFIG_FILE_PATH_DEFAULT=$SCRIPT_PATH/$CONFIG_FILE_DEFAULT
config_file_path=$CONFIG_FILE_PATH_DEFAULT
# Copy ('cp') command options:
cp_opts="-r"
overwrite_files=false

# Parse command line arguments:
while [[ "$#" -gt 0 ]]; do case $1 in
  # Get help:
  -h|--help) usage; shift;;
  # Use a specified config file:
  -i|--config-file) config_file_path="$2"; shift;;
  # Use a specified directory to store the collected dotfiles:
  -o|--dotfile-output-dir) dotfiles_target_path="$2"; shift;;
  # Use -f option for 'cp':
  -f|--force) overwrite_files=true;;    
  # Use -v option for 'cp':
  -v|--verbose) cp_opts="${cp_opts}v";; 
  *) echo "Unknown parameter: $1"; exit 1;;
esac; shift; done

if [ $overwrite_files = true ]
then
    cp_opts="${cp_opts}f"
else
    cp_opts="${cp_opts}i"
fi

# For each app in the (JSON key) in the config file:
grep -zoP '"\K.*(?=\":\s+)' $config_file_path | while read -r app_name ; do
    # Get source file path(s) for the dotfile for that app:
    source_paths_rel=$(grep -zoP "\"$app_name\":\s*\K(\[.*\]|\"[^\"]*\"|[\d\.]*)" $config_file_path)
    app_found=false
    for source_path_rel in $(echo $source_paths_rel | grep -Po "\"\K[^\",]*(?=\")"); do
        source_path=${HOME}/${source_path_rel}
        # Make sure the source file exists:
        if [ -e $source_path ]
        then 
            # Tell the user that we found the dotfiles for this app:
            if [ $app_found = false ]
            then
                echo "+ $app_name found"
                app_found=true
            fi
            #echo $app_found
            target_path=${dotfiles_target_path}/$app_name/$(dirname $source_path_rel)
            # Store the dotfile:
            mkdir -p $target_path && cp $cp_opts $source_path $target_path < /dev/tty 
            # HACK: Redirect terminal input to cp so we can use interactive mode.
        fi
    done
    # Tell the user that we could not find any dotfiles for this app:
    if [ $app_found  = false ]
    then 
        echo "- $app_name not found"
    fi
done