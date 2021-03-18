require 'nokogiri'
require 'open-uri'

class Scraper

  def scrape!(page)
    pages = [page] # the pages we scrape
    words = [] # the words in the link content
    links = [] # the links in pages
    doc = nil
    (0..20).each do |i|
      scraped = false
      loop do
        begin 
          file = URI.open(page) #we assume the first page is a good URI 
          scraped = true
          doc = Nokogiri::HTML(file)
        rescue
          page =  links[rand(links.count)] # nokogiri does not follow redirects so if fetching the page fails we pick another link at random
          page = 'https://www.bbc.co.uk' + page.attr('href')
        end
        break if scraped == true
      end

      # scrape all of the anchor links on the page
      page_links = []

      doc.xpath("//a[starts-with(@href,'/news/')]").each do |link|
        puts link.inspect
      end

      doc.css('a').each do |link|
        page_links << link
      end

      # we only want links where the href starts with /news/
      news_links = page_links.select do |link|
        next unless link.attr('href')
        link.attr('href').start_with?("/news/")
      end

      #lets remove the one page app links
      news_links = news_links.select do |link|
        link.attr('href').include?("#") == false
      end

      # pick a random link for the next page....
      page =  news_links[rand(news_links.count)]
      page = page.attr('href')

      # add the links from this page to the links array
      links = links + news_links
      links.flatten!
    end

    # gather the content of the links but don't have repeated content 
    link_texts = []
    links.each do |link|
      link_texts << link.content
    end
    link_texts = link_texts.uniq
    
    # put the words into an array
    link_texts.each do |text|
      words << text.split(" ")
    end

    # remove the first word as this will always be capitalized
    words = words.collect do |ws|
      ws.shift # remove first word in sentence as it will always be capitalizedt
    end
    words.flatten!
    words.compact!

    # we only want words that begin with a capital letter
    words = words.select do |word|
      word[0] =~ /[A-Z]/
    end

    # return a count of each word
    words.each do |word|
      puts "#{word}: #{words.inject(0){|memo, w| memo += 1 if w == word ; memo}}"
    end
  end

end

Scraper.new.scrape!('https://www.bbc.co.uk/news')
