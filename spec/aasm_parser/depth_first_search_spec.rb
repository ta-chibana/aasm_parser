# frozen_string_literal: true

RSpec.describe AasmParser::DepthFirstSearch do
  let(:node1) { double(:node1, value: 1, children: [node2, node3]) }
  let(:node2) { double(:node2, value: 2, children: [node4]) }
  let(:node3) { double(:node3, value: 3, children: [node5, node6]) }
  let(:node4) { double(:node4, value: 4, children: []) }
  let(:node5) { double(:node5, value: 5, children: [node7, node8]) }
  let(:node6) { double(:node6, value: 6, children: []) }
  let(:node7) { double(:node7, value: 7, children: []) }
  let(:node8) { double(:node8, value: 8, children: []) }

  describe '#find_by' do
    subject { described_class.new(node1).find_by(value) }

    context 'value: 1' do
      let(:value) { 1 }

      it { is_expected.to eq node1 }
    end

    context 'value: 2' do
      let(:value) { 2 }

      it { is_expected.to eq node2 }
    end

    context 'value: 3' do
      let(:value) { 3 }

      it { is_expected.to eq node3 }
    end

    context 'value: 4' do
      let(:value) { 4 }

      it { is_expected.to eq node4 }
    end

    context 'value: 5' do
      let(:value) { 5 }

      it { is_expected.to eq node5 }
    end

    context 'value: 6' do
      let(:value) { 6 }

      it { is_expected.to eq node6 }
    end

    context 'value: 7' do
      let(:value) { 7 }

      it { is_expected.to eq node7 }
    end

    context 'value: 8' do
      let(:value) { 8 }

      it { is_expected.to eq node8 }
    end

    context 'value: 9' do
      let(:value) { 9 }

      it { is_expected.to be_nil }
    end
  end

  describe '#select_even' do
    context 'select even nodes' do
      subject { described_class.new(node1).select_by { |node| node.value.even? } }

      it { is_expected.to match_array [node2, node4, node6, node8] }
    end

    context 'select odd nodes' do
      subject { described_class.new(node1).select_by { |node| node.value.odd? } }

      it { is_expected.to match_array [node1, node3, node5, node7] }
    end

    context 'select greater than 10 node' do
      subject { described_class.new(node1).select_by { |node| node.value > 10 } }

      it { is_expected.to eq [] }
    end
  end
end
