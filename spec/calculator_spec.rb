# frozen_string_literal: true

require 'RSpec'
require './calculator'

RSpec.describe Calculator do
  c = Calculator.new

  it 'evaluates simple expressions correctly' do
    expect(c.evaluate('2 * 3')).to eq((2.0 * 3.0).to_s)
  end

  it 'evaluates complex expressions with the correct order of operations' do
    expect(c.evaluate('3 * 4 + 5 / 2 - 4')).to eq((3.0 * 4.0 + 5.0 / 2.0 - 4.0).to_s)
  end

  it 'ignores whitespace' do
    expect(c.evaluate('3*4+5/2-4')).to eq((3.0 * 4.0 + 5.0 / 2.0 - 4.0).to_s)
  end

  it 'handles exponents' do
    expect(c.evaluate('3 ^ 4 + 5 / 2 - 4')).to eq((3.0**4.0 + 5.0 / 2.0 - 4.0).to_s)
  end

  it 'handles float inputs with or without leading 0' do
    expect(c.evaluate('2.5 + .5 + 2.0')).to eq((2.5 + 0.5 + 2.0).to_s)
  end
end
