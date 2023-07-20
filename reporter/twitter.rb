require_relative "../block_checker"

bc = BlockChecker.new

tweet = []
tweet << "\u{1F4E3} EPOCH #{bc.epoch_no}"
tweet << "\nSUMMARY"
tweet << "--------"
tweet << bc.summary_output
tweet << "\nPERFORMANCE"
tweet << "--------"
tweet << bc.performance_stats_output

class RetryableTwitterApiError < StandardError; end

def refresh_token!(client, token)
  client.refresh_token = token.refresh_token
  new_token = client.access_token!

  File.write("helpers/twitter/dumps/client", Marshal.dump(client))
  File.write("helpers/twitter/dumps/token_response", Marshal.dump(new_token))
end

def load_client_and_token
  client = Marshal.load(File.read("helpers/twitter/dumps/client"))
  token = Marshal.load(File.read("helpers/twitter/dumps/token_response"))

  [client, token]
end

begin
  attempts ||= 0
  attempts += 1

  client, token = load_client_and_token

  options = {
    method: :post,
    headers: {
      "Content-Type" => "application/json",
      Authorization: "Bearer #{token.access_token}"
    },
    body: {
      text: tweet.join("\n"),
    }.to_json
  }

  response = Typhoeus::Request.new("https://api.twitter.com/2/tweets", options).run

  if response.code == 401 && attempts < 2
    raise RetryableTwitterApiError
  end
rescue RetryableTwitterApiError
  refresh_token!(client, token)
  retry
end

puts JSON.parse(response.body)

raise "#{response.code} response code received" if response.code != 201
