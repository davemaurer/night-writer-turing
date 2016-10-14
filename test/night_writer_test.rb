require 'minitest/autorun'
require 'minitest/pride'
require '../lib/night_writer'

describe NightWriter do
  before do
    @nw = NightWriter.new
  end

  it 'can take in a file' do
    text = 'The quick brown fox jumped over the lazy dogs. 1 fox, 5 dogs, 3 times. 10 ways to tuesday.'
    assert_equal text, @nw.open_file('test_text.txt')
  end
end
