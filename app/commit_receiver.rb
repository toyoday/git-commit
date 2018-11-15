require 'octokit'
require 'byebug'
require 'tapp'
require 'date'
require 'dotenv'

Dotenv.load

# comment return
class Commit
  attr_accessor :message

  MONDEY_INDEX = 1

  def initialize
    # @message = self.class.get_from_github
    @message = ''
  end

  def get_from_github
    num_of_days = today_is_monday? ? 3 : 1
    commit_lists = fetch_commits.select { |commit| Date.today - commit[:commit][:author][:date].to_date <= num_of_days }

    commit_lists.each.with_index(1) do |commit, index|
      formated_message = commit[:commit][:message].gsub(/\*(.*?)\n/, '')
                                                  .gsub(/(\r\n?|\n)/, '')
      author = commit[:author][:login]
      @message += "#{index}. #{formated_message}(#{author})\n"
    end
  end

  def fetch_commits
    client = Octokit::Client.new login: ENV['LOGIN'], password: ENV['PASSWORD']
    client.commits ENV['REPOSITORY']
  end

  def today_is_monday?
    Date.today.wday == MONDEY_INDEX
  end
end
