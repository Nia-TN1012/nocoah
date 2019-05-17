require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Common
        module Common

            # Link
            class Link < Base

                # @return [String] URL
                attr_reader :href
                # @return [String] Relation type
                attr_reader :rel
                
                # Creates a new {Link} class instance.
                #
                # @param [String] href      URL
                # @param [String] rel       Relation type
                #
                def initialize( href, rel )
                    @href = href
                    @rel = rel
                end

            end

        end

    end

end