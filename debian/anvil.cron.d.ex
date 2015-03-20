#
# Regular cron jobs for the anvil package
#
0 4	* * *	root	[ -x /usr/bin/anvil_maintenance ] && /usr/bin/anvil_maintenance
