require 'minitest/autorun'
require 'minitest/pride'
require './lib/night_writer'

describe NightWriter do
  before do
    @nw = NightWriter.new
  end

  it 'can take in a one line file' do
    text = 'The quick brown fox jumped over the lazy dogs. 1 fox, 5 dogs, 3 times. 10 ways to Tuesday.'
    assert_equal text, @nw.open_file('./test/test_text.txt')
  end

  it 'can take in a file with multiple lines' do
    text = 'This is line one. This is line two. And this is line three. And this is line 4 5 6 7 8 9 10.'
    assert_equal text, @nw.open_file('test_text_multiline.txt')
  end

  it 'has an alphabet key' do
    tk = @nw.key
    braille_characters = tk['h'] + tk['e'] + tk['l'] + tk['l'] + tk['o']
    assert_equal '0.00..0..0..0.0.0.0.0.0.0..00.', braille_characters
  end

  it 'can write the top line of braille' do
    message = 'hello world'
    assert_equal '0.0.0.0.0. .00.0.0.00', @nw.create_braille_line(message, 0..1)
  end

  it 'can write the second line of braille' do
    message = 'hello world'
    assert_equal '00.00.0..0 00.0000..0', @nw.create_braille_line(message, 2..3)
  end

  it 'can write the third line of braille' do
    message = 'hello world'
    assert_equal '....0.0.0. .00.0.0...', @nw.create_braille_line(message, 4..5)
  end

  it 'can write a word in braille' do
    file = File.open('new_file', 'w') { |f| f.puts 'apple' }
    file_string = File.open(file).map(&:chomp).join(' ')
    assert_equal ['0.00000.0.', '..0.0.0..0', '..0.0.0...'], @nw.process_lines(file_string)
  end
end
