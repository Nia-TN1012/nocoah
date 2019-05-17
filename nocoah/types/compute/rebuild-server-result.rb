require 'date'
require_relative '../../utility'
require_relative './server-item'
require_relative './flavor-item'
require_relative './image-item'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Rebuild virtual machine result
            class RebuildServerResult < ServerItem

                # @return [String] Server status
                attr_reader :status
                # @return [DateTime] Server updated
                attr_reader :updated
                # @return [String] Host ID
                attr_reader :host_id
                # @return [Array<Nocoah::Types::Compute::ServerNetworkItem>] Addresses
                attr_reader :addresses
                # @return [Nocoah::Types::Compute::ImageItem] Used image
                # @note :image.name is nil
                attr_reader :image
                # @return [Nocoah::Types::Compute::FlavorItem] Used flavor
                # @note :flavor.name is nil
                attr_reader :flavor
                # @return [String] User ID
                attr_reader :user_id
                # @return [DateTime] Server created time
                attr_reader :created
                # @return [String] Tenant ID
                attr_reader :tenant_id
                # @return [String] Disk configuration
                attr_reader :disk_config
                # @return [String] IPv4 address that should be used to access this server
                attr_reader :access_ipv4
                # @return [String] IPv6 address that should be used to access this server
                attr_reader :access_ipv6
                # @return [Integer] A percentage value of the operation progress
                attr_reader :progress
                # @return [Hash] Server metadata
                attr_reader :metadata
                # @return [String] Root password
                attr_reader :admin_password

                # Creates a new {RebuildServerResult} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    super( data )

                    @status = data['status']
                    @updated = DateTime.parse( data['updated'] ) rescue nil
                    @host_id = data['hostId']
                    @addresses = data['addresses'].map { | label, ips | ServerNetworkItem.new( label, ips ) } rescue []
                    @image = ImageItem.new( data['image'] ) rescue nil
                    @flavor = FlavorItem.new( data['flavor'] ) rescue nil
                    @user_id = data['user_id']
                    @created = DateTime.parse( data['created'] ) rescue nil
                    @tenant_id = data['tenant_id']
                    @disk_config = data['OS-DCF:diskConfig']
                    @access_ipv4 = data['accessIPv4']
                    @access_ipv6 = data['accessIPv6']
                    @progress = data['progress']
                    @config_drive = Utility.to_b( data['config_drive'] )
                    @admin_password = data['adminPass']
                end

            end

        end

    end

end