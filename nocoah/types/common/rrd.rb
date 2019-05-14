# Nocoah
module Nocoah

    # Types
    module Types

        # Common
        module Common

            # Round robin database
            class RRD

                # @return [String] Name
                attr_reader :name
                # @return [Array<String>] Schema
                attr_reader :schema
                # @return [Array<Array<Integer>>] Data
                attr_reader :data

                def initialize( name, data )
                    @name = name
                    @schema = data['schema']
                    @data = data['data']
                end

                def to_s
                    {
                        'Name' => @name,
                        'Schema' => @schema,
                        'Data' => @data
                    }.to_s
                end
                
            end

        end

    end

end