
require "./parser/stack"
require "./parser/vars"

module DA_STYLE

  class Parser

    @@SINGLE_LINE_FUNCS         = %w(include)
    @@SINGLE_LINE_FUNCS_PATTERN = /^#{@@SINGLE_LINE_FUNCS.join("|")}\(/
    @@FAMILY                    = {} of String => Bool

    macro family(name)
      familys(name)
    end # === macro family

    macro familys(*args)
      {% for x in args %}
        @@FAMILY[{{x}}] = true
      {% end %}
    end

    familys "background", "font"

    @is_fin = false
    getter origin : String
    getter tokens : Array(String)
    getter stack : Parser::Stack
    getter file_dir : String

    getter io           = IO::Memory.new
    getter private_vars = Vars.new
    getter vars         = Vars.new

    def self.split(str : String)
      str.split(/[[:cntrl:]\ \s]+/)
    end # === def self.split

    def initialize(raw : String, @file_dir : String, string_type = :css)
      @origin = case string_type
                when :css
                  raw
                else
                  File.read(File.expand_path(raw, @file_dir))
                end
      @tokens = Parser.split(@origin)
      @stack  = Parser::Stack.new(@tokens)
    end

    def initialize(@tokens, raw_vars : Hash(String, String), @file_dir)
      @origin = ""
      @vars   = Vars.new(raw_vars)
      @stack  = Parser::Stack.new(@tokens)
    end # === def initialize

    def initialize(@tokens, parent : Parser)
      @io       = parent.io
      @file_dir = parent.file_dir
      @origin   = ""
      @vars     = parent.vars.dup
      @stack    = Parser::Stack.new(@tokens)
    end # === def initialize

    def initialize(raw, parent : Parser, string_type = :css)
      @origin = case string_type
                when :css
                  raw
                else
                  File.read File.expand_path(raw, parent.file_dir)
                end
      @file_dir = parent.file_dir
      @io       = parent.io
      @tokens   = Parser.split(@origin)
      @vars     = parent.vars.dup
      @stack    = Parser::Stack.new(@tokens)
    end # === def initialize

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
      if private_vars.has?("family")
        raise Exception.new("Family has already been set: OLD: #{family} NEW: #{family}")
      end
      stack.open(:family)
      private_vars.set("family", family)
    end

    def start_def(raw : String)
      result = raw.match /^def\ +([a-zA-Z0-9\_\-]+)\(\ *([a-zA-Z0-9\_\-\,\ ]+)\ *\)$/
      return false unless result
      name = $1
      var_names = $2.split(",").map(&.strip)

      body = stack.grab_partial("{", "}", [] of String)
    end # === def start_def

    def start_selector
      return :family if start_family

      selector = stack.previous.join(" ")
      private_vars.set("selector", selector)

      if selector.index("def ") == 0 && start_def(selector)
        return true
      end

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
      io << private_vars.get("selector") << " {"
      private_vars.delete("selector")
      stack.previous.clear
    end

    def spaces(*args)
      stack.opens.select { |x| args.includes?(x) }.size.times do |i|
        io << "  "
      end
      io
    end # === def spaces

    def finish_selector
      if private_vars.has?("family")
        private_vars.delete("family")
        return stack.close(:family)
      end
      stack.close(:selector)
      io << "\n"
      spaces(:selector)
      io << "}"
      private_vars.delete("selector") if private_vars.has?("selector")
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
        Parser.new(val, self, :file).run
      else
        raise Exception.new("Unknown function call #{name.inspect}: #{combined.inspect}");
      end
    end

    def run_var_assignment
      stack.move
      next_value = stack.grab_through(";", [] of String).join(" ");
      key        = (stack.previous.size > 0) ? stack.previous.pop : ""

      if key.empty?
        raise Exception.new("Invalid assignment: [empty] = #{next_value.inspect}")
      end

      if next_value.empty?
        raise Exception.new("Invalid assignment: #{stack.previous.join(" ")} = [empty]")
      end

      if !Vars.valid_key?(key)
        raise Exception.new("Assignment key contains invalid characters: #{key.inspect} = #{next_value.inspect};")
      end

      if !is_valid_property_value?(next_value)
        raise Exception.new("Assignment value contains invalid characters: #{key.inspect} = #{next_value.inspect};")
      end

      vars.set(key, next_value)
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

      value = replace_vars(value)
      if !is_valid_property_value?(value)
        raise Exception.new("Invalid characters in value: #{style}: #{value}")
      end

      if private_vars.has?("family")
        style = "#{private_vars.get("family")}-#{style}"
      end

      value = value.gsub(";", "")
      io << "\n"
      spaces(:selector)
      io << style << ": " << value << ";"
    end # === def run_property

    def run
      while !stack.fin?
        t = stack.current

        case

        when t == ""
          :ignore

        when t == "="
          run_var_assignment

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
          io << "\n"
          run_css_call(css_call)
          io << "\n"

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
      @is_fin = true
    end

    def to_css
      run unless @is_fin
      @io.to_s 
    end # === def to_css

    def replace_vars(raw : String)
      prev = ""
      current = raw
      counter = 0
      max = 4
      while (prev != current && counter <= (max + 2))
        prev = current
        current = replace_var_assignments__(current)
        counter += 1
      end

      if counter > max
        raise Exception.new("Too many nested assignments.")
      end

      current
    end # === def replace

    def replace_var_assignments__(raw : String)
      raw.gsub(/\{\{\ *([^\}]+)\ *\}\}/) do |match|
        key = $1.upcase
        raise Exception.new("Variable not found: #{key}") unless vars.has?(key)
        vars.get(key)
      end
    end # === def replace

    def self.run_include(raw : String, dir : String) : String
      prev = ""
      current = raw
      counter = 0
      max = 4
      while (prev != current && counter <= (max + 2))
        prev = current
        current = run_include__(current, dir)
        counter += 1
      end

      if counter > max
        raise Exception.new("Too many nested includes.")
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

