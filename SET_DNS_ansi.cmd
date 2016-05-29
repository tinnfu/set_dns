@echo off

echo ---------------------------------------------------------
:inputName
set name=无线网络连接
netsh interface ip show dns
echo please choose your network type:

echo ******************************************
echo 1. wireless network connection. (use WIFI)
echo 2. Wired network connection. (use reticle)
echo ******************************************

choice /c 12 /m "input: "
if %errorlevel% == 2 set name=本地连接

echo.
echo your network type is: "%name%"
echo.

echo ---------------------------------------------------------
:inputPosition
set currentPosition=
echo please choose your position:

echo **********
echo 1. HOME
echo 2. COMPANY
echo **********

choice /c 12 /m "input: "
if %errorlevel% == 2 goto company
goto home

echo ---------------------------------------------------------
:home
echo.
echo ................
echo your are in home
echo ................
echo.

echo.
echo .........................................
echo DO[1]: backup current DNS into backup_%date:~0,10%_%time:~1%.txt
set now=%date:~0,10%_%time:~1%
set now=%now:/=_%
set now=%now::=_%
netsh interface ip show dns > backup_%now%.txt
echo .........................................
echo.
echo .........................................
echo DO[2]: cover current DNS with dhcp
echo .........................................
echo.

echo ###############################################
netsh interface ip set dns name="%name%" source=dhcp
echo ###############################################

echo.
echo ...............................
echo end to set dhcp for DNS %name%
echo ...............................
echo.
goto end

echo ---------------------------------------------------------
:company
echo.
echo ..................
echo you are in company
echo ..................
echo.

set newDNS=
:internal
set /p newDNS=please input the new DNS IP: 

if "%newDNS%" == "" (
    echo Invalid input
    goto internal)

echo.
echo .........................................
echo DO[1]: backup current DNS into backup_%date:~0,10%_%time:~1%.txt
set now=%date:~0,10%_%time:~1%
set now=%now:/=_%
set now=%now::=_%
netsh interface ip show dns > backup_%now%.txt
echo .........................................
echo.
echo .........................................
echo DO[2]: cover current DNS with %newDNS%
echo .........................................
echo.

echo #################################################
netsh interface ip set dns name="%name%" source=static addr=%newDNS%
echo #################################################
echo.
echo ...............................
echo end to set addr="%newDNS%" for DNS %name%
echo ...............................
echo.
goto END

echo ---------------------------------------------------------
:end
echo DONE
echo.
ipconfig /flushdns
pause