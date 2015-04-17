
!include WinMessages.nsh
RequestExecutionLevel user 
Icon "warcraft2.ico"
XPStyle on
!define TEMP1 $R0 

var Networking
var Fullscreen
var IPXServer
var IPXPort


Name "War2"
BrandingText " "
OutFile "WAR2.exe"
InstallButtonText "Play"

;ShowInstDetails show

ReserveFile /plugin InstallOptions.dll
ReserveFile "war2.ini"

;Order of pages
Page custom SetCustom ValidateCustom " " 
Page instfiles

Section "Components"

  ClearErrors
  FileOpen $0 $EXEDIR\Data\dosbox.conf w
  IfErrors dosboxerr
  StrCmp $Fullscreen "0" skipfs
    FileWrite $0 "[sdl]$\r$\n"
    FileWrite $0 "fullscreen=true$\r$\n"
  skipfs:
  ;FileWrite $0 "[cpu]$\r$\n"
  ;FileWrite $0 "cputype=pentium_slow$\r$\n"
  StrCmp $Networking "None" skipipx
  FileWrite $0 "[ipx]$\r$\n"
  FileWrite $0 "ipx=true$\r$\n"
  skipipx:
  FileWrite $0 "[autoexec]$\r$\n"

  StrCmp $Networking "Client" ipxconnect
  StrCmp $Networking "Server" ipxserver
  GoTo ipxnetdone

  ipxconnect:
  StrCmp $IPXServer "" ipxnetdone
    FileWrite $0 "ipxnet connect $IPXServer $IPXPort$\r$\n"
  GoTo ipxnetdone
  ipxserver:
    FileWrite $0 "ipxnet startserver $IPXPort$\r$\n"
  ipxnetdone:
  FileWrite $0 'mount c "$EXEDIR\Data\C"$\r$\n'
  FileWrite $0 "c:$\r$\n"
  FileWrite $0 "cd WAR2$\r$\n"
  FileWrite $0 "WAR2$\r$\n"
  FileWrite $0 "EXIT$\r$\n"
  FileClose $0

  Exec '"$EXEDIR\Data\DOSBox.exe" -conf "$EXEDIR\Data\dosbox.conf"'
  GoTo done
  dosboxerr:
  MessageBox MB_ICONEXCLAMATION|MB_OK "Could not write to '$EXEDIR\Data\dosbox.conf'"
    Abort
  done:
    Quit
SectionEnd

Function .onInit
  InitPluginsDir
  File /oname=$PLUGINSDIR\war2.ini "war2.ini"
FunctionEnd

Function SetCustom
  SendMessage $HWNDPARENT ${WM_SETTEXT} 0 "STR:Warcraft II Launcher"
  InstallOptions::initDialog "$PLUGINSDIR\war2.ini"
  Pop $0
  InstallOptions::show
  Pop $0

FunctionEnd

Function ValidateCustom

  ReadINIStr $0 "$PLUGINSDIR\war2.ini" "Settings" "State"
  StrCmp $0 0 validate
  StrCmp $0 4 ipxtype 
  Abort ; Return to the page

ipxtype:
  ;MessageBox MB_OK "here"
  ReadINIStr $0 "$PLUGINSDIR\war2.ini" "Field 4" "State"
  ReadINIStr $1 "$PLUGINSDIR\war2.ini" "Field 6" "HWND"
  ReadINIStr $2 "$PLUGINSDIR\war2.ini" "Field 6" "HWND2"
  ReadINIStr $3 "$PLUGINSDIR\war2.ini" "Field 8" "HWND"
  ReadINIStr $4 "$PLUGINSDIR\war2.ini" "Field 8" "HWND2"
  StrCmp $0 "Client" client
  StrCmp $0 "Server" server
  EnableWindow $1 0
  EnableWindow $2 0
  EnableWindow $3 0
  EnableWindow $4 0
  WriteINIStr "$PLUGINSDIR\war2.ini" "Field 6" "Flags" "DISABLED"
  WriteINIStr "$PLUGINSDIR\war2.ini" "Field 8" "Flags" "DISABLED"
  Abort
client:
  EnableWindow $1 1
  EnableWindow $2 1
  EnableWindow $3 1
  EnableWindow $4 1
  WriteINIStr "$PLUGINSDIR\war2.ini" "Field 6" "Flags" ""
  WriteINIStr "$PLUGINSDIR\war2.ini" "Field 8" "Flags" ""
  Abort
server:
  EnableWindow $1 0
  EnableWindow $2 0
  EnableWindow $3 1
  EnableWindow $4 1
  WriteINIStr "$PLUGINSDIR\war2.ini" "Field 6" "Flags" ""
  WriteINIStr "$PLUGINSDIR\war2.ini" "Field 8" "Flags" "DISABLED"
  Abort
 

validate:
  ReadINIStr ${TEMP1} "$PLUGINSDIR\war2.ini" "Field 2" "State"
  StrCpy '$Fullscreen' '${TEMP1}'
  ReadINIStr ${TEMP1} "$PLUGINSDIR\war2.ini" "Field 4" "State"
  StrCpy '$Networking' '${TEMP1}'
  ReadINIStr ${TEMP1} "$PLUGINSDIR\war2.ini" "Field 6" "State"
  StrCpy '$IPXServer' '${TEMP1}'
  ReadINIStr ${TEMP1} "$PLUGINSDIR\war2.ini" "Field 8" "State"
  StrCpy '$IPXPort' '${TEMP1}'

  IfFileExists "$EXEDIR\Data\DOSBox.exe" dosboxok
  MessageBox MB_ICONEXCLAMATION|MB_OK "DOSBox not found at '$EXEDIR\Data\DOSBox.exe'"
    Abort

  dosboxok:
  StrCmp "$Networking" "Client" ipxcheck
    GoTo done

  ipxcheck:
  StrCmp "$IPXServer" "" ipxserverblank
    GoTo done
  ipxserverblank:
    MessageBox MB_ICONEXCLAMATION|MB_OK "You must enter a Server"
    Abort
  done:
  
FunctionEnd
