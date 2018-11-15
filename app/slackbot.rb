require './commit_receiver'
require 'http'
require 'json'

Dotenv.load

cr = Commit.new
cr.get_from_github

response = HTTP.post('https://slack.com/api/chat.postMessage', params: {
                       token: ENV['SLACK_API_TOKEN'],
                       channel: '#test_t',
                       text: cr.message.insert(0, "```\n").insert(-1, '```'),
                       as_user: true
                     })
puts JSON.pretty_generate(JSON.parse(response.body))
