
require "da_uri"
module DA_CSS

    module Clean_Url

      extend DA_URI
      extend self

      def allowed_scheme?(s)
        false
      end

    end # === class Clean_Url

end # === module DA_CSS