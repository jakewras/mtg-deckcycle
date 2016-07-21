# A ruby script used to login to tappedout.net and deckcycle
# a Magic deck in a loop every three hours (between 9am and 10pm)
# via Firefox Selenium WebDriver
# @version 0.1.1
# @author Jake Rasmussen jakewras@gmail.com
# @note rubocop complient

# gems = %w(rubocop selenium-webdriver activesupport timeout retries)
# gems.each do |g|
#   system("gem install #{g}")
# end
require 'selenium-webdriver'
require 'active_support/all'
require 'timeout'
require 'retries'
require 'optparse'

options = OpenStruct.new
options.name = nil
options.username = nil
options.password = nil
OptionParser.new do |opts|
  opts.banner = 'Usage: deckcycle.rb [options]'

  opts.on('-n', '--name [NAME]', 'Name of deck to deckcycle') do |v|
    options[:name] = v
  end
  opts.on('-u', '--username [USERNAME]', 'Tappedout.net username') do |v|
    options[:username] = v
  end
  opts.on('-p', '--password [PASSWORD]', 'Tappedout.net password') do |v|
    options[:password] = v
  end
  opts.on('-h', '--help', 'Display this screen') do
    puts opts
    exit
  end
end.parse!
mandatory = [:name, :username, :password]
missing = mandatory.select { |param| options[param].nil? }
unless missing.empty?
  puts "Missing options: #{missing.join(', ')}"
  system "ruby #{__FILE__} -h"
  exit
end

system "rubocop #{__FILE__}"

Timeout.timeout 1.month do
  loop do
    @current_time = Time.now
    if @current_time.hour.between? 9, 22
      driver = Selenium::WebDriver.for :firefox

      # Login
      driver.navigate.to 'http://tappedout.net/accounts/login/?next=/'
      element = driver.find_element :name, 'username'
      element.send_keys options[:username]
      element = driver.find_element :name, 'password'
      element.send_keys options[:password]
      element.submit

      # Attempt to deckcycle
      with_retries max_tries: 10 do
        url = "http://tappedout.net/mtg-decks/#{options[:name]}/deckcycle/"
        driver.navigate.to url
      end

      # Output text of alert element
      str = driver.find_element(class: 'alert').text
      puts "#{@current_time}: #{str}"

      # Logout & quit
      with_retries max_tries: 10 do
        driver.navigate.to 'http://tappedout.net/accounts/logout/?next=/'
      end
      driver.quit
      sleep 3.hours
    else
      puts "#{@current_time} not running at this time"
      sleep 1.hour
    end
  end
end
