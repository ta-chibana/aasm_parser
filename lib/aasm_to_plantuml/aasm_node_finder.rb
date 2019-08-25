# frozen_string_literal: true

module AasmToPlantuml
  # ASTから `aasm` が呼び出されているnodeを取得する
  class AasmNodeFinder
    def initialize(root)
      @root = root
    end

    def self.call(root)
      new(root).send(:call)
    end

    def calling_aasm_node?(node)
      return false unless node.try(:type) == :FCALL

      node.children.first == :aasm
    end

    private

    attr_reader :root

    # `children` が `:aasm` の :FCALL 要素を取得する
    # :FCALL 要素の `children` は要素数2
    #   [0] ... :aasm
    #   [1] ... `.aasm` の引数を表す :ARRAY
    def call
      find_from_node(root)
    end

    def find_from_node(node)
      return nil unless node.respond_to?(:type)
      return node if calling_aasm_node?(node)

      children = node.children
      find_from_children(children)
    end

    def find_from_children(children)
      return nil if children.blank?

      head, *tail = children
      result = find_from_node(head)
      return result if result

      find_from_children(tail)
    end
  end
end
