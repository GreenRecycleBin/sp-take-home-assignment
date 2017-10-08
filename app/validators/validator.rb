module Validator
  RELAXED_EMAIL_REGEXP = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}/i
  EMAIL_REGEXP = /\A#{RELAXED_EMAIL_REGEXP}\Z/i
end
