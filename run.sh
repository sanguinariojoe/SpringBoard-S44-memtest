#!/bin/bash

EXE_PATH=$(pwd)
N_CPUS=$(grep -c ^processor /proc/cpuinfo)

function checkout_repo {
    cd "$EXE_PATH/download"
    folder=$1
    url=$2
    branch=$3
    if [ -d "$folder" ]; then
        cd $folder
        git stash
        git stash drop
        git pull origin $branch
        git submodule update
    else
        git clone -b $branch $url $folder
        cd "$folder"
        git submodule init && git submodule update
    fi
    cd $EXE_PATH
}

function compile_spring {
    folder=$1
    cd "$EXE_PATH/download/$folder"
    # patch
    patch -p0 < $EXE_PATH/memreport.patch
    # Compile and install
    mkdir -p "build"
    cd "build"
    cmake -DCMAKE_BUILD_TYPE="Release" -DCMAKE_INSTALL_PREFIX="$HOME/.spring/engine/$folder"  ..
    make -j$N_CPUS
    make install

    cd $EXE_PATH
}

function clear_installation {
    rm -rf "$HOME/.spring/games/memtest-sb.sdd"
    rm -rf "$HOME/.spring/games/memtest-s44.sdd"
    rm -rf "$HOME/.spring/games/memtest-sb-mutator.sdd"
    rm -rf "$HOME/.spring/engine/memtest-spring-master"
    rm -rf "$HOME/.spring/engine/memtest-spring-develop"
}

# Start cloning all the required stuff
mkdir -p "$EXE_PATH/download"
checkout_repo "memtest-sb" "https://github.com/Spring-SpringBoard/SpringBoard-Core" "master"
checkout_repo "memtest-s44" "https://gitlab.com/sanguinariojoe/spring1944.git" "104fixes"
checkout_repo "memtest-spring-master" "https://github.com/spring/spring.git" "master"
checkout_repo "memtest-spring-develop" "https://github.com/spring/spring.git" "develop"

# Clean eventual previously stored stuff
clear_installation

# Install all the packages
ln -s "$EXE_PATH/download/memtest-sb" "$HOME/.spring/games/memtest-sb.sdd"
ln -s "$EXE_PATH/download/memtest-s44" "$HOME/.spring/games/memtest-s44.sdd"
ln -s "$EXE_PATH/memtest-sb-mutator" "$HOME/.spring/games/memtest-sb-mutator.sdd"
if [ ! -f "$HOME/.spring/maps/1944_moro_river_v1.sd7" ]; then
    # Permanent file
    cp "$EXE_PATH/1944_moro_river_v1.sd7" "$HOME/.spring/maps/1944_moro_river_v1.sd7"
fi

# Compile and install both spring engines
compile_spring "memtest-spring-master"
compile_spring "memtest-spring-develop"

# Launch both instances
mkdir -p "$EXE_PATH/results"
cd "$EXE_PATH/results"
$HOME/.spring/engine/memtest-spring-master/bin/spring $EXE_PATH/script.txt > master.log 2>&1
$HOME/.spring/engine/memtest-spring-develop/bin/spring $EXE_PATH/script.txt > develop.log 2>&1

# Clear Spring user installation
clear_installation
