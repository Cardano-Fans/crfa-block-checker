require 'bundler'
require 'blockfrost-ruby'

if ENV['BLOCKFROST_MAINNET_KEY'] == nil
    puts 'BLOCKFROST_MAINNET_KEY env variable is missing!'
    exit -1
end

crfa_pool_id = 'pool1d3gckjrphwytzw2uavgkxskwe08msumzsfj4lxnpcnpks3zjml3'


blockfrost = Blockfrostruby::CardanoMainNet.new(ENV['BLOCKFROST_MAINNET_KEY'])

input_file = ARGV[0]

file = File.read(input_file)

leaderSlotFileJson = JSON.parse(file)

epochNo = leaderSlotFileJson['epoch']
epochSlots = leaderSlotFileJson['epochSlots']

assignedSlots = leaderSlotFileJson['assignedSlots']

if epochSlots == 0
    puts 'No slots allocated for epochNo:' + epochNo
    exit 0
end

heightBattleLost = 0
slotBattleLost = 0

puts "Slots allocated: #{epochSlots} for epochNo: #{epochNo}"

puts "Checking..."
assignedSlots.each { |item|
    slot = item["slot"]
    block = blockfrost.get_block_in_slot(slot)
    status = block[:status]

    if status == 200
        slotLeaderPoolId = block[:body][:slot_leader]

        if not slotLeaderPoolId == crfa_pool_id
            slotBattleLost += 1
            puts "SLOT_BATTLE -> block minted on slot: #{slot} by pool leader: #{slotLeaderPoolId}"
        end
    elsif
        heightBattleLost += 1
        puts "HEIGHT_BATTLE -> block ghosted on slot: #{slot}"
    end
}

heightBattleLostPercentage = (heightBattleLost.to_f / epochSlots)
slotBattleLostPercentage = (slotBattleLost.to_f / epochSlots)

puts '----------------'
puts '----------------'

puts 'Summary for epochNo: ' + epochNo.to_s
puts "Height Battle Lost Count: #{ heightBattleLost}"
puts "Slot Battle Lost Count: #{ slotBattleLost}"
puts "Height Battle Lost Percentage: #{heightBattleLostPercentage * 100} %"
puts "Slot Battle Lost Percentage: #{slotBattleLostPercentage * 100} %"
