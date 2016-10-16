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
    top_line    = create_braille_line(open_file(file), 0..1).slice(1..160)
    middle_line = create_braille_line(open_file(file), 2..3).slice(1..160)
    bottom_line = create_braille_line(open_file(file), 4..5).slice(1..160)
    [top_line, middle_line, bottom_line]
  end

  def open_file(file_given)
    File.open(file_given).map(&:chomp).join(' ')
  end

  def write_file(file_to_read, target)
    lines = process_lines(file_to_read)
    File.open(target, 'w') { |file| file.puts(lines) }
  end

  def create_braille_line(file_string, index_range)
    message_characters = file_string.chars.map(&:downcase)
    braille_characters = message_characters.map { |character| @key[character] if @key[character] }
    line = braille_characters.map { |c| c == ' ' ? ' ' : c[index_range] }
    line.join
  end
end

NightWriter.new.write_file(ARGV[0], ARGV[1])
