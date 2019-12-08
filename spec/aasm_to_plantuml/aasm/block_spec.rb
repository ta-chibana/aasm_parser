# frozen_string_literal: true

RSpec.describe AasmParser::Aasm::Block do
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
  let(:ast_block) { AasmParser::AasmNodeFinder.call(node) }

  describe '#state_names' do
    subject { described_class.parse(ast_block).state_names }

    it { is_expected.to eq %i[waiting in_progress in_review finished] }
  end

  describe '#initial_state' do
    subject { described_class.parse(ast_block).initial_state }

    it { is_expected.to eq :waiting }

    context '`initial: true` の state の定義順が後になっている場合' do
      let(:code) do
        <<~CODE
          class Test
            aasm column: :status do
              state :in_progress, :in_review
              state :finished

              event :start do
                transitions from: :waiting, to: :in_progress
              end

              event :finish do
                transitions from: :in_progress, to: :finished
              end

              state :waiting, initial: true
            end
          end
        CODE
      end

      it { is_expected.to eq :waiting }
    end
  end

  describe '#events' do
    subject(:events) { described_class.parse(ast_block).events }

    it 'return events' do
      is_expected.to all be_an_instance_of(AasmParser::Aasm::Event)

      expect(events[0].name).to eq :start
      expect(events[1].name).to eq :finish
    end
  end
end
