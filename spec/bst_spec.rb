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
  end

  describe '#level_order_rec' do
    subject(:recursive_levelled_tree) { described_class.new([1, 2, 3]) }

    it 'traverses the nodes in level order and yields each to a block' do
      expected = [2, 1, 3]
      actual = []
      recursive_levelled_tree.level_order_rec { |node| actual << node.data }
      expect(actual).to eq(expected)
    end
  end
end
