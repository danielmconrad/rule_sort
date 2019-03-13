require_relative 'roman'

# RuleNumber takes a string value and classifies its component parts.
# These component parts are later used to compare against other RuleNumbers to
# determine the correct sort order.
class RuleNumber
  attr_reader :value, :parts

  CLASS_PRIORITIES = %w[RomanNumeral String FixNum].freeze
  LESS_THAN = -1
  IDENTICAL = 0
  GREATER_THAN = 1

  def initialize(value)
    @value = value
    @parts = to_parts(value)
  end

  def to_s
    value
  end

  # <=> compares a self against another RuleNumber
  #   -1 means self < other
  #    1 means self > other
  #    0 means identical
  def <=>(other)
    indexes = 0..[parts.length, other.parts.length].max

    indexes.inject(IDENTICAL) do |_result, idx|
      break LESS_THAN if idx == parts.length
      break GREATER_THAN if idx == other.parts.length

      comparison = compare_parts(parts[idx], other.parts[idx])
      break comparison unless comparison == IDENTICAL

      IDENTICAL
    end
  end

  private

  def to_parts(value)
    value.to_s
         .gsub(/[\(\)\. ]+/, ' ')
         .gsub(/[ ]+/, ' ')
         .split(' ')
         .map { |part| classify_part(part) }
  end

  def classify_part(part)
    Integer(part)
  rescue
    begin
      RomanNumeral.new(part)
    rescue
      part.to_s
    end
  end

  def compare_parts(first_part, other_part)
    if first_part == other_part
      IDENTICAL
    elsif divergent_classes?(first_part, other_part)
      compare_divergent_classes(first_part, other_part)
    elsif repeat_strings?(first_part, first_part)
      compare_repeat_strings(first_part, other_part)
    else
      value_for(first_part) <=> value_for(other_part)
    end
  end

  # Example: bbb, cc, a
  def repeat_strings?(first, other)
    return false unless first.is_a?(String) && other.is_a?(String)
    first.split('').uniq.length == 1 && other.split('').uniq.length == 1
  end

  # Example: bb <=> b, bb <=> a
  def compare_repeat_strings(first, other)
    return first.length <=> other.length if first.length != other.length
    first[0] <=> other[0]
  end

  # Example: RomanNumeral, String
  def divergent_classes?(first, other)
    first.class != other.class
  end

  # Example: ii <=> 7
  def compare_divergent_classes(first, other)
    # Temporarily Disabled
    # if single_string_and_roman?(first_part, other_part)
    #   first_part = first_part.to_s
    #   other_part = other_part.to_s
    # else
    first_priority = CLASS_PRIORITIES.find_index(first.class.name)
    other_priority = CLASS_PRIORITIES.find_index(other.class.name)
    first_priority <=> other_priority
  end

  # Edge Case: a <=> c
  #   c could have been interperetted as a RomanNumeral
  #   In the case that both values have a length of 1 and one of those values is
  #   definitely not a RomanNumeral, we need to treat both as strings
  def single_string_and_roman?(first, other)
    is_one_string = other.is_a?(String) || other.is_a?(String)
    is_one_roman = first.is_a?(RomanNumeral) || other.is_a?(RomanNumeral)
    both_single_chars = first.to_s.length == 1 && other.to_s.length == 1
    is_one_string && is_one_roman && both_single_chars
  end

  def value_for(part)
    return part.to_i if part.is_a?(RomanNumeral)
    return part if part.is_a?(Integer)
    part
  end
end
