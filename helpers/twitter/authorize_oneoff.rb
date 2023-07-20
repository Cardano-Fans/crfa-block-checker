require 'bundler/setup'
Bundler.require(:default) # require all bundled gems

Dotenv.load

# Redirect uri doesn't matter, it will redirect your browser to this path and you can then get the code from that redirect
client = TwitterOAuth2::Client.new(
  identifier: ENV.fetch("TWITTER_CLIENT_ID"),
  secret: ENV.fetch("TWITTER_CLIENT_SECRET"),
  redirect_uri: "https://localhost/twitter/callback",
)

ARGV.clear

authorization_uri = client.authorization_uri(
  scope: [
    :'users.read',
    :'tweet.read',
    :'tweet.write',
    :'offline.access'
  ]
)

code_verifier = client.code_verifier
state = client.state

puts authorization_uri

# Get the code from the callback URL

print 'code: ' and STDOUT.flush
code = gets.chop

client.authorization_code = code
token_response = client.access_token! code_verifier

File.write("helpers/twitter/dumps/client", Marshal.dump(client))
File.write("helpers/twitter/dumps/token_response", Marshal.dump(token_response))
