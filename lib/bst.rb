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

    yield node
    level_order_rec(node.left, &block)
    level_order_rec(node.right, &block)
  end

  def inorder(node = @root, &block)
    return to_enum(:inorder) unless block_given?
    return if node.nil?

    inorder(node.left, &block)
    yield node
    inorder(node.right, &block)
  end

  def preorder(node = @root, &block)
    return to_enum(:preorder) unless block_given?
    return if node.nil?

    yield node
    preorder(node.left, &block)
    preorder(node.right, &block)
  end

  def postorder(node = @root, &block)
    return to_enum(:postorder) unless block_given?
    return if node.nil?

    postorder(node.left, &block)
    postorder(node.right, &block)
    yield node
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

  def delete(value, node = @root)
    return unless include?(value)
    return if node.nil?

    if node.data > value
      node.left = delete(value, node.left)
    elsif node.data < value
      node.right = delete(value, node.right)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      replacement = find_replacement(node)
      node.data = replacement.data
      node.right = delete(replacement.data, node.right)
    end

    node
  end

  def height(value)
    return nil unless include?(value)

    node = find_node(value)
    measure_height(node)
  end

  def depth(value, node = @root, count = 0)
    return nil unless include?(value)
    return count if node.data == value

    if node.data > value
      depth(value, node.left, count + 1)
    else
      depth(value, node.right, count + 1)
    end
  end

  def balanced?(node = @root)
    return true if node.nil?

    balanced = (-1..1).include?(measure_height(node.left) - measure_height(node.right))

    balanced && balanced?(node.left) && balanced?(node.right)
  end

  def rebalance
    nodes = []
    inorder { |node| nodes << node.data }
    initialize(nodes)
  end

  private

  def build_tree(array, start_index = 0, end_index = (array.size - 1))
    return nil if start_index > end_index

    mid_index = (start_index + end_index) / 2
    Node.new(array[mid_index], build_tree(array, start_index, mid_index - 1),
             build_tree(array, mid_index + 1, end_index))
  end

  def find_node(value, node = @root)
    return node if node.data == value

    if node.data > value
      find_node(value, node.left)
    else
      find_node(value, node.right)
    end
  end

  def find_replacement(node)
    node = node.right
    node = node.left until node.nil? || node.left.nil?
    node
  end

  def measure_height(node, count = 0, array = [])
    return array.push(count - 1).max if node.nil?

    measure_height(node.left, count + 1, array)
    measure_height(node.right, count + 1, array)

    array.max
  end
end
