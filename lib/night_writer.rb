require_relative 'translation_keys'

class NightWriter
  include Keys

  def process_lines(file)
    top_lines    = translate_text_to_braille(open_file(file), 0..1).scan(/.{1,160}/)
    middle_lines = translate_text_to_braille(open_file(file), 2..3).scan(/.{1,160}/)
    bottom_lines = translate_text_to_braille(open_file(file), 4..5).scan(/.{1,160}/)
    format_lines_for_writing([top_lines, middle_lines, bottom_lines])
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
    braille_characters = map_to_keys(add_caps(alpha_characters))
    line = braille_characters.map { |c| c == ' ' ? ' ' : c[index_range] }
    line.join
  end

  def map_to_keys(characters)
    mapped = characters.map do |character|
      text_to_braille_key[character] if text_to_braille_key[character]
    end
    mapped.compact
  end

  def add_caps(characters)
    mapped = characters.map do |c|
      /[[:upper:]]/.match(c) ? ['cap', c.downcase] : c
    end
    mapped.flatten
  end

end

if __FILE__ == $0
  NightWriter.new.write_braille(ARGV[0], ARGV[1])
end
