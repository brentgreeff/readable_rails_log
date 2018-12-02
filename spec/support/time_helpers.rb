require "timecop"
require "chronic"

module TimeHelpers

  def freeze_time(&blk)
    Timecop.freeze( Chronic.parse('5th January'), &blk )
  end
end
