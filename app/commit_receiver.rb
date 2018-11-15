require 'octokit'
require 'byebug'
require 'tapp'
require 'date'
require 'dotenv'

# comment return
class CommitReceiver
  attr_accessor :message
  def commit_get
    make_date_diffs = lambda { |arr|
      arr.map { |elem| Date.today - elem }
    }
    @message = ''
    Dotenv.load
    client = Octokit::Client.new login: ENV['LOGIN'], password: ENV['PASSWORD']
    commitlist = client.commits ENV['REPOSITORI']
    compare_list = make_date_diffs.call(Date.today.wday == 1 ? [1, 2, 3] : [1])
    index = 1
    commitlist.each do |commit|
      next unless compare_list.include?(commit[:commit][:author][:date].to_date)

      formated_message = commit[:commit][:message].gsub(/\*(.*?)\n/, '')
                                                  .gsub(/(\r\n?|\n)/, '')
      author = commit[:author][:login]
      @message += "#{index}. #{formated_message}(#{author})\n"
      index += 1
    end
  end
end
