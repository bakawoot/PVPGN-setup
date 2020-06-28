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
read -r -p "'master' or 'develop'" branch

echo
echo "-- Do you want LUA support?"
read -r -p "'yes' or 'no'" luaSelector

case "$luaSelector" in
    #case 1
    "yes") lua='true' ;;

    #case 2
    "no") lua='false' ;;
esac

echo
echo "-- Do you want MYSQL support?"
read -r -p "'yes' or 'no'" mysqlSelector

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
echo "-- DONE --"