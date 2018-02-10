require "selenium-webdriver"
require 'byebug'
require 'Json'

@download_video_urls = [] 
download_list_file_path = File.expand_path("download_list.json", File.dirname(__FILE__))
file = File.open(download_list_file_path)
videos_urls = JSON.parse(file.read)["urls"]
file.close

driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(:timeout => 10)

videos_urls.each do |videos_url|
  driver.navigate.to "https://keepvid.com/?url=#{videos_url}"
  wait.until {
    table_elements = driver.find_elements(:class, 'result-table')
    table_body = table_elements[0].find_element(:tag_name, 'tbody')
    table_rows = table_body.find_elements(:tag_name, 'tr')
    if table_rows[1].text.match(/720p/) || table_rows[1].text.match(/480p/)
      dl_link = table_rows[1].find_element(:class, 'dlink')
      # dl_link.click
      @download_video_urls << dl_link.attribute("href")
    end
  }
end
puts @download_video_urls
