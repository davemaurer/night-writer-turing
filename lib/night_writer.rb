class NightWriter
  attr_reader :key

  def initialize
    @key = {'a' => '0.....', 'b' => '0.0...', 'c' => '00....', 'd' => '00.0..', 'e' => '0..0..',
            'f' => '000...', 'g' => '0000..', 'h' => '0.00..', 'i' => '.00...', 'j' => '.000..',
            'k' => '0...0.', 'l' => '0.0.0.', 'm' => '00..0.', 'n' => '00.00.', 'o' => '0..00.',
            'p' => '000.0.', 'q' => '00000.', 'r' => '0.000.', 's' => '.00.0.', 't' => '.0000.',
            'u' => '0...00', 'v' => '0.0.00', 'w' => '.000.0', 'x' => '00..00', 'y' => '00.000',
            'z' => '0..000', '0' => '.000..', '1' => '0.....', '2' => '0.0...', '3' => '00....',
            '4' => '00.0..', '5' => '0..0..', '6' => '000...', '7' => '0000..', '8' => '0.00..',
            '9' => '.00...', '#' => '.0.000', '.' => '..00.0', '?' => '..0.00', '!' => '..000.',
            "'" => '....0.', ',' => '..0...', '-' => '....00', ' ' => ' ', 'cap' => '.....0'}
  end

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
      @key[character] if @key[character]
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
