@ECHO OFF
SET GAME=bubblewrap

cd c:\users\enno\Documents\Love\%GAME%
rd /s /q dist
rd /s /q build

mkdir dist

REM create game.love
copy "c:\Program Files\LOVE\license.txt" .
"c:\Program Files\7-Zip\7z.exe" a -tzip dist\%GAME%.love *.lua res license.txt
pause
REM create windows exe
mkdir build
cd build
copy "c:\Program Files\LOVE\love.exe" .
copy ..\dist\%GAME%.love .
copy /b love.exe+%GAME%.love %GAME%.exe
copy "c:\Program Files\LOVE\*.dll" .
"c:\Program Files\7-Zip\7z.exe" a -tzip ..\dist\%GAME%.zip %GAME%.exe *.dll
cd ..
REM rd /s /q build

copy dist\*.* C:\Users\Enno\Dropbox\LOVE\

PAUSE
