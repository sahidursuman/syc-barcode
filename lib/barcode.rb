require_relative 'visual'

class Barcode

  include Visual

  def encode
    raise "needs to be implemented by sub class"
  end

  def barcode
    raise "needs to be implemented by sub class"
  end

end
