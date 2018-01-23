# The MIT License (MIT)

# Copyright (c) 2018 LD Studios, LLC

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


require 'spec_helper'

$simple_calculator_count = 0 #globally initialize a count value

class LdstudiosRubyCalculator::Simple < LdstudiosRubyCalculator::Base
  attr_accessor :left, :right
  calculate(:sum)        { left + right }
  calculate(:difference) { left - right }
  calculate(:product)    { left * right }
  calculate(:quotient)   { left / right }
  calculate(:average)    { sum / 2 }
  calculate(:memoized_count) { $simple_calculator_count = $simple_calculator_count + 1 }
end

#Might need this to define the DSL for more complex scenarios
#class Calculator::Financial < Calculator::Base
#end

RSpec.describe LdstudiosRubyCalculator::Base, type: :model do

  subject { LdstudiosRubyCalculator::Simple.new(left: 3, right: 3) }

  it { expect(subject.sum).to        eq(6) }
  it { expect(subject.difference).to eq(0) }
  it { expect(subject.product).to    eq(9) }
  it { expect(subject.quotient).to   eq(1) }
  it { expect(subject.average).to    eq(3) }

  it "should memoize values" do
    #First time should increment 0 to 1
    expect(subject.memoized_count).to eq(1)
    #Second time should return the memoized value and not increment
    expect(subject.memoized_count).to eq(1)
  end

  describe "#calculate" do
    subject(:trainable_calculator) { described_class }
    let!(:calculated_method_name) { :two_times_three }
    before do
      trainable_calculator.calculate(calculated_method_name) do
        2 * 3
      end
    end
    it "should define an instance method of the same name" do
      expect(trainable_calculator.new).to respond_to(calculated_method_name)
    end
  end
end