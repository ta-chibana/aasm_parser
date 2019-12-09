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

    subject { described_class.call(node) }

    it { is_expected.to be_an_instance_of(AasmParser::Aasm::Block) }
  end
end
