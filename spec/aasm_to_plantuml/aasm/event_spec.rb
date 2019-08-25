# frozen_string_literal: true

RSpec.describe AasmToPlantuml::Aasm::Event do
  describe '.parse' do
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
    end
  end
end
