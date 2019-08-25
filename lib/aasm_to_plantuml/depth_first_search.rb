# frozen_string_literal: true

module AasmToPlantuml
  # 深さ優先探索のテスト用クラス
  class DepthFirstSearch
    def initialize(root)
      @root = root
    end

    def find_by(value)
      @value = value
      find_from_node(root)
    end

    private

    attr_reader :root, :value

    def find_from_node(node)
      return node if node.value == value

      find_from_children(node.children)
    end

    def find_from_children(children)
      return nil if children.nil?

      head = children.first
      return nil if head.nil?

      result = find_from_node(head)
      return result if result

      tail = children[1..-1]
      find_from_children(tail)
    end
  end
end
