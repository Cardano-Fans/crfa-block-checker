require 'time'
require 'bundler/setup'
Bundler.require(:default) # require all bundled gems
Dotenv.load

SHELLY_SLOT = 4492800
SHELLEY_EPOCH = 208
SLOTS_PER_EPOCH = 432000

def epoch_for_slot(slot)
  SHELLEY_EPOCH + ((slot - SHELLY_SLOT) / SLOTS_PER_EPOCH)
end

blockfrost_project_id = ENV.fetch('BLOCKFROST_MAINNET_KEY')
blockfrost = Blockfrostruby::CardanoMainNet.new(blockfrost_project_id)
latest_slot = blockfrost.get_block_latest.dig(:body, :slot)

puts 'Latest slot: ' + latest_slot.to_s

input_file = ARGV[0] || Dir["./epochs/*"].sort.last
pool_id = ARGV[1] || ENV.fetch('POOL_ID')

assignedSlots = {}

begin
    # `cncli leaderlog` format
    cncliData = JSON.parse(File.read input_file)
    cncliData["assignedSlots"].each do |slot|
        assignedSlots[slot["slot"]] = Time.parse(slot["at"]).utc
    end
rescue JSON::ParserError
    # `cardano-cli query leadership-schedule` format
    File.open(input_file).each do |line|
      m = line.match /^\s*(?<slot>\d*)\s*(?<time>.*)/
      if m && !m[:slot].empty?
        assignedSlots[m[:slot].to_i] = Time.parse(m[:time]).utc
      end
    end
end

epochNo = epoch_for_slot(assignedSlots.keys.first)
currentEpochNo = epoch_for_slot(latest_slot)
epochSlots = assignedSlots.size

if epochSlots == 0
    puts 'No slots allocated for epochNo:' + epochNo
    exit 0
end

mintedBlocksCount = 0
heightBattleLost = 0
slotBattleLost = 0
stillToMint = 0

# this variable represents a state which indicates if we are currently running block checker for epoch that is in progress
currentlyRunningEpoch = epochNo == currentEpochNo

puts "Slots allocated: #{epochSlots} for epochNo: #{epochNo}"

puts "Checking if slots filled by blocks..."

assignedSlots.each do |slot, slotTime|
    block = blockfrost.get_block_in_slot(slot)
    status = block[:status]
    if slot < latest_slot # it makes sense to check only past slots
        if status == 200
            slotLeaderPoolId = block[:body][:slot_leader]

            if not slotLeaderPoolId == pool_id
                slotBattleLost += 1
                puts "Block minted on slot: #{slot} by pool leader: #{slotLeaderPoolId} due to a slot battle at #{at}."
            else
              mintedBlocksCount += 1
            end
        elsif status == 404
            heightBattleLost += 1
            puts "Block ghosted on slot: #{slot} due to a height battle at #{slotTime}."
        elsif
            puts "Unknown status: #{} for slotNo: #{slot}"
        end
    else
        stillToMint += 1
        puts "Block on slot #{slot} at #{slotTime} will be minted in the future."
    end
end


puts ''
puts '----------------'
puts ''


if currentlyRunningEpoch
  puts "#{stillToMint} still to mint in the future."
end

heightBattleLostPercentage = (heightBattleLost.to_f / epochSlots)
slotBattleLostPercentage = (slotBattleLost.to_f / epochSlots)
performancePercentage = (mintedBlocksCount.to_f / epochSlots * 100)

puts ''
puts '----------------'
puts ''

puts 'Summary for epochNo: ' + epochNo.to_s
puts 'Scheduled to mint blocks: ' +  epochSlots.to_s
puts 'Minted blocks: ' + mintedBlocksCount.to_s
puts "Height Battle Lost Count: #{heightBattleLost}"
puts "Slot Battle Lost Count: #{slotBattleLost}"
puts '----------------'

if currentlyRunningEpoch
    puts "Epoch #{epochNo} is still running, some stats are available only when the epoch #{epochNo} closes."
else
    puts "Epoch #{epochNo} already finished, showing full performance stats:"

    puts "Performance: #{performancePercentage.to_s} %"
    puts "Height Battle Lost Percentage: #{heightBattleLostPercentage * 100} %"
    puts "Slot Battle Lost Percentage: #{slotBattleLostPercentage * 100} %"
end

puts ''
puts ''

puts 'Cardano Block Checker'
puts 'Copyright Cardano Fans (CRFA) (https://cardano.fans)'
