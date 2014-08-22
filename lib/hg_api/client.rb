require 'socket'
require 'net/http'

module HGAPI
  class Client
    SUPPORTED_TRANSPORTS = [:udp, :tcp, :http]
    HTTP_URI ="https://hostedgraphite.com/api/v1/sink"
    HOST = 'carbon.hostedgraphite.com'
    PORT = 2003

    def initialize(options = {})
      @default_transport = check_transport!(options[:via]) || :udp
      @api_key = ENV["HOSTED_GRAPHITE_API_KEY"]
      @disabled = @api_key.nil?
    end

    def metric(key, value, options = {})
      return if @disabled
      send_metric(key, value, check_transport!(options[:via]) || @default_transport)
    end

    private

    def check_transport!(transport)
      if transport && !SUPPORTED_TRANSPORTS.include?(transport.to_sym)
        raise "#{transport} is unsupported transport"
      end
      transport
    end

    def send_metric(key, value, transport)
      self.send("send_metric_#{transport}", key, value)
    end

    def send_metric_udp(key, value)
      sock = UDPSocket.new
      sock.send "#{@api_key}.#{key} #{value}\n", 0, HOST, PORT
      sock.close
    end

    def send_metric_tcp(key, value)
      conn = TCPSocket.new HOST, PORT
      conn.puts "#{@api_key}.#{key} #{value}\n"
      conn.close
    end

    def send_metric_http(key, value)
      uri = URI(HTTP_URI)

      req = Net::HTTP::Post.new(uri.request_uri)
      req.basic_auth @api_key, nil
      req.body = "#{key} #{value}"

      res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end
    end
  end
end
