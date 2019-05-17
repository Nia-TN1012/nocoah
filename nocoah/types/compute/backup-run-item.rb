require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Backup run item
            class BackupRunItem < Base

                # @return [String] Backup run ID
                attr_reader :backuprun_id
                # @return [DateTime] Created time
                attr_reader :created_at
                # @return [String] Status
                attr_reader :status
                # @return [String] Type
                attr_reader :type
                # @return [String] Volume ID
                # @note It is stored only when type is "volume". Otherwise it is nil.
                attr_reader :volume_id

                # Creates a new {BackupRunItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @backuprun_id = data['backuprun_id']
                    @created_at = DateTime.parse( data['created_at'] ) rescue nil
                    @status = data['status']
                    @type = data['type']
                    @volume_id = data['volume_id']
                end

            end

        end

    end

end