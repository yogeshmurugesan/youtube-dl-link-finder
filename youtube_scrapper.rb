require 'nokogiri'
require 'open-uri'
require 'byebug'
require 'Json'

@download_video_urls = [] 
# folder = "#{File.dirname(__FILE__)}/videos"
download_list_file_path = File.expand_path("download_list.json", File.dirname(__FILE__))
file = File.open(download_list_file_path)
videos_urls = JSON.parse(file.read)["urls"]
file.close
videos_urls.each do |videos_url|
  doc = Nokogiri::HTML(open("https://keepvid.com/?url=#{videos_url}"))
  table_body = doc.xpath('//tbody')
  video_table_body = table_body[0]
  video_rows = video_table_body.xpath('//tr')
  video_rows.each do |video_row| 
    unless video_row.to_s.match("720").nil?
      download_video_url = video_row.children[7].css('a')[0].attributes["href"].value
      # system("curl -o #{folder}/1.mp4 #{download_video_url}")
      # system("curl -o /Users/inkoop/Desktop/1.mp4 #{download_video_url}")
      @download_video_urls << download_video_url
    end
  end
  # doc.xpath('//tbody')[0].xpath('//tr')[2].children[7].css('a')[0].attributes["href"].value
  puts @download_video_urls.count
end
puts @download_video_urls
