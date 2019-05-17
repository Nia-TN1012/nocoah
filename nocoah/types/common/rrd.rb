require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Common
        module Common

            # Round robin database
            class RRD < Base

                # @return [String] Name
                attr_reader :name
                # @return [Array<String>] Schema
                attr_reader :schema
                # @return [Array<Array<Integer>>] Data
                attr_reader :data

                # Creates a new {RRD} class instance.
                #
                # @param [String]   name        RRD name
                # @param [Hash]     data        Hash data
                def initialize( name, data )
                    @name = name
                    @schema = data['schema']
                    @data = data['data']
                end
                
            end

        end

    end

end