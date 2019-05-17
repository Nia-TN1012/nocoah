require_relative './server-item'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Create virtual machine result
            class CreateServerResult < ServerItem

                # @return [String] Disk configuration
                attr_reader :disk_config
                # @return [Array<String>] Attached security groups
                attr_reader :security_groups
                # @return [String] Root password
                attr_reader :admin_password

                # Creates a new {CreateServerResult} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    super( data )

                    @disk_config = data['OS-DCF:diskConfig']
                    @security_groups = data['security_groups'].map { | sg | sg['name'] } rescue []
                    @admin_password = data['adminPass']
                end

            end

        end

    end

end