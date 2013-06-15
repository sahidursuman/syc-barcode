# Checked attributes are checked for validity
module CheckedAttributes

  # Includes base
  def self.included(base)
    base.extend ClassMethods
  end

  # Creates the attr_checked method
  module ClassMethods

    # attr_checked evaluates whether the value is valid
    def attr_checked(attribute, &validation)
      define_method "#{attribute}=" do |value|
        raise ArgumentError unless validation.call(value)
        instance_variable_set("@#{attribute}", value)
      end

      define_method attribute do
        instance_variable_get "@#{attribute}"
      end
    end
  end
end
