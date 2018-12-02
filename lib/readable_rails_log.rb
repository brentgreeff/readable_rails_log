require "readable_rails_log/version"

require 'active_support'
require 'json'

module ReadableRailsLog
  extend ActiveSupport::Autoload

  autoload :PrettyDbFormatter
  autoload :SqlDeNormalizer
  autoload :PrettySQL
end
