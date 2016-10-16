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

  def process_file(file)
  end

  def open_file(file)
    File.open(file).map(&:chomp).join(' ')
  end

  def write_file(file, target)
    File.write(target, open_file(file))
  end

  def line_one(file_string)
    message_characters = file_string.chars
    braille_characters = message_characters.map { |character| @key[character] if @key[character] }
    top_line = braille_characters.map { |c| c[0..1] }
    top_line.join
  end
end

# NightWriter.new.write_file(ARGV[0], ARGV[1])
