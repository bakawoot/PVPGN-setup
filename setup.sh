#!/bin/sh

echo
echo "== https://github.com/bakawoot/PVPGN-setup =="
echo

echo "-- Installing packages --"
apt-get install -y cmake build-essential zlib1g-dev libmysql++-dev liblua5.1-0-dev 

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
echo "-- Should we setup the firewall rules for PvPGN? --"
read -r -p "'yes' or 'no': " fwrulespvpgn

if  [ "$fwrulespvpgn" = "yes" ]; then

    #Setting up firewall rule
    ufw allow 6112      #Bnetd
fi

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
    
    #setting up wine
    dpkg --add-architecture i386
    wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
    sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' 
    apt-get install -y lib32z1 flex bison gcc-multilib g++-multilib libx11-dev xorg-dev libx11-dev:i386 ibxcursor1:i386 libfreetype6-dev:i386 zlib1g:i386 mesa-vulkan-drivers:i386 libzstd1:i386 acl gcc-10-base:i386 libasound2-plugins libasyncns0 libatomic1:i386 libblkid1:i386 libbsd0:i386 libbz2-1.0:i386 libc6:i386 libcom-err2:i386 libcrypt1:i386  libdb5.3:i386 libdrm-amdgpu1:i386 libdrm-intel1:i386 libdrm-nouveau2:i386 libdrm2:i386 libedit2:i386 libelf1:i386 libexpat1:i386 libffi7:i386 libflac8 libfreetype6:i386 libgcc-s1:i386 libgcrypt20:i386 libgl1:i386 libgl1-mesa-dri:i386 libglapi-mesa:i386 libglvnd0:i386 libglx-mesa0:i386 libglx0:i386 libgpg-error-l10n libgpg-error0:i386 libgpm2:i386 libidn2-0:i386 libjack-jackd2-0 libllvm10:i386 liblz4-1:i386 liblzma5:i386 libmount1:i386 libncurses6:i386 libpciaccess0:i386 libpcre2-8-0:i386 libpcre3:i386 libpixman-1-0:i386 libpng16-16:i386 libpulse0 libsamplerate0 libselinux1:i386 libsensors5:i386 libsndfile1 libstdc++6:i386 libsystemd0:i386 libtinfo6:i386 libudev1:i386 libunistring2:i386 libuuid1:i386 libva2 libvorbisenc2 libvulkan1:i386 libwayland-client0:i386 libx11-6:i386 libx11-xcb1:i386 libxau6:i386 libxcb-dri2-0:i386 libxcb-dri3-0:i386 libxcb-glx0:i386 libxcb-present0:i386 libxcb-randr0:i386 libxcb-sync1:i386 libxcb1:i386 libxdamage1:i386 libxdmcp6:i386 libxext6:i386 libxfixes3:i386 libxshmfence1:i386  libxxf86vm1:i386
    mkdir /pvpgn/wine/
    cd /pvpgn/wine/
    wget https://dl.winehq.org/wine/source/5.x/wine-5.2.tar.xz
    tar xf wine-5.2.tar.xz
    rm wine-5.2.tar.xz
    cd /pvpgn/wine/wine-5.2/server
    rm sock.c
    wget https://raw.githubusercontent.com/bakawoot/PVPGN-setup/master/Sock%20files/5.2/sock.c
    cd /pvpgn/wine/wine-5.2/
    ./configure
    make
    make install
    winecfg

    mv /pvpgn/d2gs ~/.wine/drive_c/

    echo
    echo "-- Should we setup the firewall rules for D2GS? --"
    read -r -p "'yes' or 'no': " fwrulesd2gs

    if  [ "$fwrulesd2gs" = "yes" ]; then

        #Setting up firewall rules
        ufw allow 6113/tcp  #D2CS
        ufw allow 4000/tcp  #D2GS
    fi
fi

#Delete PvPGN(+/wine) source folder
rm -r /pvpgn

echo
echo "-- Do you want to set up PvPGN now? --"
read -r -p "'yes' or 'no': " setuppvpgn

if  [ "$setuppvpgn" = "yes" ]; then

    read -r -p "Realm name: " realmname
    read -r -p "External IP: " externip
    read -r -p "Bnetd IP: " bnetdip
    read -r -p "D2GS IP: " d2gsip
    read -r -p "D2DBS IP: " d2dbsip
    read -r -p "D2CS IP: " d2csip
    read -r -p "D2CS password: " d2cspw

    #realm.conf
    sed -i "s/<realmname>/$realmname/g" /usr/local/pvpgn/etc/pvpgn/realm.conf
    sed -i "s/<d2csip>/$d2csip/g" /usr/local/pvpgn/etc/pvpgn/realm.conf
    #d2cs.conf
    sed -i "s/<realmname>/$realmname/g" /usr/local/pvpgn/etc/pvpgn/d2cs.conf
    sed -i "s/<d2csip>/$d2csip/g" /usr/local/pvpgn/etc/pvpgn/d2cs.conf
    sed -i "s/<d2gsip>/$d2gsip/g" /usr/local/pvpgn/etc/pvpgn/d2cs.conf
    sed -i "s/<bnetdip>/$bnetdip/g" /usr/local/pvpgn/etc/pvpgn/d2cs.conf
    sed -i "s/<d2cspw>/$d2cspw/g" /usr/local/pvpgn/etc/pvpgn/d2cs.conf
    #d2dbs.conf
    sed -i "s/<d2dbsip>/$d2dbsip/g" /usr/local/pvpgn/etc/pvpgn/d2dbs.conf
    sed -i "s/<d2gsip>/$d2gsip/g" /usr/local/pvpgn/etc/pvpgn/d2dbs.conf
    #address_translation.conf
    sed -i "s/<bnetdip>/$bnetdip/g" /usr/local/pvpgn/etc/pvpgn/address_translation.conf
    sed -i "s/<d2csip>/$d2csip/g" /usr/local/pvpgn/etc/pvpgn/address_translation.conf
    sed -i "s/<d2gsip>/$d2gsip/g" /usr/local/pvpgn/etc/pvpgn/address_translation.conf
    sed -i "s/<externalip>/$externip/g" /usr/local/pvpgn/etc/pvpgn/address_translation.conf

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
\"MOTD\"=\"Hello world!\"" >> ~/.wine/drive_c/d2gs/d2gs_install.reg
    
    wine regedit "c:\d2gs\d2gs_install.reg"
    wine "C:\d2gs\D2GSSVC.exe" -i
    wine net stop d2gs
fi

/usr/local/pvpgn/sbin/bnetd
sleep 5 #we have to wait... 5 secs for bnetd to start.
/usr/local/pvpgn/sbin/d2cs
sleep 5 #we have to wait... 5 secs for d2cs to start.
/usr/local/pvpgn/sbin/d2dbs

if  [ "$d2gsSelector" = "yes" ]; then
    sleep 5 #we have to wait... 5 secs for d2dbs to start.
    wine net start d2gs
fi

echo
echo "Done."
echo