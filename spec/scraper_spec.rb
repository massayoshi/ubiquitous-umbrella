require 'scraper'
require 'vcr'

describe Scraper do
    let(:category) { 'news' }
    let(:quantity) { rand(1..5) }
    subject(:scraper) do
        VCR.use_cassette("scraper") { Scraper.new(category, quantity) }
    end

    describe '#parse_url' do
        it 'returns a valid page', vcr: { :record => :all } do
            expect(scraper.parse_url("/#{category}")).to be_an_instance_of(HTTParty::Response)
        end
    end

    describe '#get_links' do
        it 'returns an array with X (quantity) links', vcr: { :record => :all } do
            links = scraper.get_links
            expect(links).to be_an_instance_of(Array)
            expect(links.size).to eq quantity
        end
    end

    describe '#extract_words' do
        it 'returns an array with first word from the title page', vcr: { :record => :all } do
            words = scraper.extract_words
            expect(words).to be_an_instance_of(Array)
        end
    end
end