require_relative 'lib/bst'

tree = Tree.new(Array.new(15) { rand(1..100) })

tree.pretty_print

puts "Tree is balanced: #{tree.balanced?}"

inorder = []
tree.inorder { |node| inorder << node.data }

preorder = []
tree.preorder { |node| preorder << node.data }

postorder = []
tree.postorder { |node| postorder << node.data }

level_order = []
tree.level_order { |node| level_order << node.data }

puts "\nInorder: #{inorder}"
puts "Preorder: #{preorder}"
puts "Postorder: #{postorder}"
puts "Level order: #{level_order}"

tree.insert(150)
tree.insert(2456)
tree.insert(24_196)

tree.pretty_print

puts "Tree balanced: #{tree.balanced?}"

tree.rebalance

tree.pretty_print

puts "Tree balanced: #{tree.balanced?}"

inorder = []
tree.inorder { |node| inorder << node.data }

preorder = []
tree.preorder { |node| preorder << node.data }

postorder = []
tree.postorder { |node| postorder << node.data }

level_order = []
tree.level_order { |node| level_order << node.data }

puts "\nInorder: #{inorder}"
puts "Preorder: #{preorder}"
puts "Postorder: #{postorder}"
puts "Level order: #{level_order}"
