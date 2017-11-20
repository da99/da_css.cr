
struct Doc

  getter nodes = [] of Node::Statement | Node::Assignment | Node::Selector | Node::Comment | Node::Property

  def each
    nodes.each { |x| yield x }
  end # === def each

  def push(node)
    @nodes << node
  end # === def push

  def inspect(io)
    io << "Doc["
    nodes.each_with_index { |x, i|
      io << ", " unless i == 0
      x.inspect(io)
    }
    "]"
  end # === def inspect

  def first
    @nodes.first
  end # === def first

  def last
    @nodes.last
  end

  def empty?
    @nodes.empty?
  end # === def empty?

  def first_and_only(err_msg)
    return first if @nodes.size == 1
    raise Exception.new(err_msg)
  end # === def first_and_only

end # === struct Doc
