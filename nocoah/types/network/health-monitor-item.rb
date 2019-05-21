require_relative '../base'
require_relative './associated-pool-item'

# Nocoah
module Nocoah

    # Types
    module Types

        # Network
        module Network

            # Loadbalancer health monitor item
            class HealthMonitorItem < Base

                # @return [String] Health monitor ID
                attr_reader :health_monitor_id
                # @return [String] Tenant ID
                attr_reader :tenant_id
                # @return [Integer] Delay
                attr_reader :delay
                # @return [Integer] Max retries
                attr_reader :max_retries
                # @return [Integer] Timeout
                attr_reader :timeout
                # @return [Array<Nocoah::Types::Network::AssociatedPoolItem>] Pools
                attr_reader :pools
                # @return [Boolean] Administrative state of the network
                attr_reader :admin_state_up
                # @return [String (Nocoah::Types::Network::HealthMonitorType)] Health monitor type
                attr_reader :type
                # @return [String] URL path
                attr_reader :url_path
                # @return [String] Expected codes
                attr_reader :expected_codes
                # @return [String] HTTP method
                attr_reader :http_method

                # Creates a new {HealthMonitorItem} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @health_monitor_id = data['id']
                    @tenant_id = data['tenant_id']
                    @delay = data['delay']
                    @max_retries = data['max_retries']
                    @timeout = data['timeout']
                    @pools = data['pools'].map { | pool | AssociatedPoolItem.new( pool ) } rescue []
                    @admin_state_up = Utility.to_b( data['admin_state_up'] )
                    @type = data['type']
                    @url_path = data['url_path']
                    @expected_codes = data['expected_codes']
                    @http_method = data['http_method']
                end
                
            end

            # Health monitor type
            module HealthMonitorType
                # Ping: Sends a ping to the members and checks the response.
                PING = "PING"
                # TCP: Polls TCP to the members and checks the response.
                TCP = "TCP"
                # HTTP: Sends a HTTP request to the members and checks the response.
                HTTP = "HTTP"
            end

        end

    end

end