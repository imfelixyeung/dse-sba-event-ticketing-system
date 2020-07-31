@echo off
cd .\server\;
fpc @fpc.cfg lib/main.pas -oserver-win.exe;
.\lib\main.exe;
cd ..;