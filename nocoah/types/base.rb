# Nocoah
module Nocoah

    # Types
    module Types

        # Base
        class Base

            # Converts the instance variables to a string.
            #
            # @return [String]
            def to_s
                self.to_h.to_s
            end

            # Converts the instance variables to a hash.
            #
            # @return [Hash]
            def to_h
                hash = {}
                self.instance_variables.map do | i_var |
                    val = self.instance_variable_get( i_var )
                    if val.kind_of?( Array )
                        hash[i_var.to_s.delete( "@" )] = val.map { | v | v.kind_of?( Base ) ? v.to_h : v }
                    else
                        hash[i_var.to_s.delete( "@" )] = val.kind_of?( Base ) ? val.to_h : val
                    end
                end
                hash
            end

        end

    end

end