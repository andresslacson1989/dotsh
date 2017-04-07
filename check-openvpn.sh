if [[ "$(which openvpn)" != "" ]]; then
	if [[ "$(netstat -ltnup | grep openvpn)" != "" ]]; then
		echo "OpenVPN Running"
	else
		echo "OpenVPN Not Running"
	fi
else
	echo "OpenVPN Not Installed"
fi
