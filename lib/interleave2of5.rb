require_relative 'checked_attributes'
require_relative 'barcode'

class Interleave2of5 < Barcode
  include CheckedAttributes

  OPTIONS = {
    x: 0,
    y: 0,
    width: 1,
    factor: 2,
    quiet: 20,
    bearer: :none, # possible selections :none, :frame, :rule
    bearer_width: 1,
    top_margin: 10,
    bottom_margin: 10,
    height: 50
  }

  SYMBOLOGY = { 
    start: "0000", 
    stop:  "100", 
    "0" => "00110", 
    "1" => "10001", 
    "2" => "01001",
    "3" => "11000",
    "4" => "00101",
    "5" => "10100",
    "6" => "01100",
    "7" => "00011",
    "8" => "10010",
    "9" => "01010" 
  }
                
  attr_checked  :value do
    |v| v.scan(/\D/).empty?
  end

  attr_accessor :check, :options
  attr_reader   :code, :encodable, :graph

  def initialize(value, check=true)
    raise ArgumentError unless value.scan(/\D/).empty?
    @value = value
    @check = check
  end

  def to_s
    "value: #{@value}\n"+
    "options: #{@options.inspect}\n"+
    "encodable: #{@encodable ? @encodable : '#encode not run yet'}\n"+
    "code: #{@code}\n"
  end

  def encode
    @code = ""
    add_check_digit_and_ensure_even_digit_size
    0.step(@encodable.size - 1, 2) do |i|
      first = SYMBOLOGY[@encodable[i]]
      second = SYMBOLOGY[@encodable[i+1]]
      @code += 0.upto(4).map { |j| first[j] + second[j] }.join
    end 
    @code = SYMBOLOGY[:start] + @code + SYMBOLOGY[:stop]
    self
  end

  def barcode(options={})
    @options = OPTIONS.merge(options)
    
    y_offset = @options[:bearer] != :none  ? @options[:bearer_width] : 0 
    x_offset = @options[:bearer] == :frame ? @options[:bearer_width] : 0 

    @graph = { 
      total_width: 2 * x_offset + 2 * @options[:quiet],
      total_height: @options[:height] + 2 * y_offset + @options[:top_margin] + 
                    @options[:bottom_margin],
      x: @options[:x] + @options[:quiet] + x_offset, 
      y: @options[:y] + @options[:bottom_margin] + y_offset,
      height: @options[:height],
      bars: [],
      graph_width: 0
    }

    x = @graph[:x]
    
    @code.each_char.with_index do |v, i|
      width = @options[:width]
      if v == "1"
        width = width * @options[:factor]
      end
      @graph[:bars] << { x: x, width: width } if i.even?
      x += width
      @graph[:graph_width] += width
    end

    @graph[:total_width] += @graph[:graph_width]

  end

  private
    
    def add_check_digit_and_ensure_even_digit_size
      reverse_value = @value.split('').reverse
      @check_digit = 10 - reverse_value.each_with_index.collect do |v, i|
        i.even? ? v.to_i * 3 : v.to_i
      end.inject(:+) % 10 if @check
      @encodable = @value + (@check ? @check_digit.to_s : "")
      @encodable = "0" + @encodable if @encodable.size.odd?
      @encodable
    end

end
