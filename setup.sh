#!/bin/sh

echo
echo "== https://github.com/bakawoot/PVPGN-setup =="
echo

echo "-- Installing packages --"

echo "- Build-essential"
apt-get install build-essential 

echo
echo "- Clang"
apt-get install clang

echo
echo "- LibC++-Dev"
apt-get install libc++-dev

echo
echo "- Git"
apt-get install git

echo
echo "- Cmake"
apt-get install cmake

echo
echo "- ZLib1G-DEV"
apt-get install zlib1g-dev

echo
echo "- LibLua5.1-0-DEV"
apt-get install liblua5.1-0-dev 

echo
echo "- LibMYSQL++-DEV"
apt-get install libmysql++-dev

echo
echo "-- Select a Branch"
read -r -p "'master' or 'develop': " branch

echo
echo "-- Do you want LUA support?"
read -r -p "'yes' or 'no': " luaSelector

case "$luaSelector" in
    #case 1
    "yes") lua='true' ;;

    #case 2
    "no") lua='false' ;;
esac

echo
echo "-- Do you want MYSQL support?"
read -r -p "'yes' or 'no': " mysqlSelector

case "$mysqlSelector" in
    #case 1
    "yes") mysql='true' ;;

    #case 2
    "no") mysql='false' ;;
esac

echo
echo "-- Cloning the latest PVPGN files --"
git clone --depth=50 --branch="${branch}" https://github.com/pvpgn/pvpgn-server.git pvpgn/pvpgn-server

mv pvpgn/pvpgn-server pvpgn/pvpgn-source
mkdir pvpgn/pvpgn-source/build

echo
echo "-- CMake --"
cd pvpgn/pvpgn-source/build
cmake -D CMAKE_INSTALL_PREFIX=/usr/local/pvpgn -D WITH_MYSQL="${mysql}" -D WITH_LUA="${lua}" ../

echo
echo "-- Make & Install --"
make && make install

echo
echo "-- Do you want D2GS?"
read -r -p "'yes' or 'no': " d2gsSelector

if  [ "$d2gsSelector" = "yes" ]; then
    echo
    echo "-- Installing additional packages --"
    apt-get install unrar
    apt-get install lib32zl
    apt-get install gcc-multilib
    apt-get install xserver-xorg-dev:i386
    apt-get install libfreetype6-dev:i386
    dpkg --add-architecture i386

    cd ..
    cd ..
    echo
    echo "-- Do you want D2GS?"
    echo "Which D2GS version?"
    echo "[1]1.09d"
    echo "[2]1.10 (beta6)"
    echo "[3]1.11b (build46)"
    echo "[4]1.12a (build01)"
    echo "[5]1.13 (build02)"
    echo "[6]1.13c (build03)"
    echo "[7]1.13d (build02)"

    read -r -p "'[1/2/3/4/5/6/7]': " d2gsVersionSelector
    case "$d2gsVersionSelector" in
        #case 1
        "1") wget http://cdn.pvpgn.pro/d2gs/D2GS-109d.zip
        unrar e D2GS-109d.zip d2gs/
        ;;

        #case 2
        "2") wget http://cdn.pvpgn.pro/d2gs/D2GS-110-bin-beta6.rar
        unrar e D2GS-110-bin-beta6.rar d2gs/
        ;;
        
        #case 3
        "3") wget http://cdn.pvpgn.pro/d2gs/D2GS-111b-build46.rar
        unrar e D2GS-111b-build46.rar d2gs/
        ;;
        
        #case 4
        "4") wget hhttp://cdn.pvpgn.pro/d2gs/D2GS-112a-build01.rar
        unrar e D2GS-112a-build01.rar d2gs/
        ;;
        
        #case 5
        "5") wget http://cdn.pvpgn.pro/d2gs/D2GS-113-build02.rar
        unrar e D2GS-113-build02.rar d2gs/
        ;;
        
        #case 6
        "6") wget http://cdn.pvpgn.pro/d2gs/D2GS-113c-build03.rar
        unrar e D2GS-113c-build03.rar d2gs/
        ;;
        
        #case 7
        "7") wget http://cdn.pvpgn.pro/d2gs/D2GS-113d-build02_mxcen.rar
        unrar e D2GS-113d-build02_mxcen.rar d2gs/
        ;;
    esac
fi
