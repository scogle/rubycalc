# frozen_string_literal: true

# Calculator class
class Calculator
  EXPONENT_OP       = '^'
  MULTIPLICATION_OP = '*'
  DIVISION_OP       = '/'
  ADDITION_OP       = '+'
  SUBTRACTION_OP    = '-'

  # An array of regular expressions that encodes the order of operations
  def order_of_operations
    [
      # /(\d*\.?\d*) *(\^) *(\d*\.?\d*)/, # exponents
      Regexp.new("(\\d*\\.?\\d*) *(\\#{EXPONENT_OP}) *(\\d*\\.?\\d*)"),
      # /(\d*\.?\d*) *([*\/]) *(\d*\.?\d*)/, # multiplication or division
      Regexp.new("(\\d*\\.?\\d*) *([#{MULTIPLICATION_OP}\\#{DIVISION_OP}]) *(\\d*\\.?\\d*)"),
      # /(\d*\.?\d*) *([+-]) *(\d*\.?\d*)/, # addition or subtraction
      Regexp.new("(\\d*\\.?\\d*) *([#{ADDITION_OP}#{SUBTRACTION_OP}]) *(\\d*\\.?\\d*)")
    ]
  end

  def get_callable(op)
    if op == EXPONENT_OP
      proc { |x, y| x**y }
    elsif op == MULTIPLICATION_OP
      proc { |x, y| x * y }
    elsif op == DIVISION_OP
      proc { |x, y| x / y }
    elsif op == ADDITION_OP
      proc { |x, y| x + y }
    elsif op == SUBTRACTION_OP
      proc { |x, y| x - y }
    end
  end

  # Expression class encapsulates expression behavior
  class Expression
    attr_reader :left, :right, :operator
    def initialize(calculator:, left:, right:, operator:)
      @left = left.to_f
      @right = right.to_f
      @operator = calculator.get_callable(operator)
    end

    def result
      operator.call(left, right)
    end
  end

  def get_expression(arr)
    # Takes a regex result, index 0 is complete expression
    Expression.new(calculator: self, left: arr[1], right: arr[3], operator: arr[2])
  end

  def reduce(expression, current_pass = 0)
    # Short circuit if we've reduced all the way
    return expression if current_pass >= order_of_operations.length

    match = expression.match(order_of_operations[current_pass])
    if match
      parsed_exp = get_expression match
      expression = expression.sub(match[0], parsed_exp.result.to_s)
      reduce(expression, current_pass)
    else
      reduce(expression, current_pass + 1)
    end
  end

  def evaluate(expression)
    reduce(expression, 0)
  end
end
