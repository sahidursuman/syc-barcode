require 'prawn'

module Visual

  def to_pdf(pdf, options={})
    pdf.undash
    barcode(options)
    @graph[:bars].each do |b|
      pdf.move_to(b[:x],             @graph[:y])
      pdf.line_to(b[:x],             @graph[:y] + @graph[:height])
      pdf.line_to(b[:x] + b[:width], @graph[:y] + @graph[:height])
      pdf.line_to(b[:x] + b[:width], @graph[:y])
      pdf.line_to(b[:x],             @graph[:y])
      pdf.fill
    end
    if @options[:bearer] == :frame
      pdf.move_to(@options[:x], @graph[:y])
      pdf.line_to(@options[:x], 
                  @graph[:y] + @graph[:height])
      pdf.line_to(@options[:x] + 2 * @options[:quiet] + @graph[:graph_width],
                  @graph[:y] + @graph[:height])
      pdf.line_to(@options[:x] + 2 * @options[:quiet] + @graph[:graph_width],
                  @graph[:y]) 
      pdf.line_to(@options[:x],
                  @graph[:y])
    elsif @options[:bearer] == :rule
      pdf.move_to(@options[:x], 
                  @options[:y] + @options[:bottom_margin] + @graph[:height])
      pdf.line_to(@options[:x] + 2 * @options[:quiet] + @graph[:graph_width],
                  @options[:y] + @options[:bottom_margin] + @graph[:height])
      pdf.move_to(@options[:x] + 2 * @options[:quiet] + @graph[:graph_width],
                  @options[:y] + @options[:bottom_margin]) 
      pdf.line_to(@options[:x],
                  @options[:y] + @options[:bottom_margin])
    end
    @graph
  end

end
