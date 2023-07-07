require 'time'
require 'bundler/setup'
Bundler.require(:default) # require all bundled gems
Dotenv.load

class BlockChecker
  SHELLY_SLOT = 4492800
  SHELLEY_EPOCH = 208
  SLOTS_PER_EPOCH = 432000

  attr_reader :assigned_slots_count
  attr_reader :minted_blocks
  attr_reader :lost_height_battles
  attr_reader :lost_slot_battles
  attr_reader :future_mints
  attr_reader :unknown_block_status
  attr_reader :performance

  def initialize
    @assigned_slots = {}
    @minted_blocks = {}
    @lost_height_battles = {}
    @lost_slot_battles = {}
    @future_mints = {}
    @unknown_block_status = {}
    @performance = {}

    build_data
  end

  def input_file
    @input_file ||= File.open(ARGV[0] || Dir["./epochs/*"].sort.last)
  end

  def pool_id
    @pool_id ||= ARGV[1] || ENV.fetch('POOL_ID')
  end

  def epoch_no
    @epoch_no ||= File.basename(input_file.path, ".*").to_i
  end

  def epoch_running?
    @epoch_running ||= (epoch_no == epoch_for_slot(latest_slot))
  end

  def epoch_for_slot(slot)
    SHELLEY_EPOCH + ((slot - SHELLY_SLOT) / SLOTS_PER_EPOCH)
  end

  def latest_slot
    @latest_slot ||= blockfrost_client.get_block_latest.dig(:body, :slot)
  end

  def blockfrost_client
    @blockfrost_client ||= Blockfrostruby::CardanoMainNet.new(ENV.fetch 'BLOCKFROST_MAINNET_KEY')
  end

  def assigned_slots
    return @assigned_slots if @assigned_slots.any?

    assign_slots_from_cncli_json
  rescue JSON::ParserError
    assign_slots_from_cardano_cli
  ensure
    input_file.close
  end

  def assign_slots_from_cncli_json
    # `cncli leaderlog` format
    cncli_leaderlogs = JSON.parse(input_file.read)
    cncli_leaderlogs["assignedSlots"].each do |slot|
      @assigned_slots[slot["slot"]] = Time.parse(slot["at"]).utc
    end

    @assigned_slots_count = @assigned_slots.size
    @assigned_slots
  end

  def assign_slots_from_cardano_cli
    # `cardano-cli query leadership-schedule` format
    File.foreach(input_file.path).with_index do |line, index|
      if index == 0
        raise StandardError, "Corrupt file format - #{input_file.path}" unless line.match /^\s*SlotNo/
      end

      m = line.match /^\s*(?<slot>\d*)\s*(?<time>.*)/
      if m && !m[:slot].empty?
        @assigned_slots[m[:slot].to_i] = Time.parse(m[:time]).utc
      end
    end

    @assigned_slots_count = @assigned_slots.size
    @assigned_slots
  end

  def build_data
    assigned_slots.each do |slot, slot_time|
      block = blockfrost_client.get_block_in_slot(slot)
      status = block[:status]

      if slot < latest_slot # it makes sense to check only past slots
        if status == 200
          slot_leader_pool_id = block[:body][:slot_leader]

          unless slot_leader_pool_id == pool_id
            lost_slot_battles[slot] = [slot_leader_pool_id, slot_time]
          else
            minted_blocks[slot] = slot_time
          end
        elsif status == 404
          lost_height_battles[slot] = slot_time
        else
          unknown_block_status[slot] = slot_time
        end
      else
        future_mints[slot] = slot_time
      end
    end

    past_assigned_slots_count = assigned_slots_count - future_mints.size
    performance[:minted_blocks] = (minted_blocks.size.to_f / past_assigned_slots_count * 100).round(2)
    performance[:lost_height_battles] = (lost_height_battles.size.to_f / past_assigned_slots_count * 100).round(2)
    performance[:lost_slot_battles] = (lost_slot_battles.size.to_f / past_assigned_slots_count * 100).round(2)
  end
end