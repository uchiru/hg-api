require "hg_api/version"
require "hg_api/client"

# Usage example:
#  client = HGAPI.new
#  client.metric("signup", 1)
#  client.metric("load", 100, via: :tcp)
#
# Default transport is udp, it can be changed by passing options hash while
# constructing client:
#
#  client = HGAPI.new(via: :http)
#  client.metric("this.metric.send.over.http", 5)
#
# Supported transports: udp, tcp, http.
#
# API KEY must be present as environmental variable HOSTED_GRAPHITE_API_KEY.

module HGAPI
  def self.version
    HGAPI::VERSION
  end

  def self.new options = {}
    Client.new options
  end
end
