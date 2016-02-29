#!/usr/bin/env crystal

require "option_parser"
require "../http-mock"
require "http"

listen_host = "0.0.0.0"
listen_port = 8080
feeder = Feeder::Always200.new
verbose = false

parser = OptionParser.new.tap do |opts|
  opts.banner = "Usage: http-mock [OPTIONS]"
  opts.on("--host NAME", "Specify listen host name (default: '0.0.0.0')") do |name|
    listen_host = name
  end
  opts.on("-p NUM", "--port NUM", "Specify listen port number (default: 8080)") do |num|
    listen_port = num.to_i
  end
  opts.on("-f FILE", "--feeder FILE", "Specify feeder file") do |file|
    feeder = Feeder::Response.new(file)
  end
  opts.on("-v", "--verbose", "Show verbose log") do
    verbose = true
  end
  opts.on("-h", "--help", "Show help") do
    puts opts
    exit 1
  end
end

parser.parse(ARGV)

handlers = Handler::Group.new(
  [
    Handler::Feeder.new(feeder),
    Handler::Counter.new(1.second),
  ]
)

at_exit {
  handlers.stop
  STDOUT.flush
  STDERR.flush
  sleep 0.1
}
Signal::INT.trap { exit }

handlers.start

server = HTTP::Server.new(listen_host, listen_port) do |context|
  handlers.handle(context)
end

puts "Start Http Server on #{listen_host}:#{listen_port}"
server.listen
