require 'prawn'
require_relative 'interleave2of5'

i2o5 = Interleave2of5.new("24125")
code = i2o5.encode.code
barcode = i2o5.barcode(x: 15, width:1, factor: 2, height: 40)

pdf = Prawn::Document.new(page_size: "A4")
height = pdf.bounds.height
width  = pdf.bounds.width

label_height = height / 10
label_width = 270

y = height
x = 0

height.step(label_height, -label_height) do |y|
  0.step(label_width, label_width) do |x|
    pdf.bounding_box([x,y], width: label_width, height: label_height) do
      pdf.text("Description of item to be sold")
      pdf.dash(2, space: 2, phase: 0)
      pdf.transparent(0.5) { pdf.stroke_bounds }
      barcode = i2o5.encode.to_pdf(pdf, 
                                   height: 40, 
                                   width: 1, 
                                   factor: 2, 
                                   bearer: :frame)
      pdf.bounding_box([barcode[:total_width], barcode[:total_height]],
                        width: label_width - barcode[:total_width]) do
        pdf.table([["Size:", "XXL"], ["Price:", "2.50"]], 
                  cell_style: {borders: []})
      end
    end
  end
end
pdf.render_file("test.pdf")
