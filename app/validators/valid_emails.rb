class ValidEmails < Grape::Validations::Base
  EMAIL_REGEXP = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\Z/i

  def validate_param!(attr_name, params)
    unless params[attr_name].all? { |v| v =~ EMAIL_REGEXP }
      fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: 'must only consist of valid email addresses.'
    end
  end
end
