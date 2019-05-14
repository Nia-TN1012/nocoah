# Nocoah
module Nocoah

    # Represents an error in an API request.
    class APIError < StandardError

        attr_reader :http_code
        
        # Creates a new APIError instance, specifying a message and HTTP status code.
        #
        # @param [String]   message     Message
        # @param [Integer]  http_code   HTTP status code
        def initialize( message: nil, http_code: nil )
            message ||= "API Error"
            super( message )

            @http_code = http_code
        end

    end

end