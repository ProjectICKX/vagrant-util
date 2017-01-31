cd /d %~dp0

cd ..

echo # setup start : %date% %time%

vagrant up --provision-with init
vagrant halt
vagrant up
vagrant provision --provision-with setup

echo # setup end : %date% %time%

pause
