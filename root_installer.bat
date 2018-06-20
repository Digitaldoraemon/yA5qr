@Echo off
:: This program serves as an installer for different functions
:: There is not much complications in this program
:: It only extracts files and set couple of values
:: Run this program in a VM if necessary
:: Of course this program will check if you are running a different
:: OS and will provide optimal conigurations for such systems
::
:: I will write notes near the commands to provdide more understandings
:start
Goto check_disk
:ERROR
Echo ################################
Echo An error had occured
Echo ################################
Echo.
Echo Reason:
Echo %error_reason%
pause
exit
:check_disk
:: Get default disk caption
for /f %%a in ('
wmic logicaldisk where "VolumeName='%lookfor%'" get Caption ^| find ":"
') do set LETTER=%%a
goto check_admin
:check_admin
net session >nul 2>&1
If %ERRORLEVEL% == 0 set SYSTEM_ADMIN=1
If not %ERRORLEVEL% == 0 set SYSTEM_ADMIN=0
:: The command above checks for administrator rights
If %SYSTEM_ADMIN% == 0 goto check_wine
If %SYSTEM_ADMIN% == 1 goto stop_admin
goto check_win_ver
:stop_admin
Echo ################################
Echo Please run without admin rights
Echo ################################
Echo.
Echo Press any key to exit program..
Pause >NUL
exit
:check_wine
:: One of the properties of wine is that it runs in administrator mode
:: BUT, the default folder location will be somewhere other than SYSTEM32
:: By using these special properties,
:: I can determine if it's running in some emulator
If exist sethc.exe set wine_used=1
If not exist sethc.exe set wine_used=0
Goto check_win_ver
:check_win_ver
::Get windows version
set win_ver=0
setlocal
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
If %version% == 10.0 set win_ver=10
If %version% == 6.3 set win_ver=8.1
If %version% == 6.2 set win_ver=8
If %version% == 6.0 set win_ver=7
rem etc etc
endlocal
Goto check_win_arch
:check_win_arch
:: Get processor architecture
Set arch=0
If %PROCESSOR_ARCHITECTURE% == AMD64 set arch=0
If %PROCESSOR_ARCHITECTURE% == x86 set arch=32
If %arch% == 0 set error_reason="Unsupported architecture: %PROCESSOR_ARCHITECTURE%"
If %arch% == 0 goto ERROR
:: If your architecture isn't x86 or amd64, idk what is going on anymore
Goto  check_files
:check_files
set missing_files=0
If not exist ya5qr.7z set /a missing_files=%missing_files%+1
If not exist 7z.exe set /a missing_files=%missing_files%+1
If %missing_files% GTR 0 set error_reason="Missing %missing_files% setup files! Please make sure to download everything"
If %missing_files% GTR 0 goto ERROR
7z.exe e ya5qr.7z
If not %ERRORLEVEL% == 0 set error_reason="error executing extractor”
Goto ERROR
pause