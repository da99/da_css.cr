
module DA_STYLE
  module Parser
    struct Def_Func

      @name : String
      @vars : Array(String)
      @body : Array(String)

      def initialize(@name, @vars, @body)
      end # === def initialize

      def run(def_call : String, parent : Parser)
        if !def_call.match(/^\ *[^\(]+\((.+)\);?$/)
          raise Exception.new("Invalid function call: #{def_call.inspect}")
        end

        args = $1.split(",").map(&.strip)
        if args.size != @vars.size
          raise Exception.new("Invalid number of arguments for #{@name}: #{args.inspect}")
        end

        vars = parent.vars.dup
        args.each_with_index do |x, i|
          vars.update!(@vars[i], x)
        end

        parent.class.new(@body, vars, parent).run
        parent.io << "\n"
      end # === def run

    end # === struct Def_Func
  end # === module Parser
end # === module DA_STYLE
