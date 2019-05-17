require_relative './backup-run-item'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Backup item
            class BackupItem < Base

                # @return [String] Backup ID
                attr_reader :backup_id
                # @return [String] Instance ID
                attr_reader :instance_id
                # @return [Array<Nocoah::Types::Compute::BackupRunItem>] Backup runs
                attr_reader :backupruns

                # Creates a new {BackupItem} class instance.
                #
                # @param [Hash] data    Hash data
                def initialize( data )
                    @backup_id = data['id']
                    @instance_id = data['instance_id']
                    @backupruns = data['backupruns'].map { | backuprun | BackupRunItem.new( backuprun ) } rescue []
                end

            end

        end

    end

end