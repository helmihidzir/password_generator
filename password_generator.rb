class PasswordGenerator
  SYMBOLS = ['!', '#', '$', '%', '&', '(', ')', '*', '+', '@', '^']
  RECOMMENDED_PASSWORD_LENGTH = 12

  attr_accessor :use_small_letters, :use_capital_letters, :use_numbers, :use_symbols, :min_length

  def initialize(options = {})
    @use_small_letters = options.fetch(:use_small_letters, true)
    @use_capital_letters = options.fetch(:use_capital_letters, true)
    @use_numbers = options.fetch(:use_numbers, true)
    @use_symbols = options.fetch(:use_symbols, true)
    @min_length = options.fetch(:min_length, RECOMMENDED_PASSWORD_LENGTH)
  end

  def validate
    raise InvalidConfigurationError.new('Invalid configuration: Password must have at least 1 character type.') if combined_charset.empty?
    raise InvalidConfigurationError.new('Invalid configuration: Password length must be at least 12 characters or more.') if min_length < RECOMMENDED_PASSWORD_LENGTH
  end

  def generate
    validate

    password = ''
    while password.length < min_length || !meets_criteria?(password)
      password = ''
      while password.length < min_length
        password += combined_charset[rand(combined_charset.length)]
      end
    end

    password
  end

  private

  def small_charset
    ('a'..'z').to_a.join if use_small_letters
  end

  def capital_charset
    ('A'..'Z').to_a.join if use_capital_letters
  end

  def number_charset
    (0..9).to_a.join if use_numbers
  end

  def symbol_charset
    SYMBOLS.join if use_symbols
  end

  def combined_charset
    "#{small_charset}#{capital_charset}#{number_charset}#{symbol_charset}".split("").shuffle.join
  end

  def meets_criteria?(password)
    return false if use_small_letters && !password.match(/[a-z]/)
    return false if use_capital_letters && !password.match(/[A-Z]/)
    return false if use_numbers && !password.match(/[0-9]/)
    return false if use_symbols && !password.match(/[#{Regexp.escape(SYMBOLS.join(''))}]/)

    return true
  end
end

class InvalidConfigurationError < StandardError
end

generator = PasswordGenerator.new
# generator = PasswordGenerator.new(use_small_letters: false, use_capital_letters: false, use_numbers: false, use_symbols: false)
# generator = PasswordGenerator.new(use_capital_letters: false)
# generator = PasswordGenerator.new(min_length: 20)
password = generator.generate
puts password