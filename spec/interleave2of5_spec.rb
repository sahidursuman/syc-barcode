require 'spec_helper'

describe "Interleave2of5" do

  before do
    @i2o5 = Interleave2of5.new("01234")
  end

  subject { @i2o5 }

  it { should respond_to(:value) }
  it { should respond_to(:options) }
  it { should respond_to(:code) }
  it { should respond_to(:graph) }

  it "should raise exception if value is not a number" do
    expect { @i2o5.value = "A" }.to raise_exception(ArgumentError)
    expect { @i2o5.value = "12a3b"}.to raise_exception(ArgumentError)
    expect { Interleave2of5.new("12a3bc4") }.
      to raise_exception(ArgumentError)
  end

  it "should calculate barcode value with check digit" do
    @i2o5.value = "1"
    @i2o5.encode.should eq "00001101000010100"
    @i2o5.code.should eq "00001101000010100"
  end

  it "should calculate barcode value without check digit" do
    @i2o5.value = "1"
    @i2o5.options[:check] = false
    @i2o5.encode.should eq "00000100101001100"
  end

  it "should calculate barcode graph" do
    @i2o5.value = "1"
    @i2o5.encode
    @i2o5.barcode.size.should eq 4
    @i2o5.barcode[:bars].size.should eq 9
  end

  it "should accecpt options in barcode" do
    @i2o5.encode.should eq "0000010010100101110000100001100011100"
    @i2o5.barcode(width: 3, height: 70, factor: 2.4).size.should eq 4
    puts @i2o5
  end

end
