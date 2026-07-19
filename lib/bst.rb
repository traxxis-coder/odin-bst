require_relative 'node'

class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def pretty_print(node = @root, prefix = '', is_left: true)
    return unless node

    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", is_left: false)
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", is_left: true)
  end

  def level_order
    return to_enum(:level_order) unless block_given?

    q = [@root]

    until q.empty?
      current = q.shift
      yield current
      q.push(current.left) unless current.left.nil?
      q.push(current.right) unless current.right.nil?
    end
  end

  def level_order_rec(node = @root, &block)
    return to_enum(:level_order_rec) unless block_given?
    return if node.nil?

    yield node if block_given?
    level_order_rec(node.left, &block)
    level_order_rec(node.right, &block)
  end

  private

  def build_tree(array, start_index = 0, end_index = (array.size - 1))
    return nil if start_index > end_index

    mid_index = (start_index + end_index) / 2
    Node.new(array[mid_index], build_tree(array, start_index, mid_index - 1),
             build_tree(array, mid_index + 1, end_index))
  end
end
