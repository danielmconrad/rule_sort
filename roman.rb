# RomanNumeral attempts to convert a string to an integer
# based on the Roman Numeral representation of that string
class RomanNumeral
  attr_reader :number, :roman

  CHARACTERS = [
    # ['M',  1000],
    # ['CM',  900],
    # ['D',   500],
    # ['CD',  400],
    # ['C',   100],
    # ['XC',   90],
    ['L',    50],
    ['XL',   40],
    ['X',    10],
    ['IX',    9],
    ['V',     5],
    ['IV',    4],
    ['I',     1]
  ].freeze

  def initialize(roman)
    @roman = roman
    @number = from_roman(roman)
  end

  def to_s
    roman
  end

  def to_i
    number
  end

  private

  def valid?(roman)
    # MDC Not yet supported
    /^[LXVI]+$/.match(roman.upcase)
  end

  def from_roman(roman)
    raise ArgumentError, "invalid numerals: #{roman}" unless valid?(roman)

    number = 0
    remaining_characters = roman.upcase

    CHARACTERS.each do |pair|
      while remaining_characters.start_with?(pair[0])
        number += pair[1]
        remaining_characters.slice!(0, pair[0].length)
      end
    end

    number
  end
end
