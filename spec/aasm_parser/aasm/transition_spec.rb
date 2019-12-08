# frozen_string_literal: true

RSpec.describe AasmParser::Aasm::Transition do
  let(:instance1) { described_class.new(transition_nodes[0]) }
  let(:instance2) { described_class.new(transition_nodes[1]) }
  let(:transition_nodes) do
    event_node = RubyVM::AbstractSyntaxTree.parse(code).children.last
    AasmParser::Aasm::Event.new(event_node).transition_nodes
  end

  let(:code) do
    <<~CODE
      event :start do
        transitions from: :waiting, to: :in_progress
        transitions from: :pending, to: :in_progress
      end
    CODE
  end

  describe '#from' do
    it { expect(instance1.from).to eq :waiting }
    it { expect(instance2.from).to eq :pending }
  end

  describe '#to' do
    it { expect(instance1.to).to eq :in_progress }
    it { expect(instance2.to).to eq :in_progress }
  end
end
