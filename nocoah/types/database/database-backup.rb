require 'date'
require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Database
        module Database

            # Database backup
            class Backup < Base

                # @return [String] Backup ID
                attr_reader :backup_id
                # @return [String] Backup name
                attr_reader :backup_name
                # @return [DataTime] Created time
                attr_reader :create_date

                # Creates a new {Backup} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @backup_id = data['backup_id']
                    @backup_name = data['backup_name']
                    @create_date = DateTime.parse( data['create_date'] ) rescue nil
                end

            end
            
        end

    end

end