
require "da_uri"
module DA_STYLE

  class Parser

    module Clean_Url

      extend DA_URI
      extend self

      def allowed_scheme?(s)
        case s
        when "http", "https"
          return true
        end
        false
      end

    end # === class Clean_Url

  end # === class Parser

end # === module DA_STYLE
