require 'httpclient'
require 'json'
require 'date'
require_relative './errors'
require_relative './endpoints'

# Nocoah
module Nocoah

    # Manages configuration and API token.
    class Identity

        # @return [String] API user
        attr_reader :api_user
        # @return [String] Tenant ID
        attr_reader :tenant_id
        # @return [String] Region
        attr_reader :region
        # @return [String] Public Cloud key
        attr_reader :public_cloud_key
        # @return [String] API endpoints
        attr_reader :api_endpoints
        # @return [String] Identity API endpoint
        attr_reader :endpoint
        # @return [String] API token
        attr_reader :api_token

        # Initializes a new Config instance.
        #
        # @param          [Hash]            options             Options
        # @option options [String]          :config_file_path   The JSON file path that describes the credential configuration information of ConoHa API account
        # @option options [Hash]            :api_account        The hash object that stores ConoHa API user, password, tenant ID, and region.
        #
        # @note
        #   Priority:
        #     1. :config_file_path ( when specified )
        #     2. :api_account ( when specified )
        #     3. Environment variables ( 'NOCOAH_...' )
        #     4. Environment variables ( 'CONOHA_...' )
        #     5. Loads from '~/.nocoah/config'
        #     6. Loads from '~/.conoha/config'
        #   
        #   Configuration file format, api_account hash format:
        #     {
        #        "api_user": "API username",
        #        "api_pass": "API password",
        #        "tenant_id": "Tenant ID",
        #        "region": "Region (e.g. 'tyo1', 'sin1' or 'sjc1')"
        #        "public_cloud": "Public cloud (e.g. 'ConoHa')"
        #     }
        #   Enviornment variables (NOCOAH):
        #     ENV['NOCOAH_API_USER']:       "API username"
        #     ENV['NOCOAH_API_PASS']:       "API password"
        #     ENV['NOCOAH_TENANT_ID']:      "Tenant ID"
        #     ENV['NOCOAH_REGION']:         "Region (e.g. 'tyo1', 'sin1' or 'sjc1')"
        #     ENV['NOCOAH_PUBLIC_CLOUD']:   "Public cloud (e.g. 'ConoHa')"
        #   Enviornment variables (CONOHA):
        #     ENV['CONOHA_API_USER']:       "API username"
        #     ENV['CONOHA_API_PASS']:       "API password"
        #     ENV['CONOHA_TENANT_ID']:      "Tenant ID"
        #     ENV['CONOHA_REGION']:         "Region (e.g. 'tyo1', 'sin1' or 'sjc1')"
        def initialize( **options )
            if options.key?( :config_file_path )
                load_config_file( options[:config_file_path] )
            elsif options.key?( :api_account )
                @api_user = options[:api_account][:api_user]
                @api_pass = options[:api_account][:api_pass]
                @tenant_id = options[:api_account][:tenant_id]
                @region = options[:api_account][:region]
                @public_cloud_key = Endpoints.get_public_cloud_key( options[:api_account][:public_cloud] )
                @api_endpoints = Endpoints.get_endpoints( @public_cloud_key )
            else
                if Identity.load_config_from_env?( "NOCOAH" )
                    load_config_from_env( "NOCOAH" )
                elsif Identity.load_config_from_env?( "CONOHA" )
                    load_config_from_env( "CONOHA" )
                elsif File.exist?( "#{Dir::home}/.nocoah/config" )
                    load_config_file( "#{Dir::home}/.nocoah/config" )
                elsif File.exist?( "#{Dir::home}/.conoha/config" )
                    load_config_file( "#{Dir::home}/.conoha/config", Endpoints::PublicCloudKey::CONOHA )
                else
                    raise "Cannot initialize #{Identity.class.name}."
                end
            end

            if @api_endpoints.nil?
                raise "Cannot initialize #{Identity.class.name}."
            end

            @endpoint = sprintf( @api_endpoints[:identity], @region )

            get_token
        end

        # Gets Identity API version info.
        #
        # @return [Hash]                When succeeded, API verion info.
        # @raise [Nocoah::APIError]     When failed.
        #
        # @see https://www.conoha.jp/docs/identity-get_version_detail.html
        def version
            headers = {
                Accept: "application/json",
            }
            http_client = HTTPClient.new;
            res = http_client.get( @endpoint, header: headers )

            raise APIError, message: "Failed to get version info.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST

            json_data = JSON.parse( res.body )
        end

        # Gets a ConoHa API token.
        #
        # @raise [Nocoah::APIError]     When failed.
        #
        # @see https://www.conoha.jp/docs/identity-post_tokens.html
        def get_token
            headers = {
                Accept: "application/json",
            }
            body = {
                auth: {
                    passwordCredentials: {
                        username: @api_user,
                        password: @api_pass,
                    },
                    tenantId: @tenant_id,
                }
            }
            http_client = HTTPClient.new;
            res = http_client.post( "#{@endpoint}/tokens", header: headers, body: body.to_json )
            raise APIError, message: "Failed to get Access Token.", http_code: res.status if res.status >= HTTP::Status::BAD_REQUEST

            json_data = JSON.parse( res.body )

            @api_token = json_data['access']['token']['id']
            @api_token_expire_date = DateTime.parse( json_data['access']['token']['expires'] )
        end

        # Gets whether API token is available.
        #
        # @return [true]    Available
        # @return [false]   Expired
        def token_available?
            DateTime.now <= @api_token_expire_date
        end

        private

        # Loads the config file.
        # 
        # @param [String] config_file_path   Config file path
        def load_config_file( config_file_path, default_public_cloud: nil )
            json_data = open( config_file_path ) do | io |
                JSON.load( io )
            end

            @api_user = json_data['api_user']
            @api_pass = json_data['api_pass']
            @tenant_id = json_data['tenant_id']
            @region = json_data['region']
            if default_public_cloud.nil? && !json_data['public_cloud'].nil?
                @public_cloud_key = Endpoints.get_public_cloud_key( json_data['public_cloud'] )
            else
                @public_cloud_key = default_public_cloud
            end
            @api_endpoints = Endpoints.get_endpoints( @public_cloud_key )
        end

        # Checks whether it is possible to be load from the environment variables consisting of the specified prefix.
        #
        # @param [String]   env_prefix      Environment variable prefix
        #
        # @return [true]     Can load
        # @return [false]    Cannot load
        def self.load_config_from_env?( env_prefix )
            if env_prefix == "NOCOAH"
                ENV.key?( "#{env_prefix}_API_USER" ) && ENV.key?( "#{env_prefix}_API_PASS" ) && ENV.key?( "#{env_prefix}_TENANT_ID" ) && ENV.key?( "#{env_prefix}_REGION" ) && ENV.key?( "#{env_prefix}_PUBLIC_CLOUD" )
            else
                ENV.key?( "#{env_prefix}_API_USER" ) && ENV.key?( "#{env_prefix}_API_PASS" ) && ENV.key?( "#{env_prefix}_TENANT_ID" ) && ENV.key?( "#{env_prefix}_REGION" )
            end
        end

        # Loads from the environment variables consisting of the specified prefix.
        #
        # @param [String]   env_prefix      Environment variable prefix
        def load_config_from_env( env_prefix )
            @api_user = ENV["#{env_prefix}_API_USER"]
            @api_pass = ENV["#{env_prefix}_API_PASS"]
            @tenant_id = ENV["#{env_prefix}_TENANT_ID"]
            @region = ENV["#{env_prefix}_REGION"]
            case env_prefix
            when "CONOHA"
                @public_cloud_key = Endpoints::PublicCloudKey::CONOHA
            else
                @public_cloud_key = Endpoints.get_public_cloud_key( ENV["#{env_prefix}_PUBLIC_CLOUD"] )
            end
            @api_endpoints = Endpoints.get_endpoints( @public_cloud_key )
        end

    end

end