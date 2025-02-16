# Warcraft II DosBox Launcher

This project consists of a bash script (for Linux/Mac) and a NSIS package 
(for Windows) that serves as an easy way to launch Warcraft II with DOSBox
with the ideal settings.

It also supports an easy way for setting up Multiplayer games using the
ipxnet feature of DOSBox.

## Instructions Linux/Mac

First install DOSBox.
```
sudo apt install dosbox
```

Next clone this repository and run the WAR2.sh script
```
git clone https://github.com/tjdub/war2
```

Then put your DOS version of Warcraft II in the war2/Data/C/WAR2/ folder.

Finally, run the WAR2.sh script.
```
cd war2
./WAR2.sh
```

## Build Instructions for Windows
 1. Clone/Download this repository.  
 2. Put your DOS version of Warcraft II in the war2/Data/C/WAR2/ folder.
 3. Install [DOSBox](https://www.dosbox.com/) into the war2/Data/ folder
 4. Install [NSIS](https://nsis.sourceforge.io/Download)
 5. Open the war2/nsis/war2.nsi file with NSIS to build the launcher

## Dedicated ipxnet Server (Optional)

Although DOSBox has a built in ipxnet server, you may want to set up 
a dedicated server.  This is possible with the standalone ipxnet 
server here:
 
https://github.com/intangir/ipxnet/

### Quick Dedicated Server Instructions on Ubuntu
```
sudo apt install make g++ libsdl-net1.2-dev
git clone https://github.com/intangir/ipxnet/
cd ipxnet
make
./ipxnet 2130
```

