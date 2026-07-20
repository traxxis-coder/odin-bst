require_relative '../lib/bst'

describe Tree do
  describe '#initialize' do
    subject(:new_tree) { described_class.new([4]) }

    it 'creates a root node' do
      expect(new_tree.root.data).to be 4
    end

    context 'when enterring an unsorted 3-item array' do
      subject(:tree_of_three) { described_class.new([3, 1, 2]) }

      it 'sets the middle value as root' do
        expect(tree_of_three.root.data).to eq 2
      end

      it 'places the lowest value as a left leaf' do
        expect(tree_of_three.root.left.data).to eq 1
      end

      it 'places the highest value as a right leaf' do
        expect(tree_of_three.root.right.data).to eq 3
      end
    end
  end

  describe '#level_order' do
    subject(:levelled_tree) { described_class.new([1, 2, 3]) }

    it 'traverses the nodes in level order and yields each to a block' do
      expected = [2, 1, 3]
      actual = []
      levelled_tree.level_order { |node| actual << node.data }
      expect(actual).to eq(expected)
    end

    it 'returns an Enumerator if no block biven' do
      expected = [4, 2, 6]
      actual = levelled_tree.level_order.map { |n| n.data * 2 }
      expect(actual).to eq(expected)
    end
  end

  describe '#level_order_rec' do
    subject(:recursive_levelled_tree) { described_class.new([1, 2, 3]) }

    it 'traverses the nodes in level order and yields each to a block' do
      expected = [2, 1, 3]
      actual = []
      recursive_levelled_tree.level_order_rec { |node| actual << node.data }
      expect(actual).to eq(expected)
    end

    it 'returns an Enumerator if no block biven' do
      expected = [4, 2, 6]
      actual = recursive_levelled_tree.level_order_rec.map { |n| n.data * 2 }
      expect(actual).to eq(expected)
    end
  end

  describe '#include?' do
    subject(:including_tree) { described_class.new([4, 2, 6, 7, 9, 3, 0]) }

    it 'returns true for an included value' do
      expect(including_tree.include?(7)).to be true
    end

    it 'returns false for an absent value' do
      expect(including_tree.include?(10)).to be false
    end
  end

  describe '#insert' do
    subject(:inserting_tree) { described_class.new([1, 3, 4]) }

    it 'inserts a new value in the correct spot' do
      inserting_tree.insert(2)
      expect(inserting_tree.root.left.right.data).to eq 2
    end

    it 'doesn\'t insert a duplicate value' do
      inserting_tree.insert(1)
      expected = [3, 1, 4]
      actual = []
      inserting_tree.level_order { |node| actual << node.data }
      expect(actual).to eq expected
    end
  end

  describe '#delete' do
    subject(:deleting_tree) { described_class.new([5, 6, 3, 7]) }

    it 'removes given node with 2 branches from tree' do
      deleting_tree.delete(5)
      expected = [6, 3, 7]
      actual = []
      deleting_tree.level_order { |node| actual << node.data }
      expect(actual).to eq expected
    end

    it 'removes given node with 1 child from node' do
      deleting_tree.delete(6)
      expected = [5, 3, 7]
      actual = []
      deleting_tree.level_order { |node| actual << node.data }
      expect(actual).to eq expected
    end
  end

  describe '#inorder' do
    subject(:ordered_tree) { described_class.new([5, 6, 2, 1, 9]) }

    it 'traverses the nodes in order and yields each to a block' do
      expected = [1, 2, 5, 6, 9]
      actual = []
      ordered_tree.inorder { |node| actual << node.data }
      expect(actual).to eq(expected)
    end

    it 'returns an Enumerator if no block biven' do
      expected = [2, 4, 10, 12, 18]
      actual = ordered_tree.inorder.map { |n| n.data * 2 }
      expect(actual).to eq(expected)
    end
  end

  describe '#preorder' do
    subject(:preordered_tree) { described_class.new([5, 6, 2, 1, 9]) }

    it 'traverses the nodes in order and yields each to a block' do
      expected = [5, 1, 2, 6, 9]
      actual = []
      preordered_tree.preorder { |node| actual << node.data }
      expect(actual).to eq(expected)
    end

    it 'returns an Enumerator if no block biven' do
      expected = [10, 2, 4, 12, 18]
      actual = preordered_tree.preorder.map { |n| n.data * 2 }
      expect(actual).to eq(expected)
    end
  end

  describe '#postorder' do
    subject(:postordered_tree) { described_class.new([5, 6, 2, 1, 9]) }

    it 'traverses the nodes in order and yields each to a block' do
      expected = [2, 1, 9, 6, 5]
      actual = []
      postordered_tree.postorder { |node| actual << node.data }
      expect(actual).to eq(expected)
    end

    it 'returns an Enumerator if no block biven' do
      expected = [4, 2, 18, 12, 10]
      actual = postordered_tree.postorder.map { |n| n.data * 2 }
      expect(actual).to eq(expected)
    end
  end

  describe '#height' do
    subject(:high_tree) { described_class.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]) }

    it 'returns the highest number of edges to reach a leaf from the given value' do
      expect(high_tree.height(3)).to eq 2
    end

    it 'returns nil if the tree doesn\'t include the value' do
      expect(high_tree.height(0)).to be nil
    end
  end

  describe '#depth' do
    subject(:deep_tree) { described_class.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]) }

    it 'returns the number of edges to reach a given value from the root' do
      expect(deep_tree.depth(6)).to eq 3
    end

    it 'returns nil if the tree doesn\'t include the value' do
      expect(deep_tree.depth(0)).to be nil
    end
  end

  describe '#balanced?' do
    subject(:balanced_tree) { described_class.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]) }

    it 'returns true for a balanced tree' do
      expect(balanced_tree).to be_balanced
    end

    it 'returns false for an imbalanced tree' do
      balanced_tree.insert(14)
      balanced_tree.insert(15)
      balanced_tree.insert(16)
      balanced_tree.insert(-1)
      balanced_tree.insert(-2)
      balanced_tree.insert(-3)
      expect(balanced_tree).not_to be_balanced
    end

    it 'returns true for a one node tree' do
      tiny_tree = described_class.new([1])
      expect(tiny_tree).to be_balanced
    end

    it 'returns true for an empty tree' do
      empty_tree = described_class.new([nil])
      expect(empty_tree).to be_balanced
    end

    it 'returns false for a linear tree' do
      branch = described_class.new([1])
      branch.insert(2)
      branch.insert(3)
      branch.insert(4)
      expect(branch).not_to be_balanced
    end
  end

  describe '#rebalance' do
    subject(:imbalanced_tree) { described_class.new([1]) }
    before do
      imbalanced_tree.insert(2)
      imbalanced_tree.insert(3)
      imbalanced_tree.insert(4)
    end

    it 'makes the tree balanced' do
      imbalanced_tree.rebalance
      expect(imbalanced_tree).to be_balanced
    end
  end
end
