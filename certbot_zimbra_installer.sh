#!/usr/bin/env bash
## Author: Michael Ramsey
## Objective Install certbot_zimbra on server in an automated universal fashion.
## https://github.com/whattheserver/certbot-zimbra
## How to use.
## ./certbot_zimbra_installer.sh 
## Or inline via curl/wget from latest master
## link='https://github.com/YetOpen/certbot-zimbra/raw/master/certbot_zimbra_installer.sh'; bash <(curl -s ${link} || wget -qO - ${link})
##
##

if [ "${DEBUG}" == 'True' ] || [ "${DEBUG}" == 1 ]; then
      export PS4='+ ${BASH_SOURCE##*/}:${LINENO} '
  set -x
fi

set -euo pipefail

# version="0.1"
#
# This is an optional arguments-only example of Argbash potential
# ARG_OPTIONAL_BOOLEAN([install],[i],[Install certbot_zimbra (and implicit default: on)])
# ARG_OPTIONAL_BOOLEAN([upgrade],[u],[Upgrade certbot_zimbra],[off])
# ARG_OPTIONAL_BOOLEAN([remove],[r],[Remove certbot_zimbra],[off])
# ARG_VERSION([echo test v$version])
# ARG_HELP([Install/Update/Remove certbot_zimbra.sh script from server ])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.9.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='iurvh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_install="on"
_arg_upgrade="off"
_arg_remove="off"


print_help()
{
	printf '%s\n' "Install/Update/Remove certbot_zimbra.sh script from server "
	printf 'Usage: %s [-i|--(no-)install] [-u|--(no-)upgrade] [-r|--(no-)remove] [-v|--version] [-h|--help]\n' "$0"
	printf '\t%s\n' "-i, --install, --no-install: Install certbot_zimbra (and implicit default: on) (on by default)"
	printf '\t%s\n' "-u, --upgrade, --no-upgrade: Upgrade certbot_zimbra (off by default)"
	printf '\t%s\n' "-r, --remove, --no-remove: Remove certbot_zimbra (off by default)"
	printf '\t%s\n' "-v, --version: Prints version"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-i|--no-install|--install)
				_arg_install="on"
				test "${1:0:5}" = "--no-" && _arg_install="off"
				;;
			-i*)
				_arg_install="on"
				_next="${_key##-i}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-i" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-u|--no-upgrade|--upgrade)
				_arg_upgrade="on"
				test "${1:0:5}" = "--no-" && _arg_upgrade="off"
				;;
			-u*)
				_arg_upgrade="on"
				_next="${_key##-u}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-u" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-r|--no-remove|--remove)
				_arg_remove="on"
				test "${1:0:5}" = "--no-" && _arg_remove="off"
				;;
			-r*)
				_arg_remove="on"
				_next="${_key##-r}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-r" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-v|--version)
				echo test v$version
				exit 0
				;;
			-v*)
				echo test v$version
				exit 0
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

parse_commandline "$@"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


# vvv  PLACE YOUR CODE HERE  vvv

SUPPORTED_OS_ARRAY=("Red Hat Enterprise Linux 6" "CentOS 6" "Oracle Linux 6" "Red Hat Enterprise Linux 7" "CentOS 7" "Oracle Linux 7" "Red Hat Enterprise Linux 8" "CentOS 8" "Oracle Linux 8" "Ubuntu 14.04 LTS" "Ubuntu 16.04 LTS" "Ubuntu 18.04 LTS")
SUPPORTED_OS=$(printf "%s, " "${SUPPORTED_OS_ARRAY[@]}")

Check_OS(){
	if [[ ! -f /etc/os-release ]] ; then
	echo -e "Unable to detect the operating system...\n"
	exit
	fi
}

Check_Server_OS(){
	# Reference: https://unix.stackexchange.com/questions/116539/how-to-detect-the-desktop-environment-in-a-bash-script
	if [ -z "$XDG_CURRENT_DESKTOP" ]; then
		echo -e "Desktop OS not detected. Proceeding\n"
	else
		echo "$XDG_CURRENT_DESKTOP defined appears to be a desktop OS. Bailing as Zimbra is incompatible."
		echo -e "\nZimbra is supported on server OS types only. Such as ${SUPPORTED_OS}.\nSee : https://www.zimbra.org/download/zimbra-collaboration"
		exit
	fi
}

Check_Arch(){
	if ! uname -m | grep -q 64 ; then
	echo -e "x64 system is required...\n"
	exit
	fi
}

