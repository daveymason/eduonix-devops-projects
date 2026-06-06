LOWERCASE = ('a'..'z').to_a.freeze
UPPERCASE = ('A'..'Z').to_a.freeze
DIGITS = ('0'..'9').to_a.freeze
SYMBOLS = %w[! @ # $ % ^ & * ( ) - _ = + ?].freeze

def prompt_length
  print 'Password length (minimum 8): '
  input = gets&.strip
  length = input.to_i
  length >= 8 ? length : 12
end

def build_password(length)
  required_characters = [
    LOWERCASE.sample,
    UPPERCASE.sample,
    DIGITS.sample,
    SYMBOLS.sample
  ]

  all_characters = LOWERCASE + UPPERCASE + DIGITS + SYMBOLS
  remaining_length = [length - required_characters.length, 0].max
  remaining_characters = Array.new(remaining_length) { all_characters.sample }

  (required_characters + remaining_characters).shuffle.join
end

puts 'Ruby Password Generator'
puts 'Each password includes lowercase, uppercase, numbers, and symbols.'

loop do
  password_length = prompt_length
  puts "Generated password: #{build_password(password_length)}"

  print 'Generate another password? (y/n): '
  answer = gets&.strip&.downcase
  break unless answer == 'y'
end

puts 'Done.'