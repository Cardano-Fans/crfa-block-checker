require 'bundler'
require 'blockfrost-ruby'

if ENV['BLOCKFROST_MAINNET_KEY'] == nil
    puts 'BLOCKFROST_MAINNET_KEY env variable is missing!'
    exit -1
end

blockfrost = Blockfrostruby::CardanoMainNet.new(ENV['BLOCKFROST_MAINNET_KEY'])

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

puts "Slots allocated: #{epochSlots} for epochNo: #{epochNo}"

puts "Checking slots..."
assignedSlots.each { |item|
    slot = item["slot"]
    block = blockfrost.get_block_in_slot(slot)
    status = block[:status]

    if status == 200
        mintedBlocksCount += 1
        slotLeaderPoolId = block[:body][:slot_leader]

        if not slotLeaderPoolId == pool_id
            slotBattleLost += 1
            puts "Block minted on slot: #{slot} by pool leader: #{slotLeaderPoolId} due to a slot battle."
        end
    elsif status == 404
        heightBattleLost += 1
        puts "Block ghosted on slot: #{slot} due to a height battle."
    elsif 
        puts "Unknown status: #{} for slotNo: #{slot}"
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
puts "Performance: #{performancePercentage.to_s} %"
puts '----------------'

puts "Height Battle Lost Count: #{ heightBattleLost}"
puts "Slot Battle Lost Count: #{ slotBattleLost}"
puts "Height Battle Lost Percentage: #{heightBattleLostPercentage * 100} %"
puts "Slot Battle Lost Percentage: #{slotBattleLostPercentage * 100} %"
