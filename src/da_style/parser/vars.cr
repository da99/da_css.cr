
module DA_STYLE

  class Parser

    class Vars

      @vars = {} of String => String

      def initialize(@vars)
      end # === def initialize

      def initialize
      end # === def initialize

      def has?(key : String)
        @vars.has_key?(key)
      end

      def get(key : String)
        @vars[key]
      end # === def var

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

      def self.valid_key?(raw : String)
        invalid = raw.codepoints.find { |point|
          case point
          when ('a'.hash)..('z'.hash),
            ('A'.hash)..('Z'.hash),
            ('0'.hash)..('9'.hash),
            '-'.hash, '_'.hash
            false
          else
            point
          end
        }
        return !invalid
      end # === def self.valid_key?

    end # === class Vars

  end # === class Parser

end # === module DA_STYLE
