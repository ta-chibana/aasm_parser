# frozen_string_literal: true

class AasmParser
  # 深さ優先探索のテスト用クラス
  class DepthFirstSearch
    def initialize(root)
      @root = root
    end

    def find_by(value)
      @value = value
      find_from_node(root)
    end

    def select_by(&block)
      select_from_node(root, &block)
    end

    private

    attr_reader :root, :value

    def find_from_node(node)
      return node if node.value == value

      find_from_children(node.children)
    end

    def find_from_children(children)
      head = children.first
      return nil if head.nil?

      result = find_from_node(head)
      return result if result

      tail = children[1..-1]
      find_from_children(tail)
    end

    def select_from_node(node, &block)
      nodes = []

      nodes << node if !node.value.nil? && yield(node)
      nodes << select_from_children(node.children, &block)

      nodes.flatten.compact
    end

    def select_from_children(children, &block)
      head, *tail = children
      return nil if head.nil?

      nodes = []
      nodes << select_from_node(head, &block)
      nodes << select_from_children(tail, &block)

      nodes.flatten.compact
    end
  end
end
