#!/bin/sh

echo
echo "== https://github.com/bakawoot/PVPGN-setup =="
echo

echo "-- Installing packages --"
apt-get install -y cmake
apt-get install -y build-essential
apt-get install -y zlib1g-dev
apt-get install -y libmysql++-dev
apt-get install -y liblua5.1-0-dev 

echo
echo "-- Select a Branch"
read -r -p "'master' or 'develop': " branch

echo
echo "-- Cloning the latest PVPGN files --"
git clone --depth=50 --branch="${branch}" https://github.com/pvpgn/pvpgn-server.git /pvpgn/pvpgn-source

mkdir /pvpgn/pvpgn-source/build

cd /pvpgn/pvpgn-source/build
cmake -D CMAKE_INSTALL_PREFIX=/usr/local/pvpgn -D WITH_MYSQL=true -D WITH_LUA=true ../

echo
echo "-- Make & Install --"
make && make install

echo
echo "-- Do you want D2GS?"
read -r -p "'yes' or 'no': " d2gsSelector

if  [ "$d2gsSelector" = "yes" ]; then

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

    echo
    echo "-- Unrar --"
    apt-get install -y unrar

    case "$d2gsVersionSelector" in
        #case 1
        "1") cd /pvpgn/
        wget http://cdn.pvpgn.pro/d2gs/D2GS-109d.zip
        unrar x D2GS-109d.zip d2gs/
        rm D2GS-109d.zip
        cd /pvpgn/d2gs/
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.09d/
        ;;

        #case 2
        "2") cd /pvpgn/
        wget http://cdn.pvpgn.pro/d2gs/D2GS-110-bin-beta6.rar
        unrar x D2GS-110-bin-beta6.rar d2gs/
        rm D2GS-110-bin-beta6.rar
        cd /pvpgn/d2gs/
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.10/
        ;;
        
        #case 3
        "3") cd /pvpgn/
        wget http://cdn.pvpgn.pro/d2gs/D2GS-111b-build46.rar
        unrar x D2GS-111b-build46.rar d2gs/
        rm D2GS-111b-build46.rar
        cd /pvpgn/d2gs/
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.11b/
        ;;
        
        #case 4
        "4") cd /pvpgn/
        wget hhttp://cdn.pvpgn.pro/d2gs/D2GS-112a-build01.rar
        unrar x D2GS-112a-build01.rar d2gs/
        rm D2GS-112a-build01.rar
        cd /pvpgn/d2gs/
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.12a/
        ;;
        
        #case 5
        "5") cd /pvpgn/
        wget http://cdn.pvpgn.pro/d2gs/D2GS-113-build02.rar
        unrar x D2GS-113-build02.rar d2gs/
        rm D2GS-113-build02.rar
        cd /pvpgn/d2gs/
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.13c/
        ;;
        
        #case 6
        "6") cd /pvpgn/
        wget http://cdn.pvpgn.pro/d2gs/D2GS-113c-build03.rar
        unrar x D2GS-113c-build03.rar d2gs/
        rm D2GS-113c-build03.rar
        cd /pvpgn/d2gs/
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.13c/
        ;;
        
        #case 7
        "7") cd /pvpgn/
        wget http://cdn.pvpgn.pro/d2gs/D2GS-113d-build02_mxcen.rar
        unrar x D2GS-113d-build02_mxcen.rar d2gs/
        rm D2GS-113d-build02_mxcen.rar
        cd /pvpgn/d2gs/
        wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://cdn.pvpgn.pro/diablo2/1.13d/
        ;; 
    esac

    wget http://cdn.pvpgn.pro/diablo2/d2speech.mpq
    wget http://cdn.pvpgn.pro/diablo2/d2data.mpq
    wget http://cdn.pvpgn.pro/diablo2/d2exp.mpq
    wget http://cdn.pvpgn.pro/diablo2/d2sfx.mpq
    wget http://cdn.pvpgn.pro/diablo2/ijl11.dll
    
    echo
    echo "-- Setting up wine"
    dpkg --add-architecture i386
    apt-get install -y lib32z1
    apt-get install -y flex
    apt-get install -y bison
    apt-get install -y checkinstall

    mkdir /pvpgn/wine/
    cd /pvpgn/wine/
    wget https://dl.winehq.org/wine/source/5.x/wine-5.2.tar.xz
    tar xf wine-5.2.tar.xz
    cd /pvpgn/wine/wine-5.2/server
    wget https://git.redvex.de/RedVex2460/d2gs-linux/raw/master/sock.c
    cd /pvpgn/wine/wine-5.2/
    ./configure --without-x
    make -j4
    checkinstall -D make install
    winecfg

    #read -r -p "Bnetd ip: " bnetdip
    #read -r -p "Realm name: " realmname
    read -r -p "D2CS ip: " d2csip
    read -r -p "D2DBS ip: " d2dbsip
    #read -r -p "D2GS ip: " d2gsip
    read -r -p "D2CS password: " d2cspw

    #Create our Reg file
    echo "Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\D2Server\D2GS]
