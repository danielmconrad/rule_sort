class RomanNumeral
  attr_reader :number, :roman

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
  
  def from_roman(roman)
    r = roman.upcase
    number = 0
    
    until r.empty? do
      case
      # when r.start_with?('M')  then val = 1000; len = 1
      # when r.start_with?('CM') then val = 900;  len = 2
      # when r.start_with?('D')  then val = 500;  len = 1
      # when r.start_with?('CD') then val = 400;  len = 2
      # when r.start_with?('C')  then val = 100;  len = 1
      # when r.start_with?('XC') then val = 90;   len = 2
      when r.start_with?('L')  then val = 50;   len = 1
      when r.start_with?('XL') then val = 40;   len = 2
      when r.start_with?('X')  then val = 10;   len = 1
      when r.start_with?('IX') then val = 9;    len = 2
      when r.start_with?('V')  then val = 5;    len = 1
      when r.start_with?('IV') then val = 4;    len = 2
      when r.start_with?('I')  then val = 1;    len = 1
      else
        raise ArgumentError.new("invalid roman numerals: #{roman}")
      end

      number += val
      r.slice!(0, len)
    end

    number
  end
end
