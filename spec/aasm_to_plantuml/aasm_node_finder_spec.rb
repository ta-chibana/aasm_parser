# frozen_string_literal: true

RSpec.describe AasmParser::AasmNodeFinder do
  describe '.call' do
    let(:code) do
      <<~CODE
        class Test
          aasm column: :status do
            state :waiting, initial: true
            state :in_progress, :finished

            event :start do
              transitions from: :waiting, to: :in_progress
            end

            event :finish do
              transitions from: :in_progress, to: :finished
            end
          end
        end
      CODE
    end

    let(:node) { RubyVM::AbstractSyntaxTree.parse(code) }

    subject(:target_node) { described_class.call(node) }

    it 'aasm のスコープの要素が取得できる' do
      expect(target_node.type).to eq :ITER
      expect(target_node.children.size).to eq 2
      expect(target_node.children.first.type).to eq :FCALL
      expect(target_node.children.last.type).to eq :SCOPE
    end
  end
end
