#
## Cookbook Name :: nagios-cookbook
#


# Install some RPM package needed to build and compile the nagios source
['gcc', 'glibc', 'glibc-common', 'gd', 'gd-devel', 'make', 'net-snmp', 'openssl-devel', 'xinetd', 'unzip', 'nodejs', 'npm'].each do |pkg|
	package pkg do 
		action :install
	end
end

# Create nagios user
user 'nagios' do
	comment "A nagios user"
	shell '/bin/bash'
end

# Create nagios group
group 'nagios' do
	action :create
	members ['nagios', 'apache']
end

# Download the nagios source
remote_file '/tmp/nagios-4.3.2.tar.gz' do
	source 'https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.3.2.tar.gz'
	action :create_if_missing
end

# Build and compile the source code

unless Dir.exists?('/tmp/nagios-4.3.2')

	execute 'Extract the nagios-4.3.2.tar.gz' do
		cwd '/tmp'
		command 'tar -xvzf nagios-4.3.2.tar.gz'
		action :run
	end
	
	execute 'Before builing, configure it' do
		cwd '/tmp/nagios-4.3.2'
		command './configure --with-command-group=nagios'
		action :run
	end

	execute 'compile it' do
		cwd '/tmp/nagios-4.3.2'
		command 'make all'
		action :run
	end
	execute 'Install nagios' do
		cwd '/tmp/nagios-4.3.2'
		user 'root'
		command 'make install && make install-commandmode'
	end
 
	execute 'Install init script' do
		cwd '/tmp/nagios-4.3.2'
		user 'root'
		command 'make install-init'
	end
 
	execute 'Install configs' do
		cwd '/tmp/nagios-4.3.2'
		user 'root'
		command 'make install-config && make install-webconf'
	end
 
end
