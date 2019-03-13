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
                  .map { |part| classify_part(part) }
  end
  
  def to_s
    value
  end

	# -1 means self < other
	# 1 means self > other
	# 0 means identical
  def <=>(other)
    compare_parts(parts, other.parts)
  end

  private

  def classify_part(part)
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

  def compare_parts(first_parts, second_parts)
    max_parts_length = [first_parts.length, second_parts.length].max

    for idx in 0..max_parts_length
      return LESS_THAN if idx == first_parts.length
      return GREATER_THAN if idx == second_parts.length

      first_part = first_parts[idx]
      second_part = second_parts[idx]

      if divergent_classes?(first_part, second_part)
        # Temporarily Disabled
        if single_string_and_roman?(first_part, second_part)
          first_part = first_part.to_s 
          second_part = second_part.to_s 
        else
          return compare_divergent_classes(first_part, second_part)
        end
      end
      
      value_for_part = value_for(first_part)
      value_for_other = value_for(second_part)

      if value_for_part != value_for_other
        if repeat_strings?(value_for_part, value_for_other)
          return compare_repeat_strings(value_for_part.to_s, value_for_other.to_s)
        end

        return value_for_part <=> value_for_other
      end
    end
    
    IDENTICAL
  end

  def repeat_strings?(first, second)
    return unless first.is_a?(String) && second.is_a?(String) 
    return if first.length == second.length
    first.split('').uniq.length == 1 && second.split('').uniq.length == 1
  end

  # Example: bb <=> a
  def compare_repeat_strings(first, second)
    return first.length <=> second.length if first[0] == first[0]
    first[0] <=> second[0]
  end

  def divergent_classes?(first, second)
    first.class != second.class
  end

  # Example: ii <=> 7
  def compare_divergent_classes(first, second)
    first_priority = CLASS_PRIORITIES.find_index(first.class.name)
    second_priority = CLASS_PRIORITIES.find_index(second.class.name)
    first_priority <=> second_priority
  end

  # Temporarily Disabled
  # Edge Case: a <=> c
  #   c could have been interperetted as a RomanNumeral
  #   In the case that both values have a length of 1 and one of those values is 
  #   definitely not a RomanNumeral, we need to treat both as strings
  def single_string_and_roman?(first, second)
    # return unless first.is_a?(String) || first.is_a?(RomanNumeral)
    # return unless second.is_a?(String) || second.is_a?(RomanNumeral)
    # return unless first.to_s.length == 1
    # return unless second.to_s.length == 1
    # true
    false
  end

  def value_for(part)
    return part.to_i if part.is_a?(RomanNumeral)
    return part if part.is_a?(Integer)
    part
  end
end
