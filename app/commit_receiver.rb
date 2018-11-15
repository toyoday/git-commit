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
    commit_lists = fetch_commits

    compare_list = needed_dates(Date.today.wday == MONDEY_INDEX ? [1, 2, 3] : [1])

    commit_lists.each.with_index(1) do |commit, index|
      next unless compare_list.include?(commit[:commit][:author][:date].to_date)

      formated_message = commit[:commit][:message].gsub(/\*(.*?)\n/, '')
                                                  .gsub(/(\r\n?|\n)/, '')
      author = commit[:author][:login]
      @message += "#{index}. #{formated_message}(#{author})\n"
    end
  end

  def needed_dates(diff_numbers)
    diff_numbers.map { |diff_number| Date.today - diff_number }
  end

  def fetch_commits
    client = Octokit::Client.new login: ENV['LOGIN'], password: ENV['PASSWORD']
    client.commits ENV['REPOSITORY']
  end

end
