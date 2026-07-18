require_relative '../lib/node'

describe Node do
  describe '#initialize' do
    subject(:new_node) { described_class.new(7, described_class.new(4), described_class.new(9)) }
    it 'sets the node\'s value' do
      expect(new_node.data).to be 7
    end

    it 'correctly sets the left node' do
      expect(new_node.left.data).to be 4
    end

    it 'correctly sets the right node' do
      expect(new_node.right.data).to be 9
    end
  end
end
