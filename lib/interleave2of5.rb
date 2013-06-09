require_relative 'checked_attributes'

class Interleave2of5
  include CheckedAttributes

  OPTIONS = {
    check: true,
    width: 2,
    factor: 2,
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

  attr_accessor :options
  attr_reader   :code, :graph

  def initialize(value, options={})
    raise ArgumentError unless value.scan(/\D/).empty?
    @value = value
    @options = OPTIONS.merge(options)
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
  end

  def barcode(options={})
    @options = OPTIONS.merge(options)
    
    @graph = { 
      graph_width: 0,
      y: @options[:y] || 0,
      height: @options[:height],
      bars: []
    }

    x = 0
    
    @code.each_char.with_index do |v, i|
      width = @options[:width]
      if v == "1"
        width = width * @options[:factor]
      end
      @graph[:bars] << { x: x, width: width } if i.even?
      x += width
    end

    @graph[:graph_width] = x

    @graph
  end

  private
    
    def add_check_digit_and_ensure_even_digit_size
      reverse_value = @value.split('').reverse
      @check_digit = reverse_value.each_with_index.collect do |v, i|
        i.even? ? v.to_i * 3 : v.to_i
      end.inject(:+) % 10 if @options[:check]
      @encodable = @value + (@options[:check] ? @check_digit.to_s : "")
      @encodable = "0" + @encodable if @encodable.size.odd?
      @encodable
    end

end
