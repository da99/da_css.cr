
require "./parser"
require "./vars"
require "./def_func"
require "./clean_url"
require "./properties"
require "./exception"

module DA_CSS

  module Printer

    @@SINGLE_LINE_FUNCS         = %w(include)
    @@SINGLE_LINE_FUNCS_PATTERN = /^#{@@SINGLE_LINE_FUNCS.join("|")}\(/
    @@FAMILY                    = {} of String => Bool

    @@CUSTOM_PROPERTYS = {} of String => Bool

    macro property_name(name)
      @@CUSTOM_PROPERTYS["{{name.id}}"] = true
    end # === macro property

    macro family(name)
      familys(name)
    end # === macro family

    macro familys(*args)
      {% for x in args %}
        @@FAMILY[{{x}}] = true
      {% end %}
    end

    @is_fin = false
    getter parser    : Parser
    getter file_dir  : String

    getter io           = IO::Memory.new
    getter private_vars = Vars.new
    getter vars         = Vars.new
    getter scope_count  = 0
    getter open_family  = [] of String
    getter def_funcs    = {} of String => Hash(Int32, Def_Func)

    # === Most common `initialize`. Creates a new scope.
    def initialize(raw : String, @file_dir : String)
      raw = raw.strip
      if !raw.index("\n") && raw.index(".css") == (raw.size - 4)
        raw = DA_CSS.file_read!(@file_dir, raw)
      end

      @parser = Parser.new(raw)
    end # === def initialize

    # === Creates a copy of parent scope. Used by Def_Funcs:
    def initialize(tokens : Array(String), parent : Printer)
      @file_dir     = parent.file_dir
      @io           = parent.io
      @parser        = Parser.new(tokens)
      @def_funcs    = parent.def_funcs.dup
      @vars         = parent.vars.dup
      @private_vars = parent.private_vars.dup
      @open_family  = parent.open_family.dup
    end # === def initialize

    def is_valid_selector?(raw : String)
      codepoints = raw.codepoints

      # Min size of selector to
      #   avoid this vulnerability: http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2010-3971
      return false if codepoints.size < 2

      if codepoints.first == '@'.hash
        return raw =~ /@[a-z]+\ *\([a-z\,\/\:\ 0-9\,\_\-]+\)/i
      end

      invalid = raw.codepoints.find { |point|
        case point

        when ('a'.hash)..('z'.hash),
          ('A'.hash)..('Z'.hash),
          ('0'.hash)..('9'.hash),
          '#'.hash, '-'.hash, '.'.hash, ','.hash,
          ' '.hash, ':'.hash
          # e.g.
          #   div:nth-child, #main.klass, #tex-min
          false

        else
          point

        end # case point
      }
      return !invalid
    end # === def is_valid_selector?

    def is_valid_property_name?(raw : String)
      # Make exceptions for certain families:
      case raw
      when "padding", "border", "margin"
        return true
      end

      # Family names are not allowed as property
      #   names for security reasons:
      return false if is_property_family?(raw)

      {% begin %}
        case raw
        when {{ system("cat \"#{__DIR__}/list.txt\"").split.map(&.stringify).join(", ").id }}
          true
        else
          @@CUSTOM_PROPERTYS.has_key?(raw)
        end
      {% end %}
    end # === def is_valid_property_name?

    def is_property_family?(raw : String)
      {% begin %}
        case raw
        when {{ system("grep  -P '#\\ +Family' \"#{__DIR__}/list.txt\"").split("\n").map { |x| x.split.first.stringify }.join(", ").id }}
          true
        else
          false
        end
      {% end %}
    end # === def is_property_family?

    def open_family?
      !@open_family.empty?
    end # === def in_family?

    def start_family
      return false if parser.previous.size != 1
      return false if !open_family? &&  !is_property_family?(parser.previous.last || "")
      family = parser.previous.pop
      open_family.push family
      parser.open(:family)
    end

    def start_def
      raw = parser.previous.join(" ")
      parser.previous.clear

      result = raw.match /^def\ +([a-zA-Z0-9\_\-]+)\(\ *([a-zA-Z0-9\_\-\,\ ]+)\ *\)$/
      if !result
        raise Invalid_Selector.new(raw.inspect)
      end

      name = $1.strip.upcase
      var_names = $2.split(",").map { |x|
        new_x = x.strip.upcase
        if !Vars.is_valid_key?(new_x)
          raise Exception.new("Invalid argument name for def #{name.inspect}: #{x.inspect}")
        end
        new_x
      }
      body = parser.grab_partial("{", "}", [] of String)

      if @def_funcs.has_key?(name) && @def_funcs[name].has_key?(var_names.size)
        raise Exception.new("Func already defined: #{name.inspect}")
      end

      if !@def_funcs.has_key?(name)
        @def_funcs[name] = {} of Int32 => Def_Func
      end

      @def_funcs[name][var_names.size] = Def_Func.new(name, var_names, body);
    end # === def start_def

    def start_selector
      return :family if start_family

      if parser.previous.first == "def" && parser.previous.last.rindex(")") == (parser.previous.last.size - 1)
        return start_def
      end

      selector = parser.previous.join(" ")
      private_vars.set("selector", selector)

      if !is_valid_selector?(selector)
        raise Invalid_Selector.new(selector.inspect)
      end

      if !parser.closes.empty?
        if parser.closes.last != :var
          io << "\n"
        end
      end

      spaces(:selector)
      parser.open(:selector)
      io << private_vars.get("selector") << " {"
      private_vars.delete("selector")
      parser.previous.clear
    end

    def spaces(*args)
      parser.opens.select { |x| args.includes?(x) }.size.times do |i|
        io << "  "
      end
      io
    end # === def spaces

    def finish_selector
      if open_family?
        open_family.pop
        return parser.close(:family)
      end
      parser.close(:selector)
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
        io << "\n"
        code = DA_CSS.file_read!(file_dir, val)
        run(Parser.new(code))
        io << "\n"
      else
        raise Exception.new("Unknown function call #{name.inspect}: #{combined.inspect}");
      end
    end

    def run_var_assignment
      parser.move
      next_value = parser.grab_through(";", [] of String).join(" ");
      key        = (parser.previous.size > 0) ? parser.previous.pop : ""

      if key.empty?
        raise Exception.new("Invalid assignment: [empty] = #{next_value.inspect}")
      end

      if next_value.empty?
        raise Exception.new("Invalid assignment: #{parser.previous.join(" ")} = [empty]")
      end

      if !Vars.is_valid_key?(key)
        raise Exception.new("Assignment key contains invalid characters: #{key.inspect} = #{next_value.inspect};")
      end

      vars.set(key, next_value)
      parser.previous.clear
      parser.closes << :var
    end # === def run_assignment

    def replace_url(property_name : String, func_name : String, arg : String)
      dirty = arg.strip("'\"")
      clean_url = Clean_Url.clean(dirty)
      if !clean_url
        raise Invalid_URL.new("Invalid url: #{dirty}")
      end

      "url('#{clean_url}')"
    end # === def replace_url

    def replace_rect(property_name : String, func_name : String, raw_args : String)
      args = raw_args.split(/[,\s]+/)
      return false if args.size != 4
      return false unless args.all? { |x| x.match(/^[\d]{1,4}[a-z]{2,5}$/) }
      "rect(#{args.join " "})"
    end # === def replace_rect

    def replace_rgb(property_name : String, func_name : String, raw_args : String)
      args = raw_args.strip.split(/[\,|\s]+/).map(&.strip)
      return false unless args.size == 3
      case
      when args.first.index("%")
        return false unless args.all? { |x| x.match(/^[0-9]{1,3}\%$/) }
      else # whole number
        return false unless args.all? { |x| x.match(/^[0-9]{1,3}$/) }
      end

      "rgb(#{args.join(", ")})"
    end # === def replace_color

    def replace_rgba(property_name : String, func_name : String, raw_args : String)
      args          = raw_args.strip.split(/[\,|\s]+/).map(&.strip)
      num_pattern   = /^[0-9]{1,3}$/
      alpha_pattern = /^(0\.)?[0-9]{1}$/

      case args.size
      when 4
        alpha = args.pop
        return false unless args.all? { |x| x.match(num_pattern) }
        return false unless alpha.match(alpha_pattern)
        "rgba(#{args.join(", ")}, #{alpha})"
      when 5
        return false unless args[3] == "/"
        alpha = args.pop
        slash = args.pop
        return false unless args.all? { |x| x.match(num_pattern) }
        return false unless alpha.match(alpha_pattern)
        "rgba(#{args.join(" ")} / #{alpha})"
      else
        return false
      end
    end # === def replace_color

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

    def replace_css_funcs(property_name : String, raw : String)
      raw.gsub(/([^\(]+)\(\ *(.+)\ *\)/) do |match|
        func_name = $1
        args      = $2
        new_str = case
                  when (property_name.index("-image") || 0) > 1 && func_name == "url"
                    replace_url(property_name, func_name, args)

                  when property_name.index("color") && func_name == "rgb"
                    replace_rgb(property_name, func_name, args)

                  when property_name.index("color") && func_name == "rgba"
                    replace_rgba(property_name, func_name, args)

                  when property_name == "clip" && func_name == "rect"
                    replace_rect(property_name, func_name, args)

                  end # === case

        if !new_str.is_a?(String)
          raise Unknown_CSS_Function.new("#{raw.inspect} can't be used with #{property_name.inspect}")
        end
        new_str
      end # === gsub
    end # === def replace_css_funcs

    def replace_var_assignments__(raw : String)
      raw.gsub(/\{\{\ *([^\}]+)\ *\}\}/) do |match|
        key = $1.upcase
        raise Exception.new("Variable not found: #{key}") unless vars.has?(key)
        vars.get(key)
      end
    end # === def replace

    def run_property
      style = if parser.current == ":" && parser.previous.size == 1
                parser.previous.pop
              else
                parser.current.rstrip(":")
              end

      parser.move
      value = parser.grab_through(";", [] of String).join(" ")

      if style.empty?
        raise Exception.new("Invalid property name: [empty]: #{value}")
      end

      if open_family?
        style = "#{open_family.join("-")}-#{style}"
      end
      # === property value:
      value = replace_vars(value)

      value = clean_property!(style, value)
      value = replace_css_funcs(style, value)

      value = value.gsub(";", "")
      io << "\n"
      spaces(:selector)
      io << style << ": " << value << ";"
    end # === def run_property

    def run(temp : Parser)
      orig = @parser
      @parser = temp
      run
      @parser = orig
    end # === def run

    def run
      if @scope_count > 10
        raise Exception.new("Too many nested scopes: #{@scope_count}")
      end

      while !parser.fin?
        t = parser.current

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
          parser.grab_until_token_is("{")
          start_selector

        when t.index("/*") == 0
          parser.erase_through("*/")

        when t.index(@@SINGLE_LINE_FUNCS_PATTERN) == 0
          css_call = parser.grab_through(";", [] of String)
          run_css_call(css_call)

        when parser.previous.empty? && (t.index("(") || 0) > 1
          name = t.split("(").first.upcase
          if !@def_funcs.has_key?(name)
            raise Exception.new("Function call not found with name: #{name.inspect} (Available: #{@def_funcs.keys.join ", "})")
          end

          css_call = parser.grab_through(";", [] of String).join(" ")
          arg_size = css_call.count { |x| x == ',' } + 1

          if !@def_funcs[name].has_key?(arg_size)
            raise Exception.new("Function call not found with name: #{name}(#{("__ " * arg_size).split.join(", ")})")
          end
          @def_funcs[name][arg_size].run(css_call, self)

        else
          parser.previous.push t
        end

        parser.move
      end

      if !parser.previous.empty?
        raise Exception.new("Unknown values: #{parser.previous.join(" ").inspect}")
      end

      if parser.open?
        raise Exception.new("Missing closing } for: #{parser.open}")
      end
    end # === def run

    def to_css
      if !@is_fin
        run
        @is_fin = true
      end

      str = @io.to_s

      if str.bytesize > Output_File_Size_Max_Reached.max_file_size
        raise Output_File_Size_Max_Reached.new(str.bytesize.to_s)
      end
      str
    end # === def to_css

  end # === module Printer

end # === module DA_CSS

