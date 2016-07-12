#!/usr/bin/env ruby

require 'json'
require 'optparse'
require 'redis'
require 'oj'

options = {
  host: '127.0.0.1',
  port: 6380,
  channel: 'events',
  db: 0
}

optparse = OptionParser.new do |opts|
  opts.banner = <<eos
Usage: flapjack.rb [-h host] [-p port] [-d database] [-c channel]

Relay handler will immediately read Sensu Event Handler JSON and connect
to default server unless overridden by command line options.

eos

  opts.on("-h", "--host redisHost", "Redis Host") do |h|
    options[:host] = h
  end

  opts.on("-p", "--port redisPort", "Redis Port") do |p|
    options[:port] = p.to_i
  end

  opts.on("-d", "--database redisDatabase", "Redis Database") do |d|
    options[:db] = d.to_i
  end

  opts.on("-c", "--channel redisChannel", "Redis Channel") do |c|
    options[:channel] = c
  end
end

optparse.parse(ARGV)

if options[:host].nil? || options[:host] == ''
  puts "FATAL: You must specify a redis host (-h)."
  puts optparse.help
  exit
end

jsonInput = $stdin.read
event = JSON.parse(jsonInput)

redis = Redis.new(options)

SEVERITIES = ['ok', 'warning', 'critical', 'unknown']
client = event['client']
check = event['check']
tags = []

tags.concat(client['tags']) if client['tags'].is_a?(Array)
tags.concat(check['tags']) if check['tags'].is_a?(Array)
tags << client['environment'] unless client['environment'].nil?
unless check['subscribers'].nil? || check['subscribers'].empty? # rubocop:disable UnlessElse
  tags.concat(client['subscriptions'] - (client['subscriptions'] - check['subscribers']))
else
  tags.concat(client['subscriptions'])
end
details = ['Address:' + client['address']]
details << 'Tags:' + tags.join(',')
details << "Raw Output: #{check[:output]}" if check[:notification]

flapjack_event = {
  entity: client['name'],
  check: check['name'],
  type: 'service',
  state: SEVERITIES[check['status']] || 'unknown',
  summary: check['notification'] || check['output'],
  details: details.join(' '),
  time: check['executed'],
  tags: tags
}

redis.lpush(options[:channel], Oj.dump(flapjack_event, :mode => :compat, :time_format => :ruby, :indent => 0))
