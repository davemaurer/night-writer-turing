require 'minitest/autorun'
require 'minitest/pride'
require '../lib/night_writer'

describe NightWriter do
  before do
    @nw = NightWriter.new
  end

  it 'can take in a one line file' do
    text = 'The quick brown fox jumped over the lazy dogs. 1 fox, 5 dogs, 3 times. 10 ways to tuesday.'
    assert_equal text, @nw.open_file('test_text.txt')
  end

  it 'can take in a file with multiple lines' do
    text = 'This is line one. This is line two. And this is line three.'
    assert_equal text, @nw.open_file('test_text_multiline.txt')
  end

  it 'has an alphabet key' do
    tk = @nw.key
    top_of_word = tk['h'] + tk['e'] + tk['l'] + tk['l'] + tk['o']
    assert_equal '0.00..0..0..0.0.0.0.0.0.0..00.', top_of_word
  end
end
