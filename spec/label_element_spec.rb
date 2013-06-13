require 'spec_helper'

describe "Label Element" do

  it "should create a text label element object" do
    label = TextElement.new(x: 0, y: 0, width: 200, 
                            text: { style: { size: 20, align: :left },
                                    description: "Description of the label",
                                    max_lines: 2 })
  end

  it "should create a tabel label element object" do
    label = TableElement.new(x:210, y:0, width: 200, 
                             table: {style: [{ size: 20, font: [:bold] }, 
                                             { size: 20, font: [:regular] }],
                                     rows: [["Size:", "XXL"], 
                                            ["Price:", "2.50"]] })
  end

  it "should create a barcode label element object" do
    barcode = Interleave2of5.new("01234").encode.barcode
    label = BarcodeElement.new(x: 0, y: 200, width: barcode[:width],
                               barcode: barcode)
  end

end
