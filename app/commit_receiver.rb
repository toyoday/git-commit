require 'octokit'
require 'byebug'
require 'tapp'
require 'date'
require 'dotenv'

Dotenv.load

# comment return
class Commit
  attr_accessor :message

  def initialize
    # @message = self.class.get_from_github
    @message = ''
  end

  def get_from_github
    make_date_diffs = lambda { |arr|
      arr.map { |elem| Date.today - elem }
    }
    client = Octokit::Client.new login: ENV['LOGIN'], password: ENV['PASSWORD']
    commitlist = client.commits ENV['REPOSITORI']
    compare_list = make_date_diffs.call(Date.today.wday == 1 ? [1, 2, 3] : [1])

    commitlist.each.with_index(1) do |commit, index|
      next unless compare_list.include?(commit[:commit][:author][:date].to_date)

      formated_message = commit[:commit][:message].gsub(/\*(.*?)\n/, '')
                                                  .gsub(/(\r\n?|\n)/, '')
      author = commit[:author][:login]
      @message += "#{index}. #{formated_message}(#{author})\n"
    end
  end
end
