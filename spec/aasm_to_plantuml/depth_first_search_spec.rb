# frozen_string_literal: true

RSpec.describe AasmToPlantuml::DepthFirstSearch do
  describe '#find_by' do
    let(:node1) { OpenStruct.new(value: 1, children: [node2, node3]) }
    let(:node2) { OpenStruct.new(value: 2, children: [node4]) }
    let(:node3) { OpenStruct.new(value: 3, children: [node5, node6]) }
    let(:node4) { OpenStruct.new(value: 4, children: []) }
    let(:node5) { OpenStruct.new(value: 5, children: [node7, node8]) }
    let(:node6) { OpenStruct.new(value: 6, children: []) }
    let(:node7) { OpenStruct.new(value: 7, children: []) }
    let(:node8) { OpenStruct.new(value: 8, children: []) }

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
  end
end
