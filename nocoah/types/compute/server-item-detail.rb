require_relative './server-item'
require_relative './flavor-item'
require_relative './image-item'
require_relative './attached-volume-item'
require_relative './server-metadata'
require_relative './server-network-item'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Virtual machine detail
            class ServerItemDetail < ServerItem

                # @return [String] Server status
                attr_reader :status
                # @return [DateTime] Server updated
                attr_reader :updated
                # @return [String] Host ID
                attr_reader :hostId
                # @return [String] The name of the compute host on which this instance is running
                attr_reader :host
                # @return [Array<Nocoah::Types::Compute::ServerNetworkItem>] Addresses
                attr_reader :addresses
                # @return [String] Associated key pair name
                attr_reader :key_name
                # @return [Nocoah::Types::Compute::ImageItem] Used image
                # @note :image.name is nil
                attr_reader :image
                # @return [String] Instance task state
                attr_reader :task_state
                # @return [String] Virtual machine state
                attr_reader :vm_state
                # @return [String] Instance name
                attr_reader :instance_name
                # @return [DateTime] Server launched time 
                attr_reader :launched_at
                # @return [DateTime] Server deleted time 
                attr_reader :terminated_at
                # @return [String] Hypervisor host name
                attr_reader :hypervisor_hostname
                # @return [Nocoah::Types::Compute::FlavorItem] Used flavor
                # @note :flavor.name is nil
                attr_reader :flavor
                # @return [Array<String>] Attached security groups
                attr_reader :security_groups
                # @return [String] Availability zone name
                attr_reader :availability_zone
                # @return [String] User ID
                attr_reader :user_id
                # @return [DateTime] Server created time
                attr_reader :created
                # @return [String] Tenant ID
                attr_reader :tenant_id
                # @return [String] Disk configuration
                attr_reader :disk_config
                # @return [Nocoah::Types::Compute::AttachedVolume] Attached volumes
                attr_reader :attached_volumes
                # @return [String] IPv4 address that should be used to access this server
                attr_reader :access_IPv4
                # @return [String] IPv6 address that should be used to access this server
                attr_reader :access_IPv6
                # @return [Integer] A percentage value of the operation progress
                attr_reader :progress
                # @return [Integer] Power state
                attr_reader :power_state
                # @return [Boolean] Indicates whether or not a config drive was used for this server
                attr_reader :config_drive
                # @return [Nocoah::Types::Compute::ServerMetadata] Server metadata
                attr_reader :metadata

                def initialize( data )
                    super( data )

                    @status = data['status']
                    @updated = DateTime.parse( data['updated'] ) rescue nil
                    @hostId = data['hostId']
                    @host = data['OS-EXT-SRV-ATTR:host']
                    if data.key?( 'addresses' ) && data['addresses'].kind_of?( Hash )
                        @addresses = data['addresses'].map do | label, ips |
                            ServerNetworkItem.new( label, ips )
                        end
                    else
                        @addresses = []
                    end
                    @key_name = data['key_name']
                    @image = data['image'].nil? ? nil : ImageItem.new( data['image'] )
                    @task_state = data['OS-EXT-STS:task_state']
                    @vm_state = data['OS-EXT-STS:vm_state']
                    @instance_name = data['OS-EXT-SRV-ATTR:instance_name']
                    @launched_at = DateTime.parse( data['OS-SRV-USG:launched_at'] ) rescue nil
                    @terminated_at = DateTime.parse( data['OS-SRV-USG:terminated_at'] ) rescue nil
                    @hypervisor_hostname = data['OS-EXT-SRV-ATTR:hypervisor_hostname']
                    @flavor = data['flavor'] ? nil : FlavorItem.new( data['flavor'] )
                    if data.key/( 'security_groups' )
                        security_groups = data['security_groups'].map do | sg |
                            sg['name']
                        end
                    else
                        @security_groups = []
                    end
                    @availability_zone = data['OS-EXT-AZ:availability_zone']
                    @user_id = data['user_id']
                    @created = DateTime.parse( data['created'] ) rescue nil
                    @tenant_id = data['tenant_id']
                    @disk_config = data['OS-DCF:diskConfig']
                    @attached_volumes = data['os-extended-volumes'] ? nil : AttachedVolumeItem.new( data['os-extended-volumes'] )
                    @access_IPv4 = data['accessIPv4']
                    @access_IPv6 = data['accessIPv6']
                    @progress = data['progress']
                    @power_state = data['OS-EXT-STS:power_state']
                    @config_drive = Common.to_b( data['config_drive'] )
                    @metadata = data['metadata'].nil? ? nil : ServerMetadata.new( data['metadata'] )
                end

                def to_s
                    {
                        'Server ID' => @server_id,
                        'Server name' => @name,
                        'Links' => @links.map { | link | link.to_s },
                        'Status' => @status,
                        'Created' => @created,
                        'Updated' => @updated,
                        'User ID' => @user_id,
                        'Tenant ID' => @tenant_id,
                        'Flavor' => @flavor.to_s,
                        'Image' => @image.to_s,
                        'Key name' => @key_name,
                        'Host ID' => @hostId,
                        'Addresses' => @addresses.map { | address | address.to_s },
                        'Security goups' => @security_groups.map { | sg | sg.to_s },
                        'Availability zone' => @availability_zone,
                        'Host' => @host,
                        'Hypervisor hostname' => @hypervisor_hostname,
                        'Instance name' => @instance_name,
                        'Launched' => @launched_at,
                        'Terminated' => @terminated_at,
                        'Task state' => @task_state,
                        'VM state' => @vm_state,
                        'Power state' => @power_state,
                        'Disk config' => @disk_config,
                        'Attached volumes' => @attached_volumes.to_s,
                        'Access IPv4' => @access_IPv4,
                        'Access IPv6' => @access_IPv6,
                        'Metadata' => @metadata.to_s
                    }.to_s
                end

            end

        end

    end

end