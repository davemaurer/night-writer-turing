require 'minitest/autorun'
require 'minitest/pride'
require './lib/night_writer'

describe NightWriter do
  before do
    @nw = NightWriter.new
  end

  it 'can take in a one line file' do
    text = 'The quick brown fox jumped over the lazy dogs. 1 fox, 5 dogs, 3 times. 10 ways to Tuesday.'
    assert_equal text, @nw.open_and_format_file('./test/test_text.txt')
  end

  it 'can take in a file with multiple lines' do
    text = 'This is line one. This is line two. And this is line three. And this is line 4 5 6 7 8 9 10.'
    assert_equal text, @nw.open_and_format_file('./test/test_text_multiline.txt')
  end

  it 'has an alphabet key' do
    tk = @nw.text_to_braille_key
    braille_characters = tk['h'] + tk['e'] + tk['l'] + tk['l'] + tk['o']
    assert_equal '0.00..0..0..0.0.0.0.0.0.0..00.', braille_characters
  end

  it 'can write the top line of braille' do
    message = 'hello world'
    assert_equal '0.0.0.0.0. .00.0.0.00', @nw.translate_text_to_braille(message, 0..1)
  end

  it 'can write the second line of braille' do
    message = 'hello world'
    assert_equal '00.00.0..0 00.0000..0', @nw.translate_text_to_braille(message, 2..3)
  end

  it 'can write the third line of braille' do
    message = 'hello world'
    assert_equal '....0.0.0. .00.0.0...', @nw.translate_text_to_braille(message, 4..5)
  end

  it 'can take a file and prep it for braille output' do
    assert_equal ['0.00000.0.', '..0.0.0..0', '..0.0.0...'], @nw.process_lines('./test/test_apple.txt')
  end

  it 'takes in a file and outputs correct braille' do
    @nw.write_braille('./test/test_apple.txt', './test/test_target.txt')
    assert_equal "0.00000.0.\n..0.0.0..0\n..0.0.0...\n", File.read('./test/test_target.txt')
  end

  it 'starts out with a number_time attribute' do
    assert_equal false, @nw.number_time
  end

  it 'has a numbers_active? method to find out number_time state' do
    assert_equal false, @nw.numbers_active?
  end

  it 'can identify a number within a character collection' do
    collection = ['s', 't', 'r', 'i', 'n', 'g', '1']
    assert @nw.is_a_number?(collection.last)
  end

  it 'can tell when a character is not a number' do
    collection = ['s', 't', 'r', 'i', 'n', 'g', '1']
    refute @nw.is_a_number?(collection.first)
  end

  it 'knows when a character is the last number' do
    collection = ['1', '2', ' ', 's', 't', 'r', 'i', 'n', 'g']
    refute @nw.is_an_end_number?(collection.first, collection[1])
    assert @nw.is_an_end_number?(collection[1], collection[2])
  end

  it 'adds a number character to lead number in a character series' do
    collection = ['1', '2']
    assert_equal ['num', '1', '2'], @nw.add_numbers(collection)
  end

  it 'changes number_time to true when it finds a series of numbers' do
    collection = ['1', '2', ' ', 'a', 'b', '3']
    refute @nw.numbers_active?
    @nw.check_for_number(collection, collection[0], 0)
    assert @nw.numbers_active?
  end

  it 'changes number_time to false when done checking for numbers' do
    collection = ['1', '2', ' ', 'a', 'b', '3']
    @nw.number_time = true
    assert @nw.numbers_active?
    @nw.add_numbers(collection)
    refute @nw.numbers_active?
  end

  it 'adds capitals' do
    collection = ['A', 'b', 'C']
    assert_equal ['cap', 'a', 'b', 'cap', 'c'], @nw.add_caps_and_numbers(collection)
  end

end
