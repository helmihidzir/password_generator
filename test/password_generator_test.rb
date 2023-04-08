require 'minitest/autorun'
require_relative '../password_generator'

class PasswordGeneratorTest < Minitest::Test
  def test_generate_password_with_default_options
    generator = PasswordGenerator.new
    password = generator.generate
    assert_instance_of String, password
    assert_match /[a-z]/, password
    assert_match /[A-Z]/, password
    assert_match /[0-9]/, password
    assert_match /[!#$%&()*+@^]/, password
    assert_operator password.length, :>=, PasswordGenerator::RECOMMENDED_PASSWORD_LENGTH
  end

  def test_generate_password_with_no_capital_letters
    generator = PasswordGenerator.new(use_capital_letters: false)
    password = generator.generate
    assert_instance_of String, password
    assert_match /[a-z]/, password
    refute_match /[A-Z]/, password
    assert_match /[0-9]/, password
    assert_match /[!#$%&()*+@^]/, password
    assert_operator password.length, :>=, PasswordGenerator::RECOMMENDED_PASSWORD_LENGTH
  end

  def test_generate_password_with_no_numbers
    generator = PasswordGenerator.new(use_numbers: false)
    password = generator.generate
    assert_instance_of String, password
    assert_match /[a-z]/, password
    assert_match /[A-Z]/, password
    refute_match /[0-9]/, password
    assert_match /[!#$%&()*+@^]/, password
    assert_operator password.length, :>=, PasswordGenerator::RECOMMENDED_PASSWORD_LENGTH
  end

  def test_generate_password_with_custom_options
    generator = PasswordGenerator.new(use_small_letters: false, use_symbols: false)
    password = generator.generate
    assert_instance_of String, password
    refute_match /[a-z]/, password
    assert_match /[A-Z]/, password
    assert_match  /[0-9]/, password
    refute_match /[!#$%&()*+@^]/, password
    assert_operator password.length, :>=, PasswordGenerator::RECOMMENDED_PASSWORD_LENGTH
  end

  def test_validate_with_no_characters_selected
    generator = PasswordGenerator.new(use_small_letters: false, use_capital_letters: false, use_numbers: false, use_symbols: false)
    assert_raises InvalidConfigurationError do
      generator.validate
    end
  end

  def test_validate_with_less_than_recommended_length
    generator = PasswordGenerator.new(min_length: 8)
    assert_raises InvalidConfigurationError do
      generator.validate
    end
  end
end