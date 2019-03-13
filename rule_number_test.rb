require 'minitest/autorun'
require_relative 'rule_number'

describe RuleNumber do
  it 'integers' do
    sorted = %w[
      2
      3
      4
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'numerics' do
    sorted = %w[
      6.1
      6.2
      6.10
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'alphas' do
    sorted = %w[
      6.1(a)
      6.1(b)
      6.1(c)
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'capital letter precidence' do
    skip
    sorted = %w[
      6A
      6.1
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'different levels' do
    sorted = %w[
      6.1
      6.1(a)
      6.1(a)(i)
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'romans' do
    sorted = %w[
      6.1(i)
      6.1(ii)
      6.1(iii)
      6.1(iv)
      6.1(v)
      6.1(vi)
      6.1(vii)
      6.1(viii)
      6.1(ix)
      6.1(x)
      6.1(xiv)
      6.1(xv)
      6.1(xvi)
      6.1(xix)
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'repeated' do
    sorted = %w[
      6.1(a)
      6.1(b)
      6.1(aa)
      6.1(bb)
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'lots of text' do
    sorted = [
      'NFA Compliance Rule 2-41',
      'NFA Interpretive Notice #9062',
      'NFA Registration Rule 101'
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'dash' do
    sorted = [
      'NFA Compliance Rule 2-41',
      'NFA Compliance Rule 2-42'
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'pound sign' do
    sorted = [
      'NFA Compliance Rule #2',
      'NFA Compliance Rule #3'
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'extra spaces' do
    sorted = [
      'NFA Compliance Rule 2-33',
      'NFA Compliance  Rule 2-34',
      'NFA Compliance Rule 2-34(a)'
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'numbers at the end' do
    sorted = [
      'Financial Requirements Section 4',
      'Financial Requirements Section 7',
      'Financial Requirements Section 13',
      'Financial Requirements Section 13(b)',
      'Financial Requirements Section 15'
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'all dots' do
    sorted = %w[
      506
      506.A
      506.B
      515
      515.B
      515.B.1
      515.B.2
      515.B.3
      515.C
      515.E
      523
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'more dots' do
    sorted = %w[
      49.20(b)(3)
      49.20(b)(4)
      49.20(c)(1)(i)(A)
      49.20(c)(1)(i)(B)
      49.20(c)(1)(i)(C)
      49.20(c)(1)(ii)
      49.20(c)(2)
      49.20(c)(3)
      49.20(c)(4)
      49.20(c)(5)
      49.20(d)
      49.21
      49.21(a)(1)
      49.21(b)(1)
      49.21(b)(2)
      49.21(c)
      49.22(b)(1)
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'cfr' do
    sorted = [
      '17 CFR 1.23(b)',
      '17 CFR 4.23(a)(12)',
      '17 CFR 5.23(b)',
      '17 CFR 31.23(b)',
      '17 CFR 49.23(b)'
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  it 'punctuation' do
    sorted = [
      'One, Too',
      'One, Tree'
    ]

    assert_equal sorted, reverse_and_sort(sorted)
  end

  def reverse_and_sort(values)
    values.reverse
          .collect { |number| RuleNumber.new(number) }
          .sort
          .map(&:to_s)
  end
end
