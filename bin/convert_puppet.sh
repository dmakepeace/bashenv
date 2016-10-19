#!/bin/bash
# convert_puppet.sh - converts puppet from a ruby gem to puppetlabs repo
# Only applies to conversions done on CentOS boxes.
# Arguements: NONE

GEM=`which gem`
GEM=${GEM:=`locate *bin/gem|grep rubies`}
RVM=`which rvm 2>/dev/null`
RVM=${RVM:=/usr/local/rvm/bin/rvm}
PUPPET_RPM="puppet-3.8.1"
PUPPET_PID_FILE="/var/run/puppet/agent.pid"
FOUND_GEM=$($GEM list puppet |grep puppet |wc -l)
FOUND_RPM=$(/bin/rpm -q $PUPPET_RPM|grep -v "not installed" |wc -l)

function puppet_status() {
# Puppet service status command. 0 = Running; 3 = Stopped
	/sbin/service puppet status > /dev/null 2>&1
	echo $?
}
function puppet_stop() {
# Stop puppet service and any potential stray left-over processes
	/sbin/service puppet stop 
	if [ $? -ne 0 ]; then
		echo "Problem stopping puppet service. Killing manually and removing PID file."
		/bin/kill -6 $(cat $PUPPET_PID_FILE)
		/bin/rm -f $PUPPET_PID_FILE
	fi

	# Check for stray puppet processes still running and kill if they exist
	if [ $(pidof puppet|wc -w) -ge 1 ]; then
		echo "Found stray puppet processes still running. Killing those process ID's"
		/bin/kill -6 $(pidof puppet)
	fi	
}
function puppet_gem_running()  {
# Is puppet running as a gem. 0 = Yes; 1 = No
	/bin/ps -ef |grep puppet |grep rubies |grep -v grep > /dev/null 2>&1
	echo $?
}
function remove_puppet_gem() {
# Remove puppet gem and deps, perform rvm cleanup
	if [ $FOUND_RPM -eq 0 ]; then
		echo "Removing puppet gem files that clash with rpm package"
		/bin/rm -f /usr/bin/puppet /etc/init.d/puppet /etc/puppet.sh
	fi

	echo "Uninstalling puppet gem and depedencies..."
	$GEM uninstall -x puppet facter hiera ruby-shadow

	# Check to see we have the now required GPG sign key for rvm (mpapis). If not, get it
	/usr/bin/gpg --list-keys mpapis > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		#Download/Import GPG signature key for rvm updates.
		echo "Missing GPG key for RVM updates. Importing from trusted source."
		/usr/bin/curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
	fi

	echo "Cleaning up RVM and retrieving latest stable RVM version."
	$RVM cleanup all && $RVM get stable && rvm reload
}
function puppetlabs_repo_check() {
# Check for presence of puppetlabs repo. If not found, install it.
	if [ ! -f /etc/yum.repos.d/puppetlabs.repo ]
	then
		echo "PuppetLabs Repo not installed. Installing now..."
		/bin/rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
		return $?
	fi
	return 0
}
function install_puppet() {
# Install puppet from pupptelabs repo via yum
	puppetlabs_repo_check
	if [ $? -ne 0 ]; then
		echo "Problem installing puppetlabs yum repo. Unable to continue!"
		exit 4
	fi

	echo "Installing puppet, facter, and ruby-shadow from puppetlabs"
	/usr/bin/yum install -y $PUPPET_RPM facter ruby-shadow
	if [ $? -ne 0 ]; then
		echo "Failed to sucessfully install puppet and dependicies. ABORTING!"
		exit 5
	fi

	# Ensure puppet is enabled on boot
	echo "Enabling puppet to start on boot"
	/sbin/chkconfig puppet on

	# Check we have the correct puppet.conf file
	/bin/grep splay /etc/puppet/puppet.conf > /dev/null
	if [ $? -eq 0 ]; then
		echo "Confirmed we have the correct puppet.conf file."
	else
		echo "Incorrect puppet.conf configuration. Pulling from puppet's file-server"
		/bin/cp -fv /home/puppet/puppet/dist/apps/puppet/init_scripts/puppet.init /etc/puppet/puppet.conf
	fi

	echo "Starting puppet service..."
	/sbin/service puppet start
	RET=$?
	# Return status code
	[ $RET -eq 0 ] && return 0 || return $RET
}
function run_puppet_agent() {
# Run puppet agent once and check return code for validity.
	echo "Running puppet agent once (DRY-RUN) to validate it is working... "
	/usr/bin/puppet agent -t --noop
	RET=$?
	if [ $RET -eq 0 ]; then
	        echo "Puppet agent test SUCCESSFUL!"
	        exit 0
	else
	        echo "Puppet agent test FAILED! Exitting with puppet agent return code = $RET"
	        exit $RET
	fi
}


