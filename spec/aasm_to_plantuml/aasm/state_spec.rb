# frozen_string_literal: true

RSpec.describe AasmToPlantuml::Aasm::State do
  let(:node) { RubyVm::AbstractSyntaxTree.parse(code) }
  let(:ast_block) { AasmToPlantuml::AasmNodeFinder.call(node) }

  describe '#names' do
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

    it 'すべての state の名前を取得する' do
    end
  end

  describe '#initial_state?' do
  end
end
