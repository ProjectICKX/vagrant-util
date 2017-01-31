cd /d %~dp0

cd ..

start vagrant destroy web
start vagrant destroy api
start vagrant destroy db

exit
