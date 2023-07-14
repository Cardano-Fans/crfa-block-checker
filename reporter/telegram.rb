require_relative "../block_checker"
require "telegram/bot"

token = ENV.fetch("TELEGRAM_API_TOKEN")
chat_id = ENV.fetch("TELEGRAM_CHAT_ID")

bc = BlockChecker.new

def escape(s)
  ['.', '!', '-'].each do |delimiter|
    s.gsub!(delimiter, "\\#{delimiter}")
  end

  s
end

line = escape("-----------------------------------")
message = []

message << "\n*\u{1F4E3} Epoch #{bc.epoch_no}*"

message << "\n"
message << "\u{1F4DD} SUMMARY"
message << line
message << bc.summary_output

message << "\n"
message << "\u{1F4CA} PERFORMANCE STATS"
message << line
message << escape(bc.performance_stats_output)
if bc.epoch_running?
  message << escape("\nEpoch #{bc.epoch_no} is still running. The statistics include only the already past slots!")
end

if bc.future_mints.any?
  message << "\n"
  message << "\u{1F52E} FUTURE MINTS"
  message << line
  message << escape(bc.future_mints_output)
end

if bc.lost_slot_battles.any?
  message << "\n"
  message << "\u{2694} LOST SLOT BATTLES"
  message << line
  message << escape(bc.lost_slot_battles_output)
end

if bc.lost_height_battles.any?
  message << "\n"
  message << "\u{1F47B} LOST HEIGHT BATTLES"
  message << line
  message << escape(bc.lost_height_battles_output)
end

if bc.unknown_block_status.any?
  message << "\n"
  message << "\u{2753} UNKNOWN BLOCK STATUS"
  message << line
  message << escape(bc.unknown_block_status_output)
end

message << "\n"
message << "\u{1F477} CONTRIBUTERS"
message << line
message << bc.contributers.map do |ticker, url|
  "[#{ticker}](#{url})"
end.join(", ")

Telegram::Bot::Client.run(token) do |bot|
  bot.api.send_message(
    chat_id: chat_id,
    text: message.join("\n"),
    disable_web_page_preview: true,
    parse_mode: "MarkdownV2"
  )
end
