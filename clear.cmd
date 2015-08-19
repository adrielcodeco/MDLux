pushd %~dp0%
if exist windows\release rd /s /q windows\release
if exist Linux32bit\release rd /s /q Linux32bit\release
if exist Linux64bit\release rd /s /q Linux64bit\release
if exist Mac\release rd /s /q Mac\release
popd
pause