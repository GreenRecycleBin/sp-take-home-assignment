class Size < Grape::Validations::Base
  def validate_param!(attr_name, params)
    unless params[attr_name].size == Integer(@option)
      fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: "must consist of exactly #{@option} elements."
    end
  end
end
