require 'bundler'
require 'blockfrost-ruby'

if ENV['BLOCKFROST_MAINNET_KEY'] == nil
    puts 'BLOCKFROST_MAINNET_KEY env variable is missing!'
    exit -1
end

blockfrost = Blockfrostruby::CardanoMainNet.new(ENV['BLOCKFROST_MAINNET_KEY'])
latest_slot = blockfrost.get_block_latest[:body][:slot]

puts 'Latest slot: ' + latest_slot.to_s

input_file = ARGV[0]
pool_id = ARGV[1]

file = File.read(input_file)

leaderSlotFileJson = JSON.parse(file)

epochNo = leaderSlotFileJson['epoch']
epochSlots = leaderSlotFileJson['epochSlots']

assignedSlots = leaderSlotFileJson['assignedSlots']

if epochSlots == 0
    puts 'No slots allocated for epochNo:' + epochNo
    exit 0
end

mintedBlocksCount = 0
heightBattleLost = 0
slotBattleLost = 0

# this variable represents a state which indicates if we are currently running block checker for epoch that is in progress
currentlyRunningEpoch = false

puts "Slots allocated: #{epochSlots} for epochNo: #{epochNo}"

puts "Checking if slots filled by blocks..."
assignedSlots.each { |item|
    slot = item["slot"]
    at = item["at"]
    block = blockfrost.get_block_in_slot(slot)
    status = block[:status]
    if slot < latest_slot # it makes sense to check only past slots
        if status == 200
            mintedBlocksCount += 1
            slotLeaderPoolId = block[:body][:slot_leader]
    
            if not slotLeaderPoolId == pool_id
                slotBattleLost += 1
                puts "Block minted on slot: #{slot} by pool leader: #{slotLeaderPoolId} due to a slot battle at #{at}."
            end
        elsif status == 404
            heightBattleLost += 1
            puts "Block ghosted on slot: #{slot} due to a height battle at #{at}."
        elsif 
            puts "Unknown status: #{} for slotNo: #{slot}"
        end
    else
        # if we are here it means there were some blocks which are to be minted in the future
        currentlyRunningEpoch = true
        puts "Block on slot #{slot} at #{at} will be minted in the future."
    end

}

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
