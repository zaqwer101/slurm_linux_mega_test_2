#!/bin/bash
test $(sudo ps ax -o pid,ni,cmd | grep simple_process | grep -v "grep" | awk '{print $2}') -eq "-15" && STATUS11=Success
echo "1.1: $STATUS11"

[[ $(sudo cat /var/log/signal.log 2>/dev/null | tr "\n" ":") == '11:2:15:14:' ]] && STATUS12=Success
echo "1.2: $STATUS12"

TEST1="$(sudo cat /tmp/simple_process 2>/dev/null | tr -d "\n" | tr -d ' ')"; TEST2="$(sudo cat /proc/$(ps aux | grep simple_process | grep -v 'grep' | awk '{print $2}')/environ 2>/dev/null | strings | grep TEST | awk -F'=' '{print $2}' | tr -d '\n')"; [[ $TEST1 == $TEST2 && $TEST1 != "" ]] && STATUS13=Success
echo "1.3: $STATUS13"

sudo getfacl /opt/house 2>/dev/null | grep "user:tom:rwx" >/dev/null && getfacl /opt/house 2>/dev/null | grep "user:jerry:rwx" >/dev/null && getfacl /opt/house/room 2>/dev/null | grep "user:tom:rwx" >/dev/null && getfacl /opt/house/room 2>/dev/null | grep "user:jerry:rwx" >/dev/null && getfacl /opt/house/kitchen 2>/dev/null | grep "user:tom:rwx" >/dev/null && getfacl /opt/house/kitchen 2>/dev/null | grep "user:jerry:r-x" >/dev/null && getfacl /opt/house/kitchen/cheese 2>/dev/null | grep "user:jerry:r--" >/dev/null && getfacl /opt/house/kitchen/cheese 2>/dev/null | grep "user:tom:-w-" >/dev/null && STATUS21=Success
echo "2.1: $STATUS21"

sudo test ! -f /opt/file && STATUS22=Success
echo "2.2: $STATUS22"

[[ $(sudo su test -c "source /etc/profile && umask" 2>/dev/null) == "0077" ]] && STATUS23=Success
echo "2.3: $STATUS23"
