require_relative './backup-run-item'

# Nocoah
module Nocoah

    # Types
    module Types

        # Compute
        module Compute

            # Backup item
            class BackupItem

                # @return [String] Backup ID
                attr_reader :backup_id
                # @return [String] Instance ID
                attr_reader :instance_id
                # @return [Array<Nocoah::Types::Compute::BackupRunItem>] Backup runs
                attr_reader :backupruns

                def initialize( data )
                    @backup_id = data['id']
                    @instance_id = data['instance_id']
                    if data.key?( 'backupruns' )
                        @backupruns = data['backupruns'].map do | backuprun |
                            BackupRunItem.new( backuprun )
                        end
                    else
                        @backupruns = []
                    end
                end

                def to_s
                    {
                        'Backup ID' => @backup_id,
                        'Instance ID' => @instance_id,
                        'Backup runs' => @backupruns.map { | backuprun | backuprun.to_s },
                    }.to_s
                end

            end

        end

    end

end