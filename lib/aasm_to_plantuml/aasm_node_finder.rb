# frozen_string_literal: true

module AasmToPlantuml
  # ASTから `aasm` が呼び出されているnodeを取得する
  class AasmNodeFinder
    def initialize(root)
      @root = root
    end

    def self.call
      new(root).send(:call)
    end

    def calling_aasm_node?(node)
      return false unless node.type == :FCALL

      node.children.first == :aasm
    end
  end
end
