cd /d %~dp0

vagrant up db
vagrant up api
vagrant up web

cmd /k

exit
