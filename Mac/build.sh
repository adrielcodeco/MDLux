pushd %~dp0%..\
if exist windows\release rd windows\release\
md windows\release
xcopy data\* windows\release\data\* /y /e
xcopy windows\data\* windows\release\data\* /y /e
copy /y windows\app.exe windows\release\app.exe
copy /y windows\app.exe.config windows\release\app.exe.config
copy /y windows\app.ico windows\release\app.ico
copy /y windows\install.cmd windows\release\install.cmd
popd
pause