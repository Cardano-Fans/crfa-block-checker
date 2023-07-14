require_relative "../block_checker"

bc = BlockChecker.new

puts %Q(\n
EPOCH #{bc.epoch_no} SUMMARY
----------------------
#{bc.summary_output}
)

puts %Q(\n
FUTURE MINTS
----------------------
#{bc.future_mints.map do |slot, slot_time|
  "- Block on slot #{slot} at #{slot_time}"
end.join("\n")}
) if bc.future_mints.any?

puts %Q(\n
LOST SLOT BATTLES
----------------------
#{bc.lost_slot_battles.map do |slot, extra|
  "- Block minted on slot #{slot} by pool #{extra[0]} at #{extra[1]}"
end.join("\n")}
) if bc.lost_slot_battles.any?

puts %Q(\n
LOST HEIGHT BATTLES
----------------------
#{bc.lost_height_battles_output}
) if bc.lost_height_battles.any?

puts %Q(\n
UNKNOWN BLOCK STATUS
----------------------
#{bc.unknown_block_status_output}
) if bc.unknown_block_status.any?

puts %Q(\n
PERFORMANCE STATS
----------------------
)
if bc.epoch_running?
  puts "Epoch #{bc.epoch_no} is still running. The following statistics include only the already past slots!"
end

bc.performance.each do |perf, value|
  puts "#{perf.to_s.gsub!(/_/, ' ').gsub(/^\w/) { $&.upcase }}: #{value}%"
end

puts %Q(\n
DEVELOPED BY
----------------------
#{bc.contributers.map do |ticker, url|
  [ticker, url].join(" ")
end.join("\n")}
)