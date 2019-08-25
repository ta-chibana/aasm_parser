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

  describe '#initial_state' do
    subject { described_class.new(ast_block).initial_state }

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
    subject(:events) { described_class.new(ast_block).events }

    it 'return events' do
      is_expected.to all be_an_instance_of(AasmToPlantuml::Aasm::Event)

      expect(events[0].name).to eq :start
      expect(events[1].name).to eq :finish
    end
  end
end
