#!/bin/sh

echo
echo "== https://github.com/bakawoot/PVPGN-setup =="
echo

echo "-- Installing packages --"

echo "- Build-essential"
apt-get install -y build-essential 

echo
echo "- Clang"
apt-get install-y clang

echo
echo "- LibC++-Dev"
apt-get install -y libc++-dev

echo
echo "- Cmake"
apt-get install -y cmake

echo
echo "- ZLib1G-DEV"
apt-get install -y zlib1g-dev

echo
echo "-- Select a Branch"
read -r -p "'master' or 'develop': " branch

echo
echo "-- Do you want LUA support?"
read -r -p "'yes' or 'no': " luaSelector

case "$luaSelector" in
    #case 1
    "yes") lua='true'
    echo
    echo "- LibLua5.1-0-DEV"
    apt-get install -y liblua5.1-0-dev 
    ;;

    #case 2
    "no") lua='false' ;;
esac

echo
echo "-- Do you want MYSQL support?"
read -r -p "'yes' or 'no': " mysqlSelector

case "$mysqlSelector" in
    #case 1
    "yes") mysql='true'
    echo
    echo "- LibMYSQL++-DEV"
    apt-get install -y libmysql++-dev
    ;;

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
    apt-get install -y unrar
    apt-get install -y flex
    apt-get install -y bison
    apt-get install -y lib32zl
    apt-get install -y gcc-multilib
    apt-get install -y xserver-xorg-dev:i386
    apt-get install -y libfreetype6-dev:i386
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
        unrar e -o+ D2GS-109d.zip d2gs/
        cd d2gs
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.09d/
        ;;

        #case 2
        "2") wget http://cdn.pvpgn.pro/d2gs/D2GS-110-bin-beta6.rar
        unrar e -o+ D2GS-110-bin-beta6.rar d2gs/
        cd d2gs
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.10/
        ;;
        
        #case 3
        "3") wget http://cdn.pvpgn.pro/d2gs/D2GS-111b-build46.rar
        unrar e -o+ D2GS-111b-build46.rar d2gs/
        cd d2gs
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.11b/
        ;;
        
        #case 4
        "4") wget hhttp://cdn.pvpgn.pro/d2gs/D2GS-112a-build01.rar
        unrar e -o+ D2GS-112a-build01.rar d2gs/
        cd d2gs
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.12a/
        ;;
        
        #case 5
        "5") wget http://cdn.pvpgn.pro/d2gs/D2GS-113-build02.rar
        unrar e -o+ D2GS-113-build02.rar d2gs/
        cd d2gs
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.13c/
        ;;
        
        #case 6
        "6") wget http://cdn.pvpgn.pro/d2gs/D2GS-113c-build03.rar
        unrar e -o+ D2GS-113c-build03.rar d2gs/
        cd d2gs
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.13c/
        ;;
        
        #case 7
        "7") wget http://cdn.pvpgn.pro/d2gs/D2GS-113d-build02_mxcen.rar
        unrar e -o+ D2GS-113d-build02_mxcen.rar d2gs/
        cd d2gs
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.13d/
        ;; 
    esac
    
    echo
    echo "-- Setting up wine"
    dpkg --add-architecture i386
    wget -O - https://dl.winehq.org/wine-builds/winehq.key
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
    apt-get install --install-recommends wine-stable

    #Create our Reg file
    echo "REGEDIT 4
    
    [HKEY_LOCAL_MACHINE\SOFTWARE\D2Server\D2GS]
    echo @="Diablo II Close Game Server"
    echo "AutoUpdate"=dword:00000000
    echo "AutoUpdateUrl"="http://your.website.url/for.update"
    echo "AutoUpdateVer"=dword:00000000
    echo "AutoUpdateTimeout"=dword:00007530
    echo "D2CSIP"="192.168.1.1"
    echo "D2CSPort"=dword:000017e1
    echo "D2DBSIP"="192.168.1.1"
    echo "D2DBSPort"=dword:000017e2
    echo "MaxGames"=dword:00000400
    echo "MaxGameLife"=dword:00003840
    echo "AdminPassword"="9e75a42100e1b9e0b5d3873045084fae699adcb0"
    echo "AdminPort"=dword:000022b8
    echo "AdminTimeout"=dword:00000e10
    echo "D2CSSecrect"=""
    echo "EnableNTMode"=dword:00000001
    echo "EnablePreCacheMode"=dword:00000001
    echo "IdleSleep"=dword:00000001
    echo "BusySleep"=dword:00000001
    echo "CharPendingTimeout"=dword:00000258
    echo "DebugNetPacket"=dword:00000000
    echo "DebugEventCallback"=dword:00000000
    echo "EnableGSLog"=dword:00000001
    echo "EnableGELog"=dword:00000001
    echo "EnableGEMsg"=dword:00000000
    echo "EnableGEPatch"=dword:00000001
    echo "IntervalReconnectD2CS"=dword:00000032
    echo "MultiCPUMask"=dword:00000001
    echo "MaxPreferUsers"=dword:000000b4
    echo "MaxPacketPerSecond"=dword:000004b0
    echo "ServerConfFile"="D2Server.ini"
    echo "MOTD"="Hello world!"" >> d2gs_install.reg
fi