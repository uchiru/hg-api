require 'socket'
require 'net/http'

module HGAPI
  class Client
    SUPPORTED_TRANSPORTS = [:udp, :tcp, :http]
    HTTP_URI ="https://hostedgraphite.com/api/v1/sink"
    HOST = 'carbon.hostedgraphite.com'
    PORT = 2003

    attr_reader :disabled, :settings

    def initialize(options = {})
      @settings = build_settings(options)
      @disabled = @settings[:api_key].nil?
    end

    def metric(key, value, options = {})
      return if @disabled
      send_metric(key, value, check_transport!(options[:via]) || settings[:default_transport])
    end

    def time(key, options = {})
      start = Time.now
      result = yield
      metric(key, ((Time.now - start) * 1000).round, options)
      result
    end

    private

    def build_settings(options)
      {
        :api_key           => ENV["HOSTED_GRAPHITE_API_KEY"],
        :host              => ENV["HOSTED_GRAPHITE_HOST"] || HOST,
        :port              => ENV["HOSTED_GRAPHITE_PORT"] || PORT,
        :http_uri          => ENV["HOSTED_GRAPHITE_HTTP_URI"] || HTTP_URI,
        :default_transport => check_transport!(options[:via]) || :udp,
        :prefix            => options[:prefix]
      }
    end

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
      sock.send "#{@settings[:api_key]}.#{prefix}#{key} #{value}\n", 0, @settings[:host], @settings[:port]
      sock.close
    end

    def send_metric_tcp(key, value)
      conn = TCPSocket.new @settings[:host], @settings[:port]
      conn.puts "#{@settings[:api_key]}.#{prefix}#{key} #{value}\n"
      conn.close
    end

    def send_metric_http(key, value)
      uri = URI(@settings[:http_uri])

      req = Net::HTTP::Post.new(uri.request_uri)
      req.basic_auth @settings[:api_key], nil
      req.body = "#{prefix}#{key} #{value}"

      res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end
    end

    def prefix
      @prefix ||= if settings[:prefix] && !settings[:prefix].empty?
        Array(settings[:prefix]).join('.') << '.'
      else
        ""
      end
    end
  end
end
