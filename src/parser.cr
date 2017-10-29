

module DA_STYLE

  class Parser

    @@SINGLE_LINE_FUNCS = %w(include)
    @@SINGLE_LINE_FUNCS_PATTERN = /^#{@@SINGLE_LINE_FUNCS.join("|")}\(/
    @@FAMILY = {} of String => Bool
    macro family(name)
      familys(name)
    end # === macro family

    macro familys(*args)
      {% for x in args %}
        @@FAMILY[{{x}}] = true
      {% end %}
    end

    familys "background", "font"

    getter origin : String
    getter io : IO::Memory = IO::Memory.new
    getter tokens : Array(String)
    getter stack : Parser::Stack
    getter file_dir : String

    def self.split(str : String)
      str.split(/[[:cntrl:]\ \s]+/)
    end # === def self.split

    def initialize(@origin, @file_dir)
      @tokens = ["a"]
      @tokens = Parser.split(@origin)
      @stack  = Parser::Stack.new(@tokens)
    end # === def initialize

    class Stack
      @index : Int32 = 0
      @len   : Int32
      @origin : Array(String)
      @private_vars = {} of String => String
      getter opens : Array(Symbol) = [] of Symbol
      getter closes : Array(Symbol) = [] of Symbol
      getter assignments = {} of String => String
      getter previous : Array(String) = [] of String

      def initialize(@origin)
        @len = @origin.size
      end # === def initialize

      def unshift(arr : Array(String))
        @origin[@index + 1, 0] = arr
        @len = @len + arr.size
      end # === def unshift

      def open?
        !@opens.empty?
      end

      def open
        @opens.last
      end

      def open(name : Symbol)
        @opens << name
      end

      def close
        val = @opens.pop
        @closes << val
        val
      end # === def close

      def close(expected : Symbol)
        actual = close
        if actual != expected
          raise Exception.new("Expecting to close #{expected}, but instead cloasing #{actual}")
        end
        actual
      end

      def fin?
        @index >= (@len - 1)
      end

      def private(key : String)
        @private_vars[key]
      end

      def private_delete(key)
        @private_vars.delete(key)
      end

      def private?(key : String)
        @private_vars.has_key?(key)
      end

      def private(key : String, val : String)
        if @private_vars.has_key?(key)
          raise Exception.new("Already defined: #{key.inspect} = #{@private_vars[key]?.inspect} (new value: #{val.inspect})")
        end
        @private_vars[key] = val
      end

      def move
        raise Exception.new("Can't move to next item. Finished.") if fin?
        @index += 1
        current
      end

      def current
        @origin[@index]
      end

      def assign(name : String, val : String)
        @assignments[name.upcase] = val
      end # === def assign

      def grab_through(str : String, arr : Array(String))
        while !fin? && current.index(str) == nil
          arr.push(current)
          move
        end

        if current == str
          return arr
        end

        if current.index(str) != nil
          arr.push current.rstrip(str)
          return arr
        end

        raise Exception.new("Missing token: #{str}")
      end

      def grab_until_token_is(token : String)
        while !fin? && current != token
          previous.push(current)
          move
        end
        if current != token
          raise Exception.new("Missing token: #{token}")
        end
        return previous
      end # === def grab_until_token_is

    end # === class Stack

    def is_valid_selector?(raw : String)
      codepoints = raw.codepoints
      if codepoints.first == '@'.hash
        return raw =~ /@[a-z]+\ *\([a-z\,\/\:\ 0-9\,\_\-]+\)/i
      end

      invalid = raw.codepoints.find { |point|
        case point
        when ('a'.hash)..('z'.hash),
          ('A'.hash)..('Z'.hash),
          ('0'.hash)..('9'.hash),
          '#'.hash, '-'.hash, '.'.hash, ','.hash,
          ' '.hash
          false
        else
          point
        end
      }
      return !invalid
    end # === def is_valid_selector?

    def is_valid_property_name?(raw : String)
      invalid = raw.codepoints.find { |point|
        case point
        when ('a'.hash)..('z'.hash),
          ('A'.hash)..('Z'.hash),
          ('0'.hash)..('9'.hash),
          '-'.hash
          false
        else
          point
        end
      }
      !invalid
    end # === def is_valid_property_name?

    def is_valid_property_value?(raw : String)
      invalid = raw.codepoints.find { |point|
        case point
        when ('a'.hash)..('z'.hash),
          ('A'.hash)..('Z'.hash),
          ('0'.hash)..('9'.hash),
          '#'.hash, '-'.hash, '('.hash, ')'.hash, ' '.hash,
          '%'.hash, '{'.hash, '}'.hash
          false
        else
          point
        end
      }
      !invalid
    end # === def is_valid_property_value?

    def is_valid_var_key?(raw : String)
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
    end

    # def whitespace!
      # case name
      # when :selector
      #   case
      #   when closes.empty?
      #     :do_nothing
      #   when closes.last == :var
      #     io << "\n"
      #   end
      # end
    # end # === def whitespace!

    def start_family
      return false if stack.previous.size != 1
      return false if !@@FAMILY.has_key?(stack.previous.last || "")
      family = stack.previous.pop
      if stack.private?("family")
        raise Exception.new("Family has already been set: OLD: #{family} NEW: #{family}")
      end
      stack.open(:family)
      stack.private("family", family)
    end

    def start_selector
      return :family if start_family

      selector = stack.previous.join(" ")
      stack.private("selector", selector)
      if !is_valid_selector?(selector)
        raise Exception.new("Invalid selector: #{selector.inspect}")
      end

      if !stack.closes.empty?
        if stack.closes.last != :var
          io << "\n"
        end
      end

      spaces(:selector)
      stack.open(:selector)
      io << stack.private("selector") << " {"
      stack.private_delete("selector")
      stack.previous.clear
    end

    def spaces(*args)
      stack.opens.select { |x| args.includes?(x) }.size.times do |i|
        io << "  "
      end
      io
    end # === def spaces

    def finish_selector
      if stack.private?("family")
        stack.private_delete("family")
        return stack.close(:family)
      end
      stack.close(:selector)
      io << "\n"
      spaces(:selector)
      io << "}"
      stack.private_delete("selector")
    end # === def finish_selector

    def run_css_call(arr : Array(String))
      combined = arr.join("")
      if !combined.match(/^([^\(]+)\(\ *['"]([a-z\/\.A-Z0-9\_\-]+)['"]\ *\)$/)
        raise Exception.new("Invalid function call: #{combined.inspect}");
      end
      name = $1
      val  = $2
      case name
      when "include"
        stack.unshift Parser.split(File.read(File.expand_path(val, @file_dir)))
      else
        raise Exception.new("Unknown function call #{name.inspect}: #{combined.inspect}");
      end
    end

    def run_assignment
      stack.move
      next_value = stack.grab_through(";", [] of String).join(" ");
      key        = (stack.previous.size > 0) ? stack.previous.pop : ""

      if key.empty?
        raise Exception.new("Invalid assignment: [empty] = #{next_value.inspect}")
      end

      if next_value.empty?
        raise Exception.new("Invalid assignment: #{stack.previous.join(" ")} = [empty]")
      end

      if !is_valid_var_key?(key)
        raise Exception.new("Assignment key contains invalid characters: #{key.inspect} = #{next_value.inspect};")
      end

      if !is_valid_property_value?(next_value)
        raise Exception.new("Assignment value contains invalid characters: #{key.inspect} = #{next_value.inspect};")
      end

      stack.assign(key, next_value)
      stack.previous.clear
      stack.closes << :var
    end # === def run_assignment

    def run_property
      style = stack.current.gsub(":", "")

      stack.move
      value = stack.grab_through(";", [] of String).join(" ")

      if style.empty?
        raise Exception.new("Invalid property name: [empty]: #{value}")
      end

      if value.empty?
        raise Exception.new("Invalid property assignment: #{style}: [empty]")
      end

      if !is_valid_property_name?(style)
        raise Exception.new("Invalid characters in property name: #{style}: #{value}")
      end

      value = replace_assignments(value)
      if !is_valid_property_value?(value)
        raise Exception.new("Invalid characters in value: #{style}: #{value}")
      end

      if stack.private?("family")
        style = "#{stack.private("family")}-#{style}"
      end

      value = value.gsub(";", "")
      io << "\n"
      spaces(:selector)
      io << style << ": " << value << ";"
    end # === def run_property

    def to_css
      while !stack.fin?
        t = stack.current

        case

        when t == ""
          :ignore

        when t == "="
          run_assignment

        when t == "{"
          start_selector

        when t == "}"
          finish_selector

        when t.rindex(":") == (t.size - 1)
          run_property

        when t.index("@") == 0
          stack.grab_until_token_is("{")
          start_selector
        # when t == "{"
        #   stack << t
        # when t == "}"
        #   stack << t
        # when t[":"]?
        #   stack << t
        # when t[";"]?
        #   stack << t

        when t.index(@@SINGLE_LINE_FUNCS_PATTERN) == 0
          css_call = stack.grab_through(";", [] of String)
          run_css_call(css_call)

        # when t.index(@@FUNCS_PATTERN) == 0
        #   css_call = stack.grab_through(")", [] of String)
        #   run_css_call(css_call)
        else
          stack.previous.push t
        end

        stack.move
      end

      if !stack.previous.empty?
        raise Exception.new("Unknown values: #{stack.previous.join(" ").inspect}")
      end

      if stack.open?
        raise Exception.new("Missing closing } for: #{stack.open}")
      end

      @io.to_s 
    end # === def to_css

    def replace_assignments(raw : String)
      prev = ""
      current = raw
      while (prev != current)
        prev = current
        current = replace_assignments__(current)
      end
      current
    end # === def replace

    def replace_assignments__(raw : String)
      raw.gsub(/\{\{\ *([^\}]+)\ *\}\}/) do |match|
        key = $1.upcase
        value = stack.assignments[key]?
        raise Exception.new("Variable not found: #{key}") unless value
        value
      end
    end # === def replace

    def self.run_include(raw : String, dir : String) : String
      prev = ""
      current = raw
      while (prev != current)
        prev = current
        current = run_include__(current, dir)
      end
      current
    end # === def self.run_include

    def self.run_include__(raw : String, dir : String)
      raw.gsub(/^\ *include\(\ *['"]([a-z\/\.A-Z0-9\_\-]+)['"]\ *\)$/) do |match|
        file = File.expand_path($1, dir)
        raise Exception.new("File not found: #{file} via include(\"$1\")") unless File.exists?(file)
        File.read(file)
      end
    end

  end # === class Parser

end # === module DA_STYLE
