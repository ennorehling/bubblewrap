@ECHO OFF
SET GAME=bubbles
rd /s /q dist
del /s /q %GAME%.zip
"c:\Program Files\7-Zip\7z.exe" a %GAME%.zip conf.lua main.lua console.lua audiomgr.lua bubbles.png pop.wav
mkdir dist
copy /b "c:\Program Files\LOVE\love.exe"+%GAME%.zip dist\%GAME%.exe
del %GAME%.zip
copy "c:\Program Files\LOVE\*.dll" dist
cd dist
"c:\Program Files\7-Zip\7z.exe" a %GAME%.zip %GAME%.exe *.dll
