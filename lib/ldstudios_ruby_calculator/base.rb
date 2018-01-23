# The MIT License (MIT)

# Copyright (c) 2017 LD Studios, LLC

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

require 'active_model' unless defined? Rails

module LdstudiosRubyCalculator
  class Base
    include ActiveModel::Model

    # Add a memoized method to any Calculator class
    # Lets you declare methods with a Rspec `let` like DSL:
    #
    # Example:
    # class Calculator::Simple < Calculator::Base
    #   attr_accessor :left, :right
    #   calculate(:sum) { left + right }
    #   calculate(:difference) { left - right }
    #   calculate(:product) { left * right }
    #   calculate(:quotient) { left / right }
    #   calculate(:average) { sum / 2 }
    # end
    #
    # This lets you calculate basic arithmetic between two values
    #   using the defined Blocks
    #
    #  Calculator::Simple.new(left: 1, right: 1).sum        => 2
    #  Calculator::Simple.new(left: 4, right: 1).difference => 3

    def self.calculate(name, &block)
      instance_variable_set "@#{name}".to_sym, nil
      define_method name.to_s do
        unless block_given?
          Rails.logger.debug("CALCULATOR - calculating #{name.to_s}  - result 0") if defined? Rails
          return 0
        else
          ivar = instance_variable_get("@#{name}".to_sym) || instance_variable_set("@#{name}".to_sym, instance_exec(&block))
          Rails.logger.debug("CALCULATOR - calculating #{name.to_s}  - result #{ivar.to_f}") if defined? Rails
          return ivar
        end
      end
    end

    #This is kind of weird but it nullifies the calculated value by looking at all the instance variables that exist
    #then cross referencing the instance variable setter method against the list of known public methods.
    # If the instance variable has a setter method, then its from the `attr_accessor` list and should not be reset.
    # If the instance variable doesn't have a setter method, then it was set by the `calculate` method above.
    # There's probably a better way to do this.  The `calculate` method could maintain an array of known calculations
    # (ie an array of name symbols) that this method reads.
    def clear_cached_calculations!
      instance_variables.each do |ivar|
        unless public_methods.include?("#{ivar.to_s.gsub('@', '')}=".to_sym)
          instance_variable_set ivar, nil
        end
      end
      self
    end
  end
end
