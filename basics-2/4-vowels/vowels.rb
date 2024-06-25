ALPHABET = "abcdefghijklmnopqrstuvwxyz"
VOWELS = "aeiou"

module Vowels
  def get_vowels()
    result = {}

    ALPHABET.chars.each_with_index do |letter, idx|
      if VOWELS.include? letter
        result[letter] = idx + 1
      end
    end

    result
  end
end
