# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Fixed IP address
            class FixedIPAddress

                # @return [String] IP address
                attr_reader :ip_address
                # @return [String] Subnet ID
                attr_reader :subnet_id

                def initialize( data )
                    @ip_address = data['ip_address']
                    @subnet_id = data['subnet_id']
                end

                def to_s
                    {
                        'IP address' => @ip_address,
                        'Subnet ID' => @subnet_id,
                    }.to_s
                end

            end

        end

    end

end