require 'json'

# Nocoah
module Nocoah

    # Manages configuration.
    class Config

        # @return [String] ConoHa API user
        attr_reader :api_user
        # @return [String] ConoHa API password
        attr_reader :api_pass
        # @return [String] Tenant ID
        attr_reader :tenant_id
        # @return [String] Region
        attr_reader :region

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
        #     }
        #   Enviornment variables (NOCOAH):
        #     ENV['NOCOAH_API_USER']:       "API username"
        #     ENV['NOCOAH_API_PASS']:       "API password"
        #     ENV['NOCOAH_TENANT_ID']:      "Tenant ID"
        #     ENV['NOCOAH_REGION']:         "Region (e.g. 'tyo1', 'sin1' or 'sjc1')"
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
            else
                if Config.load_config_from_env?( "NOCOAH" )
                    load_config_from_env( "NOCOAH" )
                elsif Config.load_config_from_env?( "CONOHA" )
                    load_config_from_env( "CONOHA" )
                elsif File.exist?( "#{Dir::home}/.nocoah/config" )
                    load_config_file( "#{Dir::home}/.nocoah/config" )
                elsif File.exist?( "#{Dir::home}/.conoha/config" )
                    load_config_file( "#{Dir::home}/.conoha/config" )
                else
                    raise "Cannot initialize #{Config.class.name}."
                end
            end
        end

        private

        # Loads config file.
        # 
        # @param [String] config_file_path   Config file path
        def load_config_file( config_file_path )
            json_data = open( config_file_path ) do | io |
                JSON.load( io )
            end

            @api_user = json_data['api_user']
            @api_pass = json_data['api_pass']
            @tenant_id = json_data['tenant_id']
            @region = json_data['region']
        end

        # Checks whether it is possible to be load from the environment variables consisting of the specified prefix.
        #
        # @param [String]   env_prefix      Environment variable prefix
        #
        # @return [true]     Can load
        # @return [false]    Cannot load
        def self.load_config_from_env?( env_prefix )
            ENV.key?( "#{env_prefix}_API_USER" ) && ENV.key?( "#{env_prefix}_API_PASS" ) && ENV.key?( "#{env_prefix}_TENANT_ID" ) && ENV.key?( "#{env_prefix}_REGION" )
        end

        # Loads from the environment variables consisting of the specified prefix.
        #
        # @param [String]   env_prefix      Environment variable prefix
        def load_config_from_env( env_prefix )
            @api_user = ENV["#{env_prefix}_API_USER"]
            @api_pass = ENV["#{env_prefix}_API_PASS"]
            @tenant_id = ENV["#{env_prefix}_TENANT_ID"]
            @region = ENV["#{env_prefix}_REGION"]
        end

    end

end