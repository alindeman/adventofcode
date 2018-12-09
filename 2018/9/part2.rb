#!/usr/bin/env ruby
require_relative "game"

if ARGV.length < 2
  puts "Usage: #{$0} PLAYERS LAST_MARBLE_VALUE"
  abort
end

players = ARGV[0].to_i
last_marble_value = ARGV[1].to_i * 100

game = Game.new
1.upto(last_marble_value).zip(1.upto(players).cycle) do |marble_value, player_id|
  game.play(player_id, marble_value)
end
puts game.scores.map { |k, v| v }.max
