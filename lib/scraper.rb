require 'nokogiri'
require 'httparty'
 
class HtmlParserIncluded < HTTParty::Parser
  def html
    Nokogiri::HTML(body)
  end
end

class Scraper
  include HTTParty
  parser HtmlParserIncluded
  base_uri 'bbc.co.uk'

  def initialize(category, quantity = 5)
    @category = category
    @quantity = quantity
  end

  def parse_url(category)
    self.class.get(category)
  end

  def get_links(category = @category)
    page = self.parse_url("/#{category}/")
    parsed_page = page.xpath("//a[starts-with(@href,\"/#{category}/\")]")
    get_links = parsed_page.map {|link| link.attribute('href').to_s}.uniq.sort.delete_if { |href| href.empty? }
    get_links.shuffle.first(@quantity)
  end
 
  def extract_words
    extracted_words = []
    self.get_links.each do |l|
      page = self.parse_url(l)
      extracted_words << page.title.split(" ").shift.gsub(/[^0-9A-Za-z-]/, '')
    end
    words = extracted_words.select { |word| word[0] =~ /[A-Z]/ }
    words.each_with_object(Hash.new(0)){ |string, hash| hash[string] += 1 }.sort_by(&:last)
  end
end

##
## running the code
##
s = Scraper.new('news', 20)
results = s.extract_words

results.reverse_each do |k, v|
  p "#{k}: #{v}"
end