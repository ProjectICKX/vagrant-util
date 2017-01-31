cd /d %~dp0

start vagrant halt db
start vagrant halt api
start vagrant halt web

exit
