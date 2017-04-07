if [[ "$(which dropbear)" != "" ]]; then
	if [[ "$(netstat -natp | grep dropbear)" != "" ]]; then
		echo "Dropbear Running"
	else
		echo "Dropbear Not Running"
	fi
else
	echo "Dropbear Not Installed"
fi
