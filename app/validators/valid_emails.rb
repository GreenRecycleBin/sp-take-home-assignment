class ValidEmails < Grape::Validations::Base
  def validate_param!(attr_name, params)
    unless params[attr_name].all? { |v| v =~ Validator::EMAIL_REGEXP }
      fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: 'must only consist of valid email addresses.'
    end
  end
end
