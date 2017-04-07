if [[ "$(which badvpn-udpgw)" != "" ]]; then
	if [[ "$(netstat -ltnup | grep badvpn-udpgw)" != "" ]]; then
		echo "BadVPN Running"
	else
		echo "BadVPN Not Running"
	fi
else
	echo "BadVPN Not Installed"
fi

