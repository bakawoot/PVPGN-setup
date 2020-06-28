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
echo "Master[1] or Develop[2]"
read -r -p "[1/2]: " branch

if [ $branch == 1 ] 
then  
    $branch = master
else
    $branch = develop
fi 

echo
echo "-- Cloning the latest PVPGN files --"
git clone --depth=50 --branch="${branch}" https://github.com/pvpgn/pvpgn-server.git pvpgn/pvpgn-server

mv pvpgn/pvpgn-server pvpgn/pvpgn-source
mkdir pvpgn/pvpgn-source/build

echo
echo "-- CMake --"
cd pvpgn/pvpgn-source/build
cmake -D CMAKE_INSTALL_PREFIX=/usr/local/pvpgn -D WITH_MYSQL=true -D WITH_LUA=true ../

echo
echo "-- Make & Install --"
make && make install

echo
echo "-- DONE --"