Detect_Distro(){
	if grep -q -E "CentOS Linux 6|CentOS Linux 7|CentOS Linux 8" /etc/os-release ; then
	Server_OS="CentOS"
	elif grep -q "AlmaLinux-8" /etc/os-release ; then
	Server_OS="AlmaLinux"
	elif grep -q -E "Red Hat Enterprise Linux 6|Red Hat Enterprise Linux 7|Red Hat Enterprise Linux 8|Oracle Linux 6|Oracle Linux 7|Oracle Linux 8" /etc/os-release ; then
	Server_OS="RHEL"
	elif grep -q -E "Ubuntu 14.04|Ubuntu 16.04|Ubuntu 18.04" /etc/os-release ; then
	Server_OS="Ubuntu"
	elif grep -q -E "Rocky Linux" /etc/os-release ; then
	Server_OS="RockyLinux"
	else
	echo -e "Unable to detect your system..."
	echo -e "\nZimbra is only supported on ${SUPPORTED_OS}.\nSee : https://www.zimbra.org/download/zimbra-collaboration"
	exit
	fi

	if [[ $Server_OS = "RHEL" ]] || [[ "$Server_OS" = "AlmaLinux" ]] || [[ "$Server_OS" = "RockyLinux" ]] ; then
	Server_OS="CentOS"
	#CloudLinux gives version id like 7.8 , 7.9 , so cut it to show first number only
	#treat CL , Rocky and Alma as CentOS
	fi

	Server_OS_Version=$(grep VERSION_ID /etc/os-release | awk -F[=,] '{print $2}' | tr -d \" | head -c2 | tr -d . )
	#to make 20.04 display as 20

}


Install_LetsEncrypt(){
	echo 'Installing certbot for OS'
	if [[ "$Server_OS" = "CentOS" ]] ; then
		if [[ "$Server_OS_Version" = "7" ]] ; then
			yum install -y certbot
		elif [[ "$Server_OS_Version" = "8" ]] ; then
			dnf install -y certbot
		fi
	else
	DEBIAN_FRONTEND=noninteractive apt upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

	# Certbot requirements
	DEBIAN_FRONTEND=noninteractive apt install software-properties-common -y
	DEBIAN_FRONTEND=noninteractive add-apt-repository universe -y
	DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:certbot/certbot -y
	DEBIAN_FRONTEND=noninteractive apt update -y
	DEBIAN_FRONTEND=noninteractive apt install certbot -y

	fi
}

INSTALL_CERTBOT_ZIMBRA(){
	echo 'Installling certbot-zimbra to /usr/local/bin/certbot'
	wget -O /usr/local/bin/certbot_zimbra.sh https://github.com/YetOpen/certbot-zimbra/raw/master/certbot_zimbra.sh;
	chmod +x /usr/local/bin/certbot_zimbra.sh;
	echo 'Installling crontab file for automated renewals to /etc/cron.d/zimbracrontab'
	wget -O /etc/cron.d/zimbracrontab https://github.com/YetOpen/certbot-zimbra/raw/masterzimbracrontab;
	chmod +x /etc/cron.d/zimbracrontab

	echo 'Disabling automatically created Certbot cron schedules and systemd timers from renewing certificates.'
	sed -i '/certbot -q renew/s/^/#/g' /etc/cron.d/certbot
	systemctl stop certbot.timer && systemctl disable certbot.timer
	echo 'Installation complete..'
	echo 'Starting certbot-auto bootstrap:'
	certbot-auto
	echo 'Running installed certbot_zimbra initialization script. See details here: https://github.com/YetOpen/certbot-zimbra#first-run and walk through first run as advised.'
	/usr/local/bin/certbot_zimbra.sh -n -c
}

UPDATE_CERTBOT_ZIMBRA(){
	echo 'Updating certbot-zimbra in /usr/local/bin/certbot'
	wget -O /usr/local/bin/certbot_zimbra.sh https://github.com/YetOpen/certbot-zimbra/raw/master/certbot_zimbra.sh;
	chmod +x /usr/local/bin/certbot_zimbra.sh;

	echo 'Disabling automatically created Certbot cron schedules and systemd timers from renewing certificates.'
	sed -i '/certbot -q renew/s/^/#/g' /etc/cron.d/certbot
	systemctl stop certbot.timer && systemctl disable certbot.timer
	echo 'Update complete..'
	echo 
	echo 'Running installed certbot_zimbra initialization script. See details here: https://github.com/YetOpen/certbot-zimbra#first-run and walk through first run as advised.'
	/usr/local/bin/certbot_zimbra.sh -n -c
}


UNINSTALL_CERTBOT_ZIMBRA(){
	echo 'Uninstallling certbot-zimbra from /usr/local/bin/certbot'
	rm -f /usr/local/bin/certbot_zimbra.sh
	echo 'Uninstallling crontab file for automated renewals from /etc/cron.d/zimbracrontab'
	rm -f /etc/cron.d/zimbracrontab

	echo 'Setting Certbot cron schedules back to default'
	sed -i '/certbot -q renew/s/^#//g' /etc/cron.d/certbot
	systemctl enable certbot.timer && systemctl start certbot.timer
	echo 'Uninstall complete..'
}



if [[ "$_arg_install" = "on" ]] ; then
	Check_OS
	Check_Server_OS
	Check_Arch
	Detect_Distro
	Install_LetsEncrypt
	if Install_LetsEncrypt ; then
		INSTALL_CERTBOT_ZIMBRA
	fi
	
fi

if [[ "$_arg_upgrade" = "on" ]] ; then
	UPDATE_CERTBOT_ZIMBRA
fi

if [[ "$_arg_remove" = "on" ]] ; then
	UNINSTALL_CERTBOT_ZIMBRA
fi


exit 0
# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash