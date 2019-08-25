# frozen_string_literal: true

RSpec.describe AasmToPlantuml::AasmNodeFinder do
  describe '#calling_aasm_node?' do
    let(:node) { OpenStruct.new(type: :FCALL, children: [:aasm, []]) }
    let(:subject) { described_class.new(double).calling_aasm_node?(node) }

    it { is_expected.to be true }
  end
end
