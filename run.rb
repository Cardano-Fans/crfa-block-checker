require_relative "block_checker"

bc = BlockChecker.new

if bc.assigned_slots_count < 1
  puts "No slots allocated for epoch #{bc.epoch_no}"
  exit 0
end

puts %Q(
EPOCH #{bc.epoch_no} SUMMARY
----------------------
Assigned slots to mint blocks: #{bc.assigned_slots_count.to_s}
Minted blocks: #{bc.minted_blocks.size.to_s}
Lost height battles: #{bc.lost_height_battles.size}
Lost slot battles: #{bc.lost_slot_battles.size}
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
#{bc.lost_height_battles.map do |slot, slot_time|
   "- Block ghosted on slot #{slot} at #{slot_time}"
end.join("\n")}
) if bc.lost_height_battles.any?

puts %Q(\n
UNKNOWN BLOCK STATUS
----------------------
#{bc.unknown_block_status.map do |slot, slot_time|
  puts "slot #{slot} at #{slot_time}"
end.join("\n")}
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

puts %Q(\n\n
Cardano Block Checker
Copyright Cardano Fans (CRFA) (https://cardano.fans)
)