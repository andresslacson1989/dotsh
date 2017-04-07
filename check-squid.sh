if [[ "$(which squid3)" != "" ]]; then
	if [[ "$(netstat -ltnup | grep squid3)" ]]; then
		echo "Squid Running"
	else
		echo "Squid Not Running"
	fi
else
	echo "Squid Not Installed"
fi
