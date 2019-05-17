require_relative '../base'
require_relative '../common'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Attached volume item
            class AttachedVolumeItem < Base

                # @return [String] Attachment ID
                attr_reader :attachment_id
                # @return [String] Host name
                attr_reader :host_name
                # @return [String] Volume device
                attr_reader :device
                # @return [String] Attached server ID
                attr_reader :server_id
                # @return [String] Attached volume ID
                attr_reader :volume_id

                # Creates a new {AttachedVolumeItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @attachment_id = data['id']
                    @host_name = data['host_name']
                    @device = data['device']
                    @server_id = data['serverId']
                    @volume_id = data['volumeId']
                end

            end

        end

    end

end