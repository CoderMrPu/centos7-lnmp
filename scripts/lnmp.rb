class Lnmp
	def self.configure(config, settings)
		script_dir = File.dirname(__FILE__)
		    # determine if there is name specified
        	if settings.include? 'name'
        		# Configure Box
                config.vm.define settings['name']
                config.vm.box = 'centos7/lnmp'
                # config.vm.box_check_update = false
                config.vm.hostname = settings['name']

                # Configure VirtualBox
                config.vm.provider 'virtualbox' do |vb|
                	vb.name = settings['name']
                	vb.cpus = settings['cpus'] ||= '1'
                	vb.memory = settings['memory'] ||= '1024'
                	vb.gui = settings['gui'] ||= false
                end

                # Configure Networks
                settings['networks'].each do |network|
                	if network['type'] === 'private_network'
                		if network['ip'] != 'auto'
                			config.vm.network 'private_network', ip: network['ip']
                		else
                			config.vm.network 'private_network', ip: '0.0.0.0', auto_network: true
                		end
                	else
                		config.vm.network 'public_network', ip: network['ip'], bridge: network['bridge'] ||= nil, netmask: network['netmask'] ||= '255.255.255.0'
                	end
                end

                # Configure ports
                if settings.has_key?('ports')
                	settings['ports'].each do |port|
                		port['guest'] ||= port['to']
                		port['host'] ||= port['send']
                		port['protocol'] ||= 'tcp'
                	end
                else
                	settings['ports'] = []
                end
                if settings.has_key?('ports')
                	settings['ports'].each do |port|
                		config.vm.network 'forwarded_port', guest: port['guest'], host: port['host'], protocol: port['protocol'], auto_correct: true
                	end
                end

                # Configure The Public Key For SSH Access
                if settings.include? 'authorize'
                	if File.exist? File.expand_path(settings['authorize'])
                		config.vm.provision 'shell' do |s|
                			s.inline = "echo $1 | grep -xq \"$1\" /home/vagrant/.ssh/authorized_keys || echo \"\n$1\" | tee -a /home/vagrant/.ssh/authorized_keys"
                			s.args = [File.read(File.expand_path(settings['authorize']))]
                		end
                	end
                end

                # Copy The SSH Private Keys To The Box
                if settings.include? 'keys'
                	if settings['keys'].to_s.length.zero?
                		puts 'Check your Lnmp.yaml file, you have no private key(s) specified.'
                		exit
                	end
                	if File.exist? File.expand_path(settings['keys'])
                		config.vm.provision 'shell' do |s|
                			s.privileged = false
                			s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
                			s.args = [
                				File.read(File.expand_path(settings['keys'])),
                				settings['keys'].split('/').last
                			]
                		end
                	else
                		puts 'Check your Lnmp.yaml file, the path to your private key does not exist.'
                		exit
                	end
                end

                # Configured Shared Folders
                if settings.has_key?('folders')
                	settings['folders'].each do |folder|
                		# Judge path
                		if File.exist? File.expand_path(folder['map'])
                			mount_opts = []

                			if ENV['VAGRANT_DEFAULT_PROVIDER'] == 'hyperv'
                				folder['type'] = 'smb'
                			end

                			if folder['type'] == 'nfs'
                				mount_opts = folder['mount_options'] ? folder['mount_options'] : ['actimeo=1', 'nolock']
                			elsif folder['type'] == 'smb'
                				mount_opts = folder['mount_options'] ? folder['mount_options'] : ['vers=3.02', 'mfsymlinks']

                				smb_creds = {smb_host: folder['smb_host'], smb_username: folder['smb_username'], smb_password: folder['smb_password']}
                			end

                			# For b/w compatibility keep separate 'mount_opts', but merge with options
                			options = (folder['options'] || {}).merge({ mount_options: mount_opts }).merge(smb_creds || {})

                			# Double-splat (**) operator only works with symbol keys, so convert
                			options.keys.each{|k| options[k.to_sym] = options.delete(k) }

                			config.vm.synced_folder folder['map'], folder['to'], type: folder['type'] ||= nil, **options
                		else
                			puts 'Check your Lnmp.yaml file, the path to your folders map does not exist'
                			exit
                		end
                	end
                end

                if settings.include? 'sites'
                    # 清除nginx站点
                	config.vm.provision 'shell' do |s|
                        s.path = script_dir + '/clear-nginx.sh'
                    end

                    # Create any Homestead sites
                	settings['sites'].each do |site|
                		# Create sites
                        config.vm.provision 'shell' do |s|
                        	s.name = 'Creating Site: ' + site['map']
                        	s.path = script_dir + '/create-nginx.sh'
                        	s.args = [
                                site['map'],                # $1
                                site['to'],                 # $2
                            ]
                        end
                	end
                else
                	puts 'Check your Lnmp.yaml file, you have no sites specified'
                	exit
                end

                # create databases
                if settings.has_key?('databases')
                    settings['databases'].each do |db|
                        config.vm.provision 'shell' do |s|
                            s.name = 'Creating MySQL Database: ' + db
                            s.path = script_dir + '/create-mysql.sh'
                            s.args = [db]
                        end
                    end
                end
        	else
        		puts 'Check your Lnmp.yaml file, you have no name specified'
        		exit
        	end
	end
end