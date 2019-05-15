require 'date'
Dir["#{File.dirname( __FILE__ )}/common/*.rb"].each do | file |
    require file
end

# Nocoah
module Nocoah

    # Types
    module Types

        # Common
        module Common

            # Data integration method
            module RRDMode
                # Average
                AVERAGE = "average"
                # Max
                MAX = "max"
                # Min
                MIN = "min"
            end

            # Converts string representation of truth value to Boolean type.
            #
            # @param [Object]   val     String representation of truth value
            #
            # @note When specified in Boolean type, returns the value of val itself.
            #
            # @return [true]    val is "true" ( upper or lower case is irrelevant. )
            # @return [false]   otherwise 
            def self.to_b( val )
                return false if val.nil?
                return val if val.is_a?( TrueClass ) || val.is_a?( FalseClass )
                return false unless val.is_a?( String )
                
                val =~ /^true$/i ? true : false
            end

            # Gets whether it is Date, Time, or DateTime type.
            #
            # @param [Object]   val     Object to examine
            #
            # @return [true]    val is in Date, Time, or DateTime type
            # @return [false]   otherwise 
            def self.kind_of_date_or_time?( val )
                val.kind_of?( Date ) || val.kind_of?( Time )
            end

        end

    end

end