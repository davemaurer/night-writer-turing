require_relative 'translation_keys'

class NightWriter
  include Keys

  def initialize
    @number_time = false
  end

  def process_lines(file)
    character_string = open_file(file)
    ranges = [0..1, 2..3, 4..5]
    lines = ranges.map do |range|
      translate_text_to_braille(character_string, range).scan(/.{1,160}/)
    end
    format_lines_for_writing(lines)
  end

  def format_lines_for_writing(lines)
    result = []
    lines.first.length.times do
      lines.map { |line| result << line.shift }
    end
    add_braille_line_breaks(result)
  end

  def add_braille_line_breaks(lines)
    lines.map do |line|
      current_number = lines.index(line) + 1
      current_number % 3 == 0 ? line + "\n\n" : line
    end
  end

  def open_file(file_given)
    File.open(file_given).map(&:chomp).join(' ')
  end

  def write_braille(file, target)
    lines = process_lines(file)
    File.open(target, 'w') { |f| f.puts(lines) }
  end

  def translate_text_to_braille(string_from_file, index_range)
    alpha_characters = string_from_file.chars
    formatted_characters = add_caps_and_numbers(alpha_characters)
    braille_characters = map_to_keys(formatted_characters)
    line = braille_characters.map { |c| c == ' ' ? ' ' : c[index_range] }
    line.join
  end

  def map_to_keys(characters)
    mapped = characters.map do |character|
      text_to_braille_key[character]
    end
    mapped.compact
  end

  def add_caps_and_numbers(characters)
    capitalized = characters.map do |c|
      /[[:upper:]]/.match(c) ? ['cap', c.downcase] : c
    end
    add_numbers(capitalized.flatten)
  end

  def add_numbers(characters)
    formatted = characters.map.with_index do |c, i|
      check_for_number(c, i)
    end
    @number_time = false
    formatted.flatten
  end

  def check_for_number(character, index)
    if is_a_number?(character) && @number_time == false
      add_lead_number(character, index)
    elsif is_an_end_number?(character, characters[index + 1]) && @number_time
      add_end_number(character)
    else
      character
    end
  end

  def add_lead_number(character, index)
    @number_time = true unless is_an_end_number?(character, characters[index + 1])
    ['num', character]
  end

  def add_end_number(character)
    @number_time = false
    character
  end

  def is_a_number?(character)
    (character.to_i != 0 || character == 0)
  end

  def is_an_end_number?(character, next_character)
    (is_a_number?(character) && next_character == ' ')
  end

end

if __FILE__ == $0
  NightWriter.new.write_braille(ARGV[0], ARGV[1])
end
