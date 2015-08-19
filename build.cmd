pushd %~dp0%
set TEMPDIR=%~dp0%tempZIP
set _zipfilepath=%~dp0%Version\

echo Set objArgs = WScript.Arguments > _zipIt.vbs
attrib +h _zipIt.vbs
echo InputFolder = objArgs(0) >> _zipIt.vbs
echo ZipFile = objArgs(1) >> _zipIt.vbs
echo CreateObject("Scripting.FileSystemObject").CreateTextFile(ZipFile, True).Write "PK" ^& Chr(5) ^& Chr(6) ^& String(18, vbNullChar) >> _zipIt.vbs
echo Set objShell = CreateObject("Shell.Application") >> _zipIt.vbs
echo Set source = objShell.NameSpace(InputFolder).Items >> _zipIt.vbs
echo objShell.NameSpace(ZipFile).CopyHere(source) >> _zipIt.vbs
echo Do Until objShell.NameSpace(ZipFile).Items.Count = objShell.NameSpace(InputFolder).Items.Count >> _zipIt.vbs
echo wScript.Sleep 1000 >> _zipIt.vbs
echo Loop >> _zipIt.vbs

for %%h in (Windows, Linux32bit, Linux64bit, Mac) do (
	if exist Version\%%h.zip del Version\%%h.zip
	if not %ERRORLEVEL% equ 0 goto :err

	if exist %%h\release rd %%h\release\
	md %%h\release
	if not %ERRORLEVEL% equ 0 goto :err

	xcopy data\* %%h\release\data\* /y /e
	if not %ERRORLEVEL% equ 0 goto :err
	
	xcopy %%h\data\* %%h\release\data\* /y /e
	if not %ERRORLEVEL% equ 0 goto :err
	
	if exist %%h\app.exe copy /y %%h\app.exe %%h\release\app.exe
	if not %ERRORLEVEL% equ 0 goto :err
	
	if exist %%h\app.exe.config copy /y %%h\app.exe.config %%h\release\app.exe.config
	if not %ERRORLEVEL% equ 0 goto :err
	
	if exist %%h\app.sh copy /y %%h\app.sh %%h\release\app.sh
	if not %ERRORLEVEL% equ 0 goto :err

	copy /y %%h\app.ico %%h\release\app.ico
	if not %ERRORLEVEL% equ 0 goto :err
	
	if exist %%h\install.cmd (copy /y %%h\install.cmd %%h\release\install.cmd) else (copy /y %%h\install.sh %%h\release\install.sh)
	if not %ERRORLEVEL% equ 0 goto :err
	
	if exist %TEMPDIR% rd /s /q %TEMPDIR%
	md %TEMPDIR%
	attrib +h %TEMPDIR% /s /d
	xcopy %%h\release %TEMPDIR% /e /y

	CScript _zipIt.vbs %TEMPDIR% %_zipfilepath%%%h.zip
)

:end
del /a:h _zipIt.vbs
rd /s /q %TEMPDIR%
popd
pause
goto :eof

:err
cls
@echo off
echo an error has occurred in build
goto :end