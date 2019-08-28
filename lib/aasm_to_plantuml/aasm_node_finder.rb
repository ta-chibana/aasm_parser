# frozen_string_literal: true

module AasmToPlantuml
  class AasmNodeFinder
    def initialize(root)
      @root = root
    end

    def self.call(root)
      new(root).send(:call)
    end

    private

    attr_reader :root

    def call
      find_from_node(root)
    end

    def find_from_node(node)
      return nil unless node.respond_to?(:type)
      return node if node_of_aasm_scope?(node)

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

    def node_of_aasm_scope?(node)
      return false unless node.try(:type) == :ITER

      first_child = node.children.first
      return false unless first_child.type == :FCALL

      first_child.children.first == :aasm
    end
  end
end
