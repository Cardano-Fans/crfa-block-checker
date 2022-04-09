require 'bundler'
require 'blockfrost-ruby'

crfa_pool_id = 'pool1d3gckjrphwytzw2uavgkxskwe08msumzsfj4lxnpcnpks3zjml3'

blockfrost = Blockfrostruby::CardanoMainNet.new(ENV['BLOCKFROST_MAINNET_KEY'])

input_file = ARGV[0]

file = File.read(input_file)
data_hash = JSON.parse(file)

assignedSlots = data_hash['assignedSlots']

assignedSlots.each { |item|
    slot = item["slot"]
    block = blockfrost.get_block_in_slot(slot)
    status = block[:status]

    if status == 200
        slotLeaderPoolId = block[:body][:slot_leader]

        if not slotLeaderPoolId == crfa_pool_id
            puts "SLOT_BATTLE -> block minted on slot: #{slot} by pool leader: #{slotLeaderPoolId}."
        end
    elsif
        puts "HEIGHT_BATTLE -> block ghosted on slot: #{slot}."
    end
}
