# frozen_string_literal: true

RSpec.describe AasmToPlantuml::Aasm::Transition do
  describe '.parse_from' do
    subject(:transitions) { described_class.parse_from(event) }

    let(:event_node) do
      RubyVM::AbstractSyntaxTree.parse(code).children.last
    end

    let(:event) { AasmToPlantuml::Aasm::Event.parse(event_node) }

    context 'when without options' do
      let(:code) do
        <<~CODE
          event :start do
            transitions from: :waiting, to: :in_progress
            transitions from: :pending, to: :in_progress
          end
        CODE
      end

      it 'return transitions' do
        expect(transitions[0].from).to eq :waiting
        expect(transitions[0].to).to eq :in_progress

        expect(transitions[1].from).to eq :pending
        expect(transitions[1].to).to eq :in_progress
      end
    end
  end
end
