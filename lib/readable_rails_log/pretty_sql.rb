module ReadableRailsLog

  class PrettySQL

    attr_reader :multi

    def self.multiline(original)
      new( original ).multi
    end

    private

    def initialize(original)
      @multi = original

      unless insert?
        break_on_primary_keywords
        break_on_terms
        break_on_and
        break_on_join
        break_on_limit
        highlight_nested
      end
    end

    def insert?
      @multi.include? 'INSERT INTO'
    end

    def break_on_primary_keywords
      @multi.gsub!( main_keywords ) do |keyword|
        "\n#{Rainbow(keyword).cyan}\n"
      end
    end

    def main_keywords
      %r{(SELECT|FROM|WHERE|ORDER BY|GROUP BY)}
    end

    def break_on_terms
      @multi.gsub!(%r{,\s}) do
        ",\n\s"
      end
    end

    def break_on_and
      @multi.gsub!(%r{(\sAND)\s}) do
        "#{Rainbow($1).green}\n "
      end
      @multi.gsub!(%r{(\sOR)\s}) do
        "#{Rainbow($1).green}\n "
      end
      @multi.gsub!(%r{(date BETWEEN)\s}) do
        "#{$1}\n "
      end
    end

    def break_on_join
      @multi.gsub!(%r{\s(INNER JOIN|LEFT JOIN|LEFT OUTER JOIN|ON)}) do
        " #{Rainbow($1).green}\n"
      end
    end

    def break_on_limit
      @multi.gsub!(%r{\s(LIMIT \d+)}) do
        "\n#{Rainbow($1).cyan}"
      end
    end

    def highlight_nested
      @multi.gsub!(%r{\s(IN\s?\()}) do
        " #{Rainbow($1).blue}"
      end
      @multi.gsub!(%r{\s(\(EXISTS\s?\()}) do
        " #{Rainbow($1).blue}"
      end
      @multi.gsub!(%r{\s(\(NOT EXISTS\s?\()}) do
        " #{Rainbow($1).blue}"
      end
    end
  end
end
