# Nocoah
module Nocoah

    # Types
    module Types

        # Common
        module Common

            # Link
            class Link

                # @return [String] URL
                attr_reader :href
                # @return [String] Relation type
                attr_reader :rel
                
                def initialize( href, rel )
                    @href = href
                    @rel = rel
                end

                def to_s
                    "#{href} (rel: #{rel})"
                end

            end

        end

    end

end