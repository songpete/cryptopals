# Different ways of scoring text to search for actual messages.

# frequency of letters in the English language. From wikipedia: https://en.wikipedia.org/wiki/Letter_frequency
CHAR_FREQ = [8.17, 1.49, 2.78, 4.25, 12.70, 2.23, 2.02, 6.09, 6.97, 0.15, 0.77, 4.03, 2.41, 6.75, 7.51, 1.93, 0.09, 5.99, 6.33, 9.06, 2.76, 0.98, 2.36, 0.15, 1.97, 0.07]
ALL_LETTERS = ('a'..'z').to_a

# Higher score is better. Based on letter frequency, space ratio and vowels
def score_text(txt)
  txt_length = txt.length.to_f
  total_score = 0

  e_ratio = txt.count('e') / txt_length
  t_ratio = txt.count('t') / txt_length
  a_ratio = txt.count('a') / txt_length
  o_ratio = txt.count('o') / txt_length
  i_ratio = txt.count('i') / txt_length

  space_ratio = txt.count(' ') / txt_length

  total_score += 1 if i_ratio > 0.01 && i_ratio < 0.10
  total_score += 2 if e_ratio > 0.10 && e_ratio < 0.20
  total_score += 2 if t_ratio > 0.08 && t_ratio < 0.26
  total_score += 2 if a_ratio > 0.07 && a_ratio < 0.20
  total_score += 2 if o_ratio > 0.05 && o_ratio < 0.20
  total_score += 4 if space_ratio > 0.1 && space_ratio < 0.4

  # capital_ratio = txt.scan(/[ABCDEFGHIOUT]/).count / txt_length
  # total_score += 4 if capital_ratio > 0 && capital_ratio < 0.2

  return total_score
end

# Lower is better. Works better with longer messages.
def score_text_two(text)
  txt = text.downcase
  txt_length = txt.length.to_f
  total_score = 0

  ALL_LETTERS.each_with_index do |l, i|
    l_freq = (txt.count(l) / txt_length) * 100
    total_score += (l_freq - CHAR_FREQ[i]).abs
  end

  space_ratio = txt.scan(/.\s./).count / txt_length
  total_score += ((space_ratio * 100) - 14.0).abs

  return total_score
end
