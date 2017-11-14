
module DA_CSS
    struct Def_Func

      @name : String
      @vars : Array(String)
      @body : Array(String)

      def initialize(@name, @vars, @body)
      end # === def initialize

      def run(def_call : String, parent : Printer)
        if !def_call.match(/^\ *[^\(]+\((.+)\);?$/)
          raise Exception.new("Invalid function call: #{def_call.inspect}")
        end

        args = $1.split(",").map(&.strip)
        if args.size != @vars.size
          raise Exception.new("Invalid number of arguments for #{@name}: #{args.inspect}")
        end

        new_scope = parent.class.new(@body, parent)
        args.each_with_index do |x, i|
          new_scope.vars.update!(@vars[i], x)
        end
        new_scope.run
        parent.io << "\n"
      end # === def run

    end # === struct Def_Func
end # === module DA_CSS
