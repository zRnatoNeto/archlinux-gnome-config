#!/bin/bash

# ${1} = Name
# ${2} = package-name
# ${3} = return_function
function install_package() {
	echo_message header "Starting 'install_package' function..."
	if [ $(check_package_installed ${2}) != 0 ]; then
		echo_message info "${2} is not installed. Installing..."
		if (whiptail \
			--title "Install ${1^}" \
			--yesno "Proceed with installation of ${1^}?" 8 56); then
			echo_message info "Installing package '${2}'..."
			superuser_do "pacman -S ${2}"
			echo_message success "Installation of package '${2}' is complete."
			whiptail --title "Finished" --msgbox "Installation of ${1} complete." 8 56
			${3}
		else
			echo_message info "Installation of ${1} cancelled."
			${3}
		fi
	else
		echo_message info "Package '${2}' is already installed."
		whiptail --title "Finished" --msgbox "Installation of ${1} is already complete." 8 56
		${3}
	fi
}

# ${1} = Name
# ${2} = list-name
# ${3} = return_function
function install_from_list() {
	echo_message title "Starting installation of ${1}..."
	LIST=$(dirname "$0")'/data/'${2}'.list'
	if (eval $(resize) && whiptail \
		--title "Install ${2^}" \
		--yesno "Current list of packages that will be installed: \n\n$(cat ${LIST}) \n\nWould you like to proceed?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext \
		3>&1 1>&2 2>&3); then
		for PACKAGE in $(cat $LIST); do
			if [ $(check_package_installed $PACKAGE) != 0 ]; then
				echo_message warning "Package '$PACKAGE' is not installed. Installing..."
				superuser_do "pacman -S $PACKAGE"
				if [[ $? != 0 ]]; then
					echo_message error "Error installing '$PACKAGE'."
				fi
			else
				echo_message info "Package '$PACKAGE' is installed."
			fi
		done
		echo_message success "Installation of ${1} complete."
		whiptail --title "Finished" --msgbox "Installation of ${1} is complete." 8 56
		${3}
	else
		echo_message info "Installation of ${1} cancelled."
		${3}
	fi
}

# ${1} = Name
# ${2} = list-name
# ${3} = return_function
function install_from_yaourt_list() {
	echo_message title "Starting installation of ${1}..."
	LIST=$(dirname "$0")'/data/'${2}'.list'
	if (eval $(resize) && whiptail \
		--title "Install ${2^}" \
		--yesno "Current list of packages that will be installed: \n\n$(cat ${LIST}) \n\nWould you like to proceed?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext \
		3>&1 1>&2 2>&3); then
		for PACKAGE in $(cat $LIST); do
			if [ $(check_package_installed $PACKAGE) != 0 ]; then
				echo_message warning "Package '$PACKAGE' is not installed. Installing..."
				superuser_do "yaourt -S $PACKAGE"
				if [[ $? != 0 ]]; then
					echo_message error "Error installing '$PACKAGE'."
				fi
			else
				echo_message info "Package '$PACKAGE' is installed."
			fi
		done
		echo_message success "Installation of ${1} complete."
		whiptail --title "Finished" --msgbox "Installation of ${1} is complete." 8 56
		${3}
	else
		echo_message info "Installation of ${1} cancelled."
		${3}
	fi
}

# ${1} = Name
# ${2} = package
# ${3} = return_function
function install_yaourt_package() {
	if [[ $(
		yaourt -Q | grep ${2} &>/dev/null
		echo $?
	) != 0 ]]; then
		echo_message info "${1} is not installed. Installing..."
		if (whiptail \
			--title "Install ${1}" \
			--yesno "The yaourt package for ${1} is not installed. \n\nProceed with installation of '${2}'?" 10 64); then
			echo_message info "Installing yaourt package '${2}'..."
			superuser_do "yaourt -S ${2}"
			echo_message success "Installation of '${2}' is complete."
			whiptail --title "Finished" --msgbox "Installation of ${1} is complete." 8 56
			${3}
		else
			echo_message info "Installation of ${1} cancelled."
			${3}
		fi
	else
		echo_message info "Yaourt package '${2}' is already installed."
		whiptail --title "Installed" --msgbox "${1} is already installed." 8 56
		${3}
	fi
}
