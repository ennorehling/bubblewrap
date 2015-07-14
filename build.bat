@ECHO OFF
SET GAME=bubbles

cd c:\users\enno\Documents\Love\%GAME%
rd /s /q dist
rd /s /q build

mkdir dist

REM create game.love
"c:\Program Files\7-Zip\7z.exe" a dist\%GAME%.love *.lua res\*.*

REM create windows exe
mkdir build
copy /b "c:\Program Files\LOVE\love.exe"+dist\%GAME%.love build\%GAME%.exe
copy "c:\Program Files\LOVE\*.dll" build\
copy "c:\Program Files\LOVE\license.txt" build\

REM build windows zip
cd build
"c:\Program Files\7-Zip\7z.exe" a ..\dist\%GAME%.zip %GAME%.exe *.dll
cd ..
REM rd /s /q build

dir dist\*.*
copy dist\*.* C:\Users\Enno\Dropbox\LOVE\

PAUSE
