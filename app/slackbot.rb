require './commit_receiver'
require 'http'
require 'json'
require 'byebug'

cr = CommitReceiver.new
cr.commit_get
Dotenv.load
response = HTTP.post('https://slack.com/api/chat.postMessage', params: {
                       token: ENV['SLACK_API_TOKEN'],
                       channel: '#dev',
                       text: cr.message.insert(0, "```\n").insert(-1, '```'),
                       as_user: true
                     })
puts JSON.pretty_generate(JSON.parse(response.body))
