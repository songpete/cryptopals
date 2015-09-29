
# Higher score means text is more likely to be English. Based on letter frequency, space ratio and vowels
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
