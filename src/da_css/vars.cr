
module DA_CSS

    struct Vars

      @vars = {} of String => String

      def initialize(@vars)
      end # === def initialize

      def initialize
      end # === def initialize

      def dup
        Vars.new(@vars.dup)
      end

      def has?(key : String)
        @vars.has_key?(key)
      end

      def get(key : String)
        @vars[key]
      end # === def var

      def update!(key : String, val : String)
        @vars[key] = val
      end # === def update

      def set(key : String, val : String)
        if @vars.has_key?(key)
          raise Exception.new("Already defined: #{key.inspect} = #{@vars[key]?.inspect} (new value: #{val.inspect})")
        end
        @vars[key] = val
      end

      def delete(key : String)
        raise Exception.new("Key not found: #{key.inspect}") unless has?(key)
        @vars.delete(key)
      end # === def delete

      def self.is_valid_key?(raw : String)
        raw.each_char { |char|
          case char
          when 'a'..'z', 'A'..'Z', '0'..'9', '-', '_'
            return false
          end
        }
      end # === def self.is_valid_key?

    end # === class Vars

end # === module DA_CSS

