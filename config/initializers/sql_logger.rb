if Rails.env.development?
  logger = Logger.new STDOUT
  logger.formatter = PrettyDbFormatter.new
  ActiveRecord::Base.logger = logger
end
