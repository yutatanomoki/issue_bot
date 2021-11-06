# require 'http'
# require 'json'
# require 'eventmachine'
# require 'faye/websocket'

# response = HTTP.post("https://slack.com/api/rtm.start", params: {
#   token: ENV['SLACK_API_TOKEN']
# })

# rc = JSON.parse(response.body)

# url = rc['url']

# EM.run do
#   # Web Socketインスタンスの立ち上げ
#   ws = Faye::WebSocket::Client.new(url)

#   #  接続が確立した時の処理
#   ws.on :open do
#     p [:open]
#   end

#   # RTM APIから情報を受け取った時の処理
#   ws.on :message do |event|
#     data = JSON.parse(event.data)
#     p [:message, data]

#     if data['text'] == 'こんにちは'
#       ws.send({
#         type: 'message',
#         text: "こんにちは <@#{data['user']}> さん",
#         channel: data['channel']
#         }.to_json)
#     end
#   end

#   # 接続が切断した時の処理
#   ws.on :close do
#     p [:close, event.code]
#     ws = nil
#     EM.stop
#   end

# end

# require 'http'
# require 'json'
# require 'eventmachine'
# require 'faye/websocket'
# require 'uri'
# require 'net/http'
# require 'net/https'


# # 環境変数を設定する
# # export SLACK_API_TOKEN=xoxo-hogehoge-api
# # export GITHUB_USERNAME=hoge
# # export GITHUB_PASSWORD=hogepass

# SLACK_RTM_URL="https://slack.com/api/rtm.start"
# SLACK_REACTION_URL="https://slack.com/api/reactions.get"


# response = HTTP.post(SLACK_RTM_URL, params: {
#     token: ENV['SLACK_API_TOKEN']
# })

# rc = JSON.parse(response.body)
# url = rc['url']

# EM.run do
#     # Web Socketインスタンスの立ち上げ
#     ws = Faye::WebSocket::Client.new(url)

#     #  接続が確立した時の処理
#     ws.on :open do
#         p [:open]
#     end
#     # RTM APIから情報を受け取った時の処理
#     ws.on :message do |event|
#         data = JSON.parse(event.data)
#         p [:message, data]
#         if data['text'] == '疲れた'
#             ws.send({
#                 type: 'message',
#                 text: "お疲れ様です！ <@#{data['user']}> さん",
#                 channel: data['channel']
#             }.to_json)
#         elsif data['text'] == ':github_issue:'
#             ws.send({
#                 type: 'message',
#                 text: "<@#{data['user']}> さん！メッセージに、:github_issue:リアクションをするとissueが簡単に作成できますよ。",
#                 channel: data['channel']
#             }.to_json)
#         elsif data['text'] == 'グッときた'
#             ws.send({
#                 type: 'message',
#                 text: "<@#{data['user']}> さん、:最高かよ:",
#                 channel: data['channel']
#             }.to_json)
#         end

#         if data['reaction'] == 'github_issue'

#             slack_response = HTTP.post(SLACK_REACTION_URL, params: {
#                     token: ENV['SLACK_API_TOKEN'],
#                     channel: data['item']['channel'],
#                     timestamp: data['item']['ts']
#                 })
#             slack_response = JSON.parse(slack_response)

#             https = Net::HTTP.new('api.github.com', '443')
#             https.use_ssl = true
#             https.start do |https|
#                 # Issue を作る API: http://developer.github.com/v3/issues/#create-an-issue
#                 req = Net::HTTP::Post.new('/repos/githubアカウント名/リポジトリ名/issues')
#                 req.basic_auth ENV['GITHUB_USERNAME'],ENV['GITHUB_PASSWORD']
#                 issue_info = {
#                 'title': "#{slack_response['message']["text"]}",
#                 'body': "ヘルプです",
#                 "labels": [
#                         "help wanted"
#                     ]
#                 }

#                 # githubAPIを叩いて、issue作成
#                 req.body = JSON.generate issue_info
#                 github_response = https.request(req)

#                 # JSON.parseとは、JSON形式の文字列をRubyのHash形式に変換するためのメソッド
#                 github_response = JSON.parse(github_response.body)

#                 ws.send({
#                     type: 'message',
#                     text: "<@#{data['user']}> さんのために、issueを作成しました！issueボードを確認してください。 #{github_response["html_url"]}",
#                     channel: data['item']['channel']
#                 }.to_json)
#             end
#         elsif  data['reaction'] == 'fish'
#             slack_response = HTTP.post(SLACK_REACTION_URL, params: {
#                     token: ENV['SLACK_API_TOKEN'],
#                     channel: data['item']['channel'],
#                     timestamp: data['item']['ts']
#                 })
#             slack_response = JSON.parse(slack_response)

#             ws.send({
#                 type: 'message',
#                 text: "魚のリアクションしましたね？",
#                 # text: "#{slack_response['message']['text']}に、魚のリアクションしましたね？",
#                 channel: data['item']['channel']
#             }.to_json)
#         elsif data['reaction'] == 'gyozabu'
#             ws.send({
#                 type: 'message',
#                 text: "なるほど！<@#{data['user']}> さんは震えるほど餃子が食べたいみたいですよ！ <@here> 今日は、餃子活動しないんですか？",
#                 channel: data['item']['channel']
#             }.to_json)
#         end
#     end
#     # 接続が切断した時の処理
#     ws.on :close do
#         p [:close, event.code]
#         ws = nil
#         EM.stop
#     end

# end

# require 'http'
# require 'json'

# puts(ENV['SLACK_API_TOKEN'])

# response = HTTP.post("https://slack.com/api/chat.postMessage", params: {
#     token: ENV['SLACK_API_TOKEN'],
#     channel: "C02KU7X3MLJ",
#     text: "こんにちは！",
#     as_user: true,
#   })
# puts JSON.pretty_generate(JSON.parse(response.body))

require 'slack-ruby-bot'
SlackRubyBot::Client.logger.level = Logger::WARN

class Bot
  def call(client, data)
    client.say(text: data.text, channel: data.channel)
  end
end

server = SlackRubyBot::Server.new(
  token: 'xoxb-2671280892101-2702747161297-hTJIqJ28MpTwvBeAzF34V1uL',
  hook_handlers: {
    message: Bot.new
  }
)
server.run