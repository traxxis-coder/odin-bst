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

  def include?(value)
    level_order.any? { |node| node.data == value }
  end

  def insert(value, node = @root)
    return if include?(value)

    if value < node.data
      if node.left.nil?
        node.left = Node.new(value)
      else
        insert(value, node.left)
      end
    elsif node.right.nil?
      node.right = Node.new(value)
    else
      insert(value, node.right)
    end
  end

  def delete(value, node = @root, parent = nil)
    return unless include?(value)

    node, parent = find_node(value, node, parent)

    return unless parent

    if node.left && node.right
      replacement = level_order(node.right).min
      node == parent.left ? parent.left = replacement : parent.right = replacement
      replacement.left = node.left
      replacement.right = node.right
      delete(replacement.data, node, parent)
    elsif node.left && !node.right
      node == parent.left ? parent.left = node.left : parent.right = node.left
    elsif !node.left && node.right
      node == parent.left ? parent.left = node.right : parent.right = node.right
    else
      node == parent.left ? parent.left = nil : parent.right = nil
    end
  end

  private

  def build_tree(array, start_index = 0, end_index = (array.size - 1))
    return nil if start_index > end_index

    mid_index = (start_index + end_index) / 2
    Node.new(array[mid_index], build_tree(array, start_index, mid_index - 1),
             build_tree(array, mid_index + 1, end_index))
  end

  def find_node(value, node = @root, parent = nil)
    return [node, parent] if node.data == value

    if node.data > value
      find_node(value, node.left, node)
    else
      find_node(value, node.right, node)
    end
  end
end
