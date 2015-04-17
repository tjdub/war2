#!/bin/sh
if [ ! -w Data/dosbox.conf ]; then
  echo "ERROR: couldn't write to $PWD/Data/dosbox.conf"
  echo "[Enter to Continue]"
  read IN
  exit 1;
fi
if [ ! -f Data/C/WAR2/WAR2.EXE ]; then
  echo "ERROR: WAR2.EXE not found in $PWD/Data/C/WAR2/"
  echo "[Enter to Continue]"
  read IN
  exit 1;
fi

if [ "$(uname)" = "Darwin" ]; then
  DOSBOX=`whichapp DOSBox`
else
  DOSBOX=`which dosbox`
fi
if [ "${DOSBOX}x" = "x" ]; then
  echo "ERROR: dosbox does not appear to be installed on this computer."
  echo "See http://www.dosbox.com"
  echo "[Enter to Continue]"
  read IN
  exit 1;
fi

IPX=0
STARTSERVER=0
CONNECT=0
if [ "$1x" = "--startserverx" ]; then
  IPX=1
  IPXPORT=$2;
  STARTSERVER=1
elif [ "$1x" = "--connectx" ]; then
  IPX=1
  IPXSERVER=$2
  IPXPORT=$3
  CONNECT=1
elif [ "$1x" = "x" ]; then
  echo "Usage: WAR2.sh [--connect SERVER [PORT]] [--startserver [PORT]]"
  echo " "
  echo "Do you want to setup networking options? [N/y]"
  read IN
  if [ "${IN}x" = "yx" ]; then
    IPX=1
    echo "Do you want to start a server? [N/y]"
    read IN
    if [ "${IN}x" = "yx" ]; then
      STARTSERVER=1
      echo "UDP Port Number? [2130]"
      read IPXPORT
    else
      CONNECT=1
      echo "IP/Hostname of the server you want to connect to?"
      read IPXSERVER 
      echo "UDP Port Number? [213]"
      read IPXPORT
    fi
  fi
fi

if [ "$STARTSERVER" = "1" ]; then
  if [ "${IPXPORT}x" = "x" ]; then
    IPXPORT=2130;
  fi
  if [ $IPXPORT -lt 1024 ]; then
    echo "
WARNING: 213 is the default DOSBox port and usually only root can run a server
         with a PORT < 1024 (running as root is NOT advised)"
    echo " "
    echo "The command 'WAR2.sh --startserver 2130' would probably work better."
    echo " "
    echo "[Enter to Continue]"
    read IN
  fi
elif [ "$CONNECT" = "1" ]; then
  if [ "${IPXSERVER}x" = "x" ]; then
    echo "ERROR: you must provide a SERVER to connect to when using --connect"
    echo "[Enter to Continue]"
    read IN
    exit 1;
  fi
  if [ "${IPXPORT}x" = "x" ]; then
    IPXPORT=213;
  fi
fi

# build dosbox.conf
echo -n "" > Data/dosbox.conf
#echo "
#[cpu]
#cputype=dynamic
#"  >> Data/dosbox.conf
if [ "$IPX" = "1" ]; then
  echo "
[ipx]
ipx=true" >> Data/dosbox.conf
fi
echo "
[autoexec]" >> Data/dosbox.conf

if [ "${IPXSERVER}x" != "x" ]; then
  echo "ipxnet connect $IPXSERVER $IPXPORT" >> Data/dosbox.conf
elif [ "${IPXPORT}x" != "x" ]; then 
  echo "ipxnet startserver $IPXPORT" >> Data/dosbox.conf
fi

echo "mount c $PWD/Data/C/
c:
cd WAR2
WAR2
EXIT" >> Data/dosbox.conf
# done building Data/dosbox.conf

# run it 
if [ "$(uname)" = "Darwin" ]; then
  open -a DOSBox --args -conf Data/dosbox.conf
else
  dosbox -conf Data/dosbox.conf
fi
