require_relative "../block_checker"

discord_webhook_url = ENV.fetch("DISCORD_WEBHOOK_URL")
discord_client = Discordrb::Webhooks::Client.new(url: discord_webhook_url)

bc = BlockChecker.new

discord_client.execute do |builder|
  builder.content = "## :loudspeaker: Epoch #{bc.epoch_no}"

  builder.add_embed do |embed|
    embed.title = ":pencil: SUMMARY"
    embed.description = bc.summary_output
  end

  builder.add_embed do |embed|
    embed.title = ":bar_chart: PERFORMANCE STATS"
    embed.description = bc.performance_stats_output
    if bc.epoch_running?
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(
        text: "Epoch #{bc.epoch_no} is still running. The statistics include only the already past slots!"
      )
    end
  end

  if bc.future_mints.any?
    builder.add_embed do |embed|
      embed.title = ":crystal_ball: FUTURE MINTS"
      embed.description = bc.future_mints_output
    end
  end

  if bc.lost_slot_battles.any?
    builder.add_embed do |embed|
      embed.title = ":crossed_swords: LOST SLOT BATTLES"
      embed.description = bc.lost_slot_battles_output
    end
  end

  if bc.lost_height_battles.any?
    builder.add_embed do |embed|
      embed.title = ":ghost: LOST HEIGHT BATTLES"
      embed.description = bc.lost_height_battles_output
    end
  end

  if bc.unknown_block_status.any?
    builder.add_embed do |embed|
      embed.title = ":question: UNKNOWN BLOCK STATUS"
      embed.description = bc.unknown_block_status_output
    end
  end

  builder.add_embed do |embed|
    embed.title = ":construction_worker: CONTRIBUTERS"
    embed.description = bc.contributers.map do |ticker, url|
      "[#{ticker}](#{url})"
    end.join(", ")
  end
end