# BEGIN MAIN
# Must be root to run
[ `id -u` -ne 0 ] && echo "Must be root to run" && exit 255

# Ensure this is a CentOS system
if [ ! -f /etc/centos-release  ]; then
	echo "Not CentOS. Exitting."
	exit 1
fi

# Export root env. Needed for running as sudo.
if [ -f /root/.bashrc ]; then
	source /root/.bashrc
fi

# Ensure current puppet is running and/or from ruby gem
echo -n "Checking current state of puppet... "
status=$(puppet_status)
if [ $status -eq 0 ]; then
	echo "Running"
	if [ $(puppet_gem_running) -eq 0 ]; then
		echo "Detected Puppet running as gem. Stopping and performing removal."
		puppet_stop
		remove_puppet_gem
		install_puppet
		RET=$?
		if [ $RET -ne 0 ]; then
			echo "Failed to start the puppet daemon. Please inspect output to see what went wrong."
			exit 7
		fi
		echo "Puppet Successfully Installed from PuppetLabs Repo and Started."
		run_puppet_agent
	else
		echo "Puppet running but not from ruby gem. Performing additional checks..."
		# Perform additional checks like see if puppet gem is installed or puppet-3.8.1 rpm package installed.
		
		# Check for Puppet Gem. Call removal if found
		if [ $FOUND_GEM -eq 1 ]; then
			echo "Found Puppet Gem Installed. Removing gem."
			remove_puppet_gem
		fi
		
		# Check for presence of puppet-3.8.1 RPM. Install if not found.
		if [ $FOUND_RPM -eq 0 ]; then
			echo "RPM Package $PUPPET_RPM not installed. Installing..."
			puppet_stop
			install_puppet
			RET=$?
                	if [ $RET -ne 0 ]; then
                        	echo "Failed to start the puppet daemon. Please inspect output to see what went wrong."
                        	exit 7
	                fi 
			echo "Puppet Successfully Installed from PuppetLabs Repo and Started."
			run_puppet_agent
		else
			echo "RPM Package $PUPPET_RPM already installed."
			
			# Check we have the correct puppet.conf file
		        /bin/grep splay /etc/puppet/puppet.conf > /dev/null
		        if [ $? -eq 0 ]; then
		                echo "Confirmed we have the correct puppet.conf file. Everything looks good."
				echo "DONE!"
		        else
		                echo "Incorrect puppet.conf configuration. Pulling from puppet's file-server and reloading"
                		/bin/cp -fv /home/puppet/puppet/dist/apps/puppet/init_scripts/puppet.init /etc/puppet/puppet.conf
				/sbin/service puppet reload
				echo "DONE!"
				run_puppet_agent
		        fi
		fi
	fi
elif [ $status -eq 3 ]; then 
	echo "Stopped"
	# Check for Puppet Gem. Call removal if found
	if [ $FOUND_GEM -eq 1 ]; then
		echo "Found Puppet Gem Installed. Removing gem."
		remove_puppet_gem
	fi

	# Check for presence of puppet-3.8.1 RPM. Install if not found.
	if [ $FOUND_RPM -eq 0 ]; then
		echo "RPM Package $PUPPET_RPM not installed. Installing..."
		install_puppet
		RET=$?
		if [ $RET -ne 0 ]; then
			echo "Failed to start the puppet daemon. Please inspect output to see what went wrong."
			exit 7
		fi
		echo "Puppet Successfully Installed from PuppetLabs Repo and Started."
		run_puppet_agent
	else
		echo "RPM Package $PUPPET_RPM already installed."
                        
		# Check we have the correct puppet.conf file
		/bin/grep splay /etc/puppet/puppet.conf > /dev/null
		if [ $? -eq 0 ]; then
			echo "Confirmed we have the correct puppet.conf file. Everything looks good."
			echo "DONE!"
		else
			echo "Incorrect puppet.conf configuration. Pulling from puppet's file-server and reloading"
			/bin/cp -fv /home/puppet/puppet/dist/apps/puppet/init_scripts/puppet.init /etc/puppet/puppet.conf
			/sbin/service puppet start
			echo "DONE!"
			run_puppet_agent
		fi
	fi
else 
	echo "Unknown. Exitting with status = $status" && exit $status
fi
