# frozen_string_literal: true

RSpec.describe AasmToPlantuml::Aasm::Block do
  let(:code) do
    <<~CODE
      class Test
        aasm column: :status do
          state :waiting, initial: true
          state :in_progress, :in_review
          state :finished

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
  let(:ast_block) do
    AasmToPlantuml::AasmNodeFinder
      .call(node)
      .children
      .last
      .children
      .last
  end

  describe '#states' do
    subject { described_class.new(ast_block).states }

    it { is_expected.to eq %i[waiting in_progress in_review finished] }
  end
end
