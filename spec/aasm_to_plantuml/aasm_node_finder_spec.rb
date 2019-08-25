# frozen_string_literal: true

RSpec.describe AasmToPlantuml::AasmNodeFinder do
  describe '.call' do
    let(:code) do
      <<~CODE
        class Test
          aasm column: :status do
            state :waiting
          end
        end
      CODE
    end

    let(:node) { RubyVM::AbstractSyntaxTree.parse(code) }

    subject(:target_node) { described_class.call(node) }

    it 'typeが `:FCALL` のnodeが取得できる' do
      expect(target_node.type).to eq :FCALL
      expect(target_node.children.first).to eq :aasm
      expect(target_node.children.last.type).to eq :ARRAY
    end
  end
end
