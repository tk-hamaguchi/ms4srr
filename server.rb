# frozen_string_literal: true

require 'socket'
require 'stringio'
require 'net/http'
require 'logger'

require 'redis'
require 'active_support'
require 'active_support/core_ext'

$stdout = IO.new(IO.sysopen('/proc/1/fd/1', 'w'), 'w')
$stdout.sync = true

logger = Logger.new($stdout)

logger.level = 0

print <<~BANNER
  #======================================================#
  #  Start Mock Server for Save Request to Redis : 8080  #
  #======================================================#
BANNER

gs = TCPServer.open(8080)
addr = gs.addr
addr.shift

def timestamp
  Time.now.strftime('%Y%m%d%H%M%S.%N')
end

loop do
  Thread.start(gs.accept) do |s|
    sio = StringIO.new
    req = nil
    version = nil

    while s.gets
      line = $_
      sio.write line

      case line.strip
      when /^([A-Z]+)\s+(\/\S*)\s+HTTP\/(\d+(?:\.\d+))?$/
        method  = $1
        path    = $2
        version = $3

        req = Net::HTTP.const_get(method.underscore.camelize.to_sym).new(path)
      when /^([Hh][Oo][Ss][Tt]):\s(\S+)$/
        host = $2
        req[$1] = host
      when /^(\S+):\s+(\S+)$/
        req[$1] = $2
      when ''
        break unless req.content_length.to_i.positive?

        body = s.read req.content_length.to_i
        sio.write body
        req.body = body
        break
      end
    end

    redis = Redis.new
    if req.key?('X-Request-Id')
      redis.multi do
        redis.hset 'by-id', req['X-Request-Id'], sio.string
        redis.expire('by-id', 60 * 60)
      end
      logger.info "Receive request #{req['X-Request-Id']}"
    end
    redis.multi do
      redis.hset 'by-timestamp', timestamp, sio.string
      redis.expire('by-timestamp', 60 * 60)
    end
    redis.disconnect!

    s.write "HTTP/#{version} 200 OK\r\n"
    s.write "Content-Type: text/plain; charset=utf-8\r\n"
    s.write "Connection: close\r\n"
    s.write "X-Request-Id: #{req['X-Request-Id']}\r\n" if req.key?('X-Request-Id')
    s.write "Content-Length: 2\r\n"
    s.write "\r\n"
    s.write 'OK'
    s.close
  end
end