@=\"Diablo II Close Game Server\"
\"AutoUpdate\"=dword:00000000
\"AutoUpdateUrl\"=\"http://your.website.url/for.update\"
\"AutoUpdateVer\"=dword:00000000
\"AutoUpdateTimeout\"=dword:00007530
\"D2CSIP\"=\""${d2csip}"\"
\"D2CSPort\"=dword:000017e1
\"D2DBSIP\"=\""${d2dbsip}"\"
\"D2DBSPort\"=dword:000017e2
\"MaxGames\"=dword:00000400
\"MaxGameLife\"=dword:00003840
\"AdminPassword\"=\"9e75a42100e1b9e0b5d3873045084fae699adcb0\"
\"AdminPort\"=dword:000022b8
\"AdminTimeout\"=dword:00000e10
\"D2CSSecrect\"=\""${d2cspw}"\"
\"EnableNTMode\"=dword:00000000
\"EnablePreCacheMode\"=dword:00000001
\"IdleSleep\"=dword:00000001
\"BusySleep\"=dword:00000001
\"CharPendingTimeout\"=dword:00000258
\"DebugNetPacket\"=dword:00000000
\"DebugEventCallback\"=dword:00000000
\"EnableGSLog\"=dword:00000001
\"EnableGELog\"=dword:00000001
\"EnableGEMsg\"=dword:00000000
\"EnableGEPatch\"=dword:00000001
\"IntervalReconnectD2CS\"=dword:00000032
\"MultiCPUMask\"=dword:00000001
\"MaxPreferUsers\"=dword:000000b4
\"MaxPacketPerSecond\"=dword:000004b0
\"ServerConfFile\"=\"D2Server.ini\"
\"MOTD\"=\"Hello world!\"" >> d2gs_install.reg

#mv /pvpgn/d2gs ~/.wine/drive_c/
#wine regedit "c:\d2gs\d2gs_install.reg"
#wine "C:\d2gs\D2GSSVC.exe" -i
#wine net stop d2gs

#sed -i '$ a "D2CS"			"PvPGN Closed Realm"		"${d2csip}"' /usr/local/pvpgn/etc/pvpgn/realm.conf
#sed -i '$ a "s/0.0.0.0/"${d2csip}"/' /usr/local/pvpgn/etc/pvpgn/d2cs.conf
#sed -i '$ a "s/<d2gs-IP>,<another-d2gs-IP>/"${d2gsip}"/' /usr/local/pvpgn/etc/pvpgn/d2cs.conf
#sed -i '$ a "s/<bnetd-IP>/"${bnetdip}"/' /usr/local/pvpgn/etc/pvpgn/d2cs.conf
#sed -i '$ a "s/0.0.0.0/"${d2dbsip}"/' /usr/local/pvpgn/etc/pvpgn/d2dbs.conf
#sed -i '$ a "s/<d2gs-IP>,<another-d2gs-IP>/"${d2gsip}"/' /usr/local/pvpgn/etc/pvpgn/d2dbs.conf

#/usr/local/pvpgn/sbin/bnetd
#/usr/local/pvpgn/sbin/d2dbs
#/usr/local/pvpgn/sbin/d2cs
fi
