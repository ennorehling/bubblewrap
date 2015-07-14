@ECHO OFF
SET GAME=bubbles

mkdir dist

REM create game.love
"c:\Program Files\7-Zip\7z.exe" a dist\%GAME%.love *.lua res\*.*

PAUSE

REM create windows exe
mkdir build
copy /b "c:\Program Files\LOVE\love.exe" + dist\%GAME%.love build\%GAME%.exe

REM build windows zip
"c:\Program Files\7-Zip\7z.exe" a dist\%GAME%.zip build\%GAME%.exe "c:\Program Files\LOVE\*.dll"

rd /s /q build

PAUSE
