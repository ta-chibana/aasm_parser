# frozen_string_literal: true

RSpec.describe AasmToPlantuml::Aasm::Event do
  describe '.parse' do
    context 'when there is one transitions node' do
      let(:code) do
        <<~CODE
          event :start do
            transitions from: :waiting, to: :in_progress
          end
        CODE
      end

      let(:event_node) do
        RubyVM::AbstractSyntaxTree.parse(code).children.last
      end

      subject(:instance) { described_class.parse(event_node) }

      it 'return Event instance' do
        is_expected.to be_an_instance_of AasmToPlantuml::Aasm::Event

        expect(instance.name).to eq :start
        expect(instance.transition_nodes.size).to eq 1
        expect(instance.transition_nodes.map(&:children).map(&:first)).to all(eq(:transitions))
      end
    end

    context 'when there is some transitions node' do
      let(:code) do
        <<~CODE
          event :start do
            transitions from: :waiting, to: :in_progress
            transitions from: :pending, to: :in_progress
          end
        CODE
      end

      let(:event_node) do
        RubyVM::AbstractSyntaxTree.parse(code).children.last
      end

      subject(:instance) { described_class.parse(event_node) }

      it 'return Event instance' do
        is_expected.to be_an_instance_of AasmToPlantuml::Aasm::Event

        expect(instance.name).to eq :start
        expect(instance.transition_nodes.size).to eq 2
        expect(instance.transition_nodes.map(&:children).map(&:first)).to all(eq(:transitions))
      end
    end
  end

  describe '#transitions' do
    let(:code) do
      <<~CODE
        event :start do
          transitions from: :waiting, to: :in_progress
          transitions from: :pending, to: :in_progress
        end
      CODE
    end

    let(:event_node) { RubyVM::AbstractSyntaxTree.parse(code).children.last }
    let(:event) { described_class.parse(event_node) }
    let(:transitions) { double(:transitions) }

    subject { event.transitions }

    it 'return transitions' do
      expect(AasmToPlantuml::Aasm::Transition)
        .to receive(:parse_from)
        .with(event)
        .and_return(transitions)

      is_expected.to eq transitions
    end
  end
end
