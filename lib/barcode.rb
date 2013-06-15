require_relative 'visual'

# Barcode is the base class for barcodes it requires subclasses to implement
# #encode and #barcode
class Barcode

  include Visual

  # Encodes the string into a barcode
  def encode
    raise "needs to be implemented by sub class"
  end

  # Creates the coordinates for a barcode
  def barcode
    raise "needs to be implemented by sub class"
  end

end
