# frozen_string_literal: true

require 'pry'
require 'RSpec'

# Calculator
class Calculator
  MULTIPLICATION_OP = '*'
  DIVISION_OP       = '/'
  ADDITION_OP       = '+'
  SUBTRACTION_OP    = '-'

  private
  def all_operators
    [MULTIPLICATION_OP, DIVISION_OP, ADDITION_OP, SUBTRACTION_OP]
  end

  private
  def precedence
    [[MULTIPLICATION_OP, DIVISION_OP], [ADDITION_OP, SUBTRACTION_OP]]
  end

  private
  def reduce(tokens, precedence = 0)
    # Short circuit if we've reduced all the way
    return tokens if tokens.length == 1 || precedence >= self.precedence.length

    operators = self.precedence[precedence]

    tokens.each.with_index do |token, index|
      reduce(tokens, precedence + 1) if index == tokens.length - 1
      next unless operators.include? token

      if token == MULTIPLICATION_OP
        result = tokens[index - 1].to_f * tokens[index + 1].to_f
      elsif token == DIVISION_OP
        result = tokens[index - 1].to_f / tokens[index + 1].to_f
      elsif token == ADDITION_OP
        result = tokens[index - 1].to_f + tokens[index + 1].to_f
      elsif token == SUBTRACTION_OP
        result = tokens[index - 1].to_f - tokens[index + 1].to_f
      end

      tokens[index - 1..index + 1] = result.to_s
      reduce(tokens, precedence)
    end
  end

  public
  def evaluate(expression)
    tokenized = expression.split
    reduce(tokenized, 0)[0].to_f
  end
end

RSpec.describe Calculator do
  it 'evalutes expressions with the correct order of operations' do
    c = Calculator.new
    expect(c.evaluate('2 * 3 * 4 + 2')).to eq(26.0)
    expect(c.evaluate('3 * 4 + 5 / 2')).to eq(14.5)
  end
end
