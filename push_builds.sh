#!/usr/bin/env bash

butler_name="rxn7/2x"

project_version=$(grep "config/version=" ./project.godot | cut -d'"' -f2)
echo "Project version: $project_version"

build_and_push_for_platform() {
    platform=$1
    target_dir=$2
    push_full_dir="${3:-true}"

    printf "\n\n"
    echo -e "\033[0;92mBuilding the project for $1 to $2\033[0m"
    printf "\n\n"
    
    rm -rf $(dirname $target_dir)
    mkdir -p $(dirname $target_dir)

    godot --headless --export-release $platform $target_dir --quit
    if [ $? -eq 0 ]; then
        printf "\n\n"
        echo -e "\033[0;92mSuccessfully build for $platform, now pushing it to itch.\033[0m"
        printf "\n\n"
        if [ $push_full_dir = true ]; then push_dir=$(dirname $target_dir); else push_dir=$target_dir; fi
        butler push $push_dir "$butler_name:$platform" --userversion $project_version
    else
        printf "\n\n"
        echo -e "\033[0;91mFailed to build for $platform\033[0m"
        exit
    fi
}

build_and_push_for_platform "Web" ./builds/web/index.html
build_and_push_for_platform "Android" ./builds/android/2x.apk false
build_and_push_for_platform "Linux" ./builds/linux/2x.x86_64 false
build_and_push_for_platform "Windows" ./builds/windows/2x.exe false

project_version=$(echo $project_version | awk -F. '{$NF = $NF + 1;} 1' OFS=. | sed 's/^\./0./') 
echo "New project version: $project_version"

sed -i "s/config\/version=\".*\"/config\/version=\"$project_version\"/" project.godot