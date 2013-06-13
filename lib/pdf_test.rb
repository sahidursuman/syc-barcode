require 'prawn'
require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/png_outputter'

require_relative 'interleave2of5'

i2o5 = Interleave2of5.new("00317")
code = i2o5.encode.code
barcode = i2o5.barcode(x: 15, width:1, factor: 2, height: 40)

=begin
barcodes = Barby::Code25Interleaved.new("00317")
barcodes.include_checksum = true
puts barcodes.inspect
puts barcodes.data_encoding
puts barcodes.to_png.inspect
barcode_png = barcodes.to_png

File.open("barcode.png", 'w') { |f| f.puts(barcodes.to_png(height: 50)) }
=end

pdf = Prawn::Document.new(page_size: "A4")
#pdf.text(code)
#pdf.text(barcode.inspect)

height = pdf.bounds.height
width  = pdf.bounds.width

#pdf.text("height: #{height} - width: #{width}")

label_height = height / 10
label_width = 270

y = height
x = 0

#pdf.font "Courier", style: :normal
height.step(label_height, -label_height) do |y|
  0.step(label_width, label_width) do |x|
    pdf.bounding_box([x,y], width: label_width, height: label_height) do
      pdf.text("Das ist eine Beschreibung fuer den Artikel der zu verkaufen ist")
      pdf.dash(2, space: 2, phase: 0)
      pdf.transparent(0.5) { pdf.stroke_bounds }
      barcode = i2o5.encode.to_pdf(pdf, height: 40, width: 1, factor: 2, bearer: :frame)
      puts barcode.inspect
#      pdf.image "barcode.png"
      pdf.bounding_box([barcode[:total_width], barcode[:total_height]],
                        width: label_width - barcode[:total_width]) do
        pdf.table([["Size:", "XXL"], ["Price:", "2.50"]], 
                  cell_style: {borders: []})
      end
    end
  end
end
=begin
barcode[:bars].each do |b|
  pdf.line_width = b[:width]
  pdf.stroke { pdf.vertical_line barcode[:y], 
                                 barcode[:y] + barcode[:height], 
                                 at: b[:x] }
end
=end
pdf.render_file("test.pdf")
