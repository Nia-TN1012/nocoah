require_relative '../errors'
require_relative '../config'
require_relative '../identity'

# Nocoah
module Nocoah

    # Client
    module Client

        # Base
        class Base

            # API Endpoint ( '%s' contains a string representing the region. (e.q. 'tyo1', 'sin1' or 'sjc1') )
            ENDPOINT_BASE = "https://identity.%s.conoha.io/v2.0"

            # Initializes a new Base instance.
            #
            # @param          [Hash]                options             Options
            # @option options [ConoHa::Identity]    :identity           The ConoHa::Identity instance.
            # @option options [ConoHa::Config]      :config             The ConoHa::Config instance.
            # @option options [String]              :config_file_path   The JSON file path that describes the credential configuration information of ConoHa API account
            # @option options [Hash]                :api_account        The hash object that stores ConoHa API user, password, tenant ID, and region.
            #
            # @note
            #   Priority:
            #     1. :identity ( when specified )
            #     2. :config ( when specified )
            #     3. :config_file_path ( when specified )
            #     4. :api_account ( when specified )
            #     5. Environment variables ( 'NOCOAH_...' )
            #     6. Environment variables ( 'CONOHA_...' )
            #     7. Loads from '~/.nocoah/config'
            #     8. Loads from '~/.conoha/config'
            # 
            # @see Nocoah::Config
            def initialize( **options )
                if options.key?( :identity ) && options[:identity].instance_of?( Nocoah::Identity )
                    @identity = options[:identity]
                else
                    @identity = Nocoah::Identity.new( options )
                end
                
                @endpoint = sprintf( self.class::ENDPOINT_BASE, @identity.config.region )
            end

            # Get API version info.
            #
            # @return [Hash]                When succeeded, API version info.
            # @raise [Nocoah::APIError]     When failed.
            def version
                headers = {
                    Accept: "application/json",
                    'X-Auth-Token': @identity.api_token,
                }
                http_client = HTTPClient.new;
                res = http_client.get( @endpoint, header: headers )
                raise APIError, message: "Failed to get version info.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST
        
                json_data = JSON.parse( res.body )
            end

        end

    end

end