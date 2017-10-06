class ValidEmail < Grape::Validations::Base
  def validate_param!(attr_name, params)
    unless params[attr_name] =~ Validator::EMAIL_REGEXP
      fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: 'must be a valid email address.'
    end
  end
end
