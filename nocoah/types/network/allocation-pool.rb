require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Network
        module Network

            # Allocation pool
            class AllocationPool < Base

                # @return [String] Start IP
                attr_reader :start
                # @return [String] End IP
                attr_reader :end

                # Creates a new {AllocationPool} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @start = data['start']
                    @end = data['end']
                end

            end

        end

    end

end