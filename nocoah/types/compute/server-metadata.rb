require 'json'
require_relative '../common'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Server metadata
            class ServerMetadata

                # @return [Boolean] Whether the deletion prevention lock is enabled
                attr_reader :isDeleteLocked
                # @return [String] Backup ID
                attr_reader :backup_id
                # @return [String] Backup status
                attr_reader :backup_status
                # @return [Integer] Number of backup sets
                attr_reader :backup_set
                # @return [Boolean] Whether the virtual machine is locked
                attr_reader :vmlock
                # @return [String] Virtual machine name tag
                attr_reader :instance_name_tag
                # @return [Hash] Properties
                attr_reader :properties

                def initialize( data )
                    @isDeleteLocked = Common.to_b( data['IsDeleteLocked'] )
                    @backup_id = data['backup_id']
                    @backup_status = data['backup_status']
                    @backup_set = data['backup_set']
                    @vmlock = Common.to_b( data['vmlock'] )
                    @instance_name_tag = data['instance_name_tag']
                    @properties = JSON.parse( data['properties'] ) rescue nil
                end

                def to_s
                    {
                        'Delete lock' => @isDeleteLocked,
                        'Backup ID' => @backup_id,
                        'Backup status' => @backup_status,
                        'Backup set' => @backup_set,
                        'VM locked' => @vmlock,
                        'Name tag' => @instance_name_tag,
                        'Properties' => @properties,
                    }.to_s
                end

            end

        end

    end

end