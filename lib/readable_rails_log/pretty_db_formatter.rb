require 'rainbow'

module ReadableRailsLog

  class PrettyDbFormatter < ::Logger::Formatter
    include ActiveSupport::TaggedLogging::Formatter

    def call(severity, timestamp, progname, msg)
      format("%s %s\n",
        Rainbow( get_time(timestamp) ).red,
        format_sql(
          denormalize_sql( msg )
        )
      )
    end

    private

    def get_time(timestamp)
      timestamp.strftime('%H:%M:%S:%L')
    end

    def denormalize_sql(original)
      SqlDeNormalizer.effect( original )
    end

    def format_sql(original)
      "#{PrettySQL.multiline( original )}\n---"
    end
  end
end
