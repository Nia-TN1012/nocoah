require_relative '../base'

# Nocoah
module Nocoah

    # Types
    module Types

        # Network
        module Network

            # Security group rule
            class SecurityGroupRule < Base

                # @return [String] Security group rule ID
                attr_reader :security_group_rule_id
                # @return [String] Remote group ID ( Allows only traffic from the port linked to the specified security group ID )
                attr_reader :remote_group_id
                # @return [String (Nocoah::Types::Network::SecurityGroupRuleDirection)] Direction
                attr_reader :direction
                # @return [String] Remote IP prefix ( Allows only traffic from IP with specified prefix )
                attr_reader :remote_ip_prefix
                # @return [String (Nocoah::Types::Network::SecurityGroupRuleProtocol)] Protocol
                attr_reader :protocol
                # @return [String (Nocoah::Types::Network::SecurityGroupRuleEtherType)] Ether type
                attr_reader :ethertype
                # @return [String] Tenant ID
                attr_reader :tenant_id
                # @return [Integer] Maximum port range
                attr_reader :port_range_max
                # @return [Integer] Minimum port range
                attr_reader :port_range_min
                # @return [String] Security group ID
                attr_reader :security_group_id

                # Creates a new {SecurityGroupRule} class instance.
                #
                # @param [Hash] data    Data
                def initialize( data )
                    @security_group_rule_id = data['id']
                    @remote_group_id = data['remote_group_id']
                    @direction = data['direction']
                    @remote_ip_prefix = data['remote_ip_prefix']
                    @protocol = data['protocol']
                    @tenant_id = data['tenant_id']
                    @port_range_max = data['port_range_max']
                    @port_range_min = data['port_range_min']
                    @security_group_id = data['security_group_id']
                end

            end

            # Security group rule direction
            module SecurityGroupRuleDirection
                # @return [String] Outbound
                EGRESS = "egress"
                # @return [String] Inbound
                INGRESS = "ingress"
            end

            # Security group rule ether type
            module SecurityGroupRuleEtherType
                # @return [String] IPv4
                IPV4 = "IPv4"
                # @return [String] IPv6
                IPV6 = "IPv6"
            end

            # Security group rule protocol
            module SecurityGroupRuleProtocol
                # @return [String] TCP
                TCP = "tcp"
                # @return [String] UDP
                UDP = "udp"
                # @return [String] ICMP
                ICMP = "icmp"
                # @return [nil] NILL
                NULL = nil
            end

        end

    end

end