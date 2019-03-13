require_relative 'roman'

class RuleNumber
  attr_reader :value, :parts

  CLASS_PRIORITIES = [
    "RomanNumeral",
    "String",
    "FixNum"
  ].freeze

  LESS_THAN = -1
  IDENTICAL = 0
  GREATER_THAN = 1

  def initialize(value)
    @value = value
    @parts = value.to_s
                  .gsub(/[\(\)\. ]+/, ' ')
                  .gsub(/[ ]+/, ' ')
                  .split(' ')
                  .map { |s| classify(s) }
  end
  
  def to_s
    value
  end

	# -1 means self < other
	# 1 means self > other
	# 0 means identical
  def <=>(other)
    max_parts_length = [parts.length, other.parts.length].max

    for idx in 0..max_parts_length
      return LESS_THAN if idx == parts.length
      return GREATER_THAN if idx == other.parts.length

      parts_piece = parts[idx]
      other_piece = other.parts[idx]


      if parts_piece.class != other_piece.class
        if string_or_roman_conundrum?(parts_piece, other_piece)
          parts_piece = parts_piece.to_s 
          other_piece = other_piece.to_s 
        else
          return sort_divergent_classes(parts_piece, other_piece)
        end
      end
      
      value_for_part = value_for(parts_piece)
      value_for_other = value_for(other_piece)

      if value_for_part != value_for_other
        return value_for_part <=> value_for_other
      end
    end
    
    IDENTICAL
  end

  private

  def classify(part)
    begin
      Integer(part)
    rescue
      begin
        RomanNumeral.new(part)
      rescue
        part.to_s
      end
    end 
  end

  # Edge Case: a <=> c
  #   c could have been interperetted as a RomanNumeral
  #   In the case that both values have a length of 1 and one of those values is 
  #   definitely not a RomanNumeral, we need to treat both as strings
  def string_or_roman_conundrum?(first, second)
    return unless first.is_a?(String) || first.is_a?(RomanNumeral)
    return unless second.is_a?(String) || second.is_a?(RomanNumeral)
    return unless first.to_s.length == 1
    return unless second.to_s.length == 1
    true
  end

  def sort_divergent_classes(first, second)
    first_priority = CLASS_PRIORITIES.find_index(first.class.name)
    second_priority = CLASS_PRIORITIES.find_index(second.class.name)
    
    first_priority <=> second_priority
  end

  def value_for(part)
    return part.to_i if part.is_a?(RomanNumeral)
    return part if part.is_a?(Integer)
    part
  end
end
