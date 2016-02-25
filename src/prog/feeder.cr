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

stats = {} of Int32 => Int32
at_exit {
  puts ""
  puts "total: #{stats.values.sum}"
  stats.keys.sort.each do |code|
    puts "#{code}: #{stats[code]}"
  end
  STDOUT.flush
}
Signal::INT.trap { exit }

server = HTTP::Server.new(listen_host, listen_port) do |context|
  feed = feeder.feed
  stats[feed.code] ||= 0
  stats[feed.code] += 1
  if verbose
    p feed
  end
  context.response.headers["Content-Type"] = feed.type
  context.response.status_code = feed.code
  context.response.print(feed.body)
end

puts "Start Http Server on #{listen_host}:#{listen_port}"
server.listen
