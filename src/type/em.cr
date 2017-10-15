
require "./positive_negative"
module DA_STYLE

  module EM
    def em(i : Int32 | Float64)
      DA_STYLE::VALUE.new("#{i}em")
    end # === def em
  end # === module EM

end # === module DA_STYLE
