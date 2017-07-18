current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                '{{ chef_username }}'
client_key               "#{current_dir}/{{ chef_username }}.pem"
validation_client_name   '{{ chef_orgname }}-validator'
validation_key           "#{current_dir}/{{ chef_orgname }}-validator.pem"
chef_server_url          'https://chefserver.example.com/organizations/{{ chef_orgname }}'
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
