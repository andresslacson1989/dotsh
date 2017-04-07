if [[ "$(which sshd)" != "" ]]; then
	if [[ "$(netstat -ltnup | grep sshd)" != "" ]]; then
		echo "OpenSSH Running"
	else
		echo "OpenSSH Not Running"
	fi
else
	echo "OpenSSH Not Installed"
fi
