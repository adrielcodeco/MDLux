set _ppath=%~dp0%
set _pname=mdlux
set _pext=md

reg add HKEY_CLASSES_ROOT\.%_pext% /f /d "%_pname%.%_pext%"
reg add HKEY_CLASSES_ROOT\.%_pext%\DefaultIcon /f /d %_ppath%app.ico
reg add HKEY_CLASSES_ROOT\.%_pext%\shell\open\command /f /d "%_ppath%app.exe \"%%1%%\""
reg add HKEY_CLASSES_ROOT\%_pname%.%_pext%\shell\open\command /f /d "%_ppath%app.exe \"%%1%%\""

reg add HKEY_CURRENT_USER\SOFTWARE\Classes\.%_pext% /f /d "%_pname%.%_pext%"
reg add HKEY_CURRENT_USER\SOFTWARE\Classes\.%_pext%\DefaultIcon /f /d %_ppath%app.ico
reg add HKEY_CURRENT_USER\SOFTWARE\Classes\.%_pext%\shell\open\command /f /d "%_ppath%app.exe \"%%1%%\""
reg add HKEY_CURRENT_USER\SOFTWARE\Classes\%_pname%.%_pext%\shell\open\command /f /d "%_ppath%app.exe \"%%1%%\""

reg add HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.%_pext% /f /d "%_pname%.%_pext%"
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.%_pext%\DefaultIcon /f /d %_ppath%app.ico
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.%_pext%\shell\open\command /f /d "%_ppath%app.exe \"%%1%%\""
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Classes\%_pname%.%_pext%\shell\open\command /f /d "%_ppath%app.exe \"%%1%%\""

@echo off
pushd %~dp0%

set _command=%_ppath%data\bin\node.exe --harmony %_ppath%data\app.js
set _search=^<value^>^</value^>

SETLOCAL=ENABLEDELAYEDEXPANSION

rename app.exe.config app.tmp

for /f "tokens=*" %%a in (app.tmp) do (
	set foo=%%a
	if "!foo!" equ "%_search%" set foo=^<value^>%_command%^</value^>
	echo !foo! >> app.exe.config
)

del app.tmp
popd
pause