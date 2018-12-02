module ReadableRailsLog

  class SqlDeNormalizer

    def self.effect(sql)
      main_query, terms = extract_terms( sql )
      return sql if terms.nil?

      terms = JSON.parse( terms )

      main_query.gsub(%r{(\$)(\d)}) do
        value = terms[$2.to_i-1][1]
        value.is_a?(Integer) ? value : "'#{value}'"
      end
    end

    def self.extract_terms(sql)
      match = sql.match( %r{(.*)\s\s(\[\[.*\]\])} )
      match.captures if match
    end
  end
end
