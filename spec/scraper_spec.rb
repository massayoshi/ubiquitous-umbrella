require 'scraper'

describe Scraper do
    let(:category) { 'news' }
    let(:quantity) { rand(1..5) }
    subject(:scraper) { Scraper.new(category, quantity) }

    describe '#parse_url' do
        it 'returns a valid page' do
            expect(scraper.parse_url("/#{category}/")).to be_an_instance_of(HTTParty::Response)
        end
    end

    describe '#get_links' do
        it 'returns an array with X (quantity) links' do
            links = scraper.get_links
            expect(links).to be_an_instance_of(Array)
            expect(links.size).to eq quantity
        end
    end

    describe '#extract_words' do
        it 'returns an array with first word from the title page' do
            words = scraper.extract_words
            expect(words).to be_an_instance_of(Array)
        end
    end
end