# frozen_string_literal: true

# A ruby script used to login to tappedout.net and deckcycle
# a Magic deck in a loop every three hours (between 9 am and 10 pm)
# via Firefox Selenium WebDriver
#
# @author Jake Rasmussen jakewras@gmail.com
# @note rubocop compliant

require 'selenium-webdriver'
require 'active_support/all'
require 'timeout'
require 'retries'
require 'optparse'
require 'net/http'

options = {}
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
mandatory = %i[name username password]
missing = mandatory.select { |param| options[param].nil? }
unless missing.empty?
  puts "Missing options: #{missing.join(', ')}"
  system "ruby #{__FILE__} -h"
  exit
end

retry_count = 0
begin
  Timeout.timeout 1.month do
    loop do
      @current_time = Time.now
      if @current_time.hour.between? 9, 22
        begin
          @driver = Selenium::WebDriver.for :firefox

          # Login
          @driver.navigate.to 'https://tappedout.net/accounts/login/?next=/'
          element = @driver.find_element :name, 'username'
          element.send_keys options[:username]
          element = @driver.find_element :name, 'password'
          element.send_keys options[:password]
          element.submit
          sleep 5.seconds

          # Attempt to deckcycle
          with_retries max_tries: 10 do
            url = "https://tappedout.net/mtg-decks/#{options[:name]}/deckcycle/"
            @driver.navigate.to url
          end

          # Output text of alert element
          str = @driver.find_element(class: 'alert').text
          puts "#{@current_time}: #{str}"

          # Logout & quit
          with_retries max_tries: 10 do
            @driver.navigate.to 'https://tappedout.net/accounts/logout/?next=/'
          end
          @driver.quit
          sleep 3.hours
        rescue Selenium::WebDriver::Error::NoSuchElementError
          retry_count += 1
          puts "Selenium::WebDriver::Error::NoSuchElementError retry_count: #{retry_count}"
          @driver.quit
          exit if retry_count > 4
          # sleep for 10 minutes and retry because site might be down for maintenance
          sleep 600
          retry
        end
      else
        puts "#{@current_time} not running at this time"
        sleep 1.hour
      end
    end
  end
rescue Net::ReadTimeout
  retry_count += 1
  puts "Net::ReadTimeout retry_count: #{retry_count}"
  @driver.quit
  retry_count > 4 ? exit : retry
end
