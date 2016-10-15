class NightWriter
  attr_reader :top_key

  def initialize
    @top_key = {'a' => '0.', 'b' => '0.', 'c' => '00', 'd' => '00', 'e' => '0.', 'f' => '00', 'g' => '00', 'h' => '0.', 'i' => '.0', 'j' => '.0',
                'k' => '0.', 'l' => '0.', 'm' => '00', 'n' => '00', 'o' => '0.', 'p' => '00', 'q' => '00', 'r' => '0.', 's' => '.0', 't' => '.0',
                'u' => '0.', 'v' => '0.', 'w' => '.0', 'x' => '00', 'y' => '00', 'z' => '0.', '0' => '.0', '1' => '0.', '2' => '0.', '3' => '00',
                '4' => '00', '5' => '0.', '6' => '00', '7' => '00', '8' => '0.', '9' => '.0'}
  end

  def process_file(file)
    open_file(file)
  end

  def open_file(file)
    File.open(file).map(&:chomp).join(' ')
  end
end
