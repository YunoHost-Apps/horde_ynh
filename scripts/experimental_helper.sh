 
# Delete a file checksum from the app settings
#
# $app should be defined when calling this helper
#
# usage: ynh_remove_file_checksum file
# | arg: file - The file for which the checksum will be deleted
ynh_delete_file_checksum () {
	local checksum_setting_name=checksum_${1//[\/ ]/_}	# Replace all '/' and ' ' by '_'
	ynh_app_setting_delete $app $checksum_setting_name
}

# Use logrotate to manage the logfile
#
# usage: ynh_use_logrotate [logfile] [--non-append|--append] [specific_user/specific_group]
# | arg: logfile - absolute path of logfile
# | arg: --non-append - (Option) Replace the config file instead of appending this new config.
# | arg: specific_user : run logrotate as the specified user and group. If not specified logrotate is runned as root.
#
# If no argument provided, a standard directory will be use. /var/log/${app}
# You can provide a path with the directory only or with the logfile.
# /parentdir/logdir
# /parentdir/logdir/logfile.log
#
# It's possible to use this helper several times, each config will be added to the same logrotate config file.
# Unless you use the option --non-append
ynh_use_logrotate () {
	local customtee="tee -a"
	local user_group="${3:-}"
	if [ $# -gt 0 ] && [ "$1" == "--non-append" ]; then
		customtee="tee"
		# Destroy this argument for the next command.
		shift
	elif [ $# -gt 1 ] && [ "$2" == "--non-append" ]; then
		customtee="tee"
	fi
	if [ $# -gt 0 ]; then
		if [ "$(echo ${1##*.})" == "log" ]; then	# Keep only the extension to check if it's a logfile
			local logfile=$1	# In this case, focus logrotate on the logfile
		else
			local logfile=$1/*.log	# Else, uses the directory and all logfile into it.
		fi
	else
		local logfile="/var/log/${app}/*.log" # Without argument, use a defaut directory in /var/log
	fi
	local su_directive=""
	if [[ -n $user_group ]]; then
		su_directive="	# Run logorotate as specific user - group
	su ${user_group#*/} ${user_group%/*}"
	fi

	cat > ./${app}-logrotate << EOF	# Build a config file for logrotate
$logfile {
		# Rotate if the logfile exceeds 100Mo
	size 100M
		# Keep 12 old log maximum
	rotate 12
		# Compress the logs with gzip
	compress
		# Compress the log at the next cycle. So keep always 2 non compressed logs
	delaycompress
		# Copy and truncate the log to allow to continue write on it. Instead of move the log.
	copytruncate
		# Do not do an error if the log is missing
	missingok
		# Not rotate if the log is empty
	notifempty
		# Keep old logs in the same dir
	noolddir
	$su_directive
}
EOF
	sudo mkdir -p $(dirname "$logfile")	# Create the log directory, if not exist
	cat ${app}-logrotate | sudo $customtee /etc/logrotate.d/$app > /dev/null	# Append this config to the existing config file, or replace the whole config file (depending on $customtee)
}