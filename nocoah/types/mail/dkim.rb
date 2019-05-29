require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Mail
        module Mail

            # DKIM ( DomainKeys Identified Mail )
            class DKIM < Base

                # @return [String] DKIM record name
                attr_reader :record_name
                # @return [String] DKIM record data
                attr_reader :record_data
                # @return [String] Status
                attr_reader :status

                # Creates a new {DKIM} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @record_name = data['record_name']
                    @record_data = data['record_data']
                    @status = data['status']
                end

            end
            
        end

    end

end