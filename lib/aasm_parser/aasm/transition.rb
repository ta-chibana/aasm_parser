# frozen_string_literal: true

module AasmParser
  module Aasm
    class Transition
      def initialize(transition_node)
        @transition_node = transition_node
      end

      def from
        @from ||= attributes[:from]
      end

      def to
        @to ||= attributes[:to]
      end

      private

      def attributes
        @attributes ||= begin
          raise unless valid_node?(@transition_node)

          collect_leaves_from_node(@transition_node).each_slice(2).to_h
        end
      end

      def collect_leaves_from_node(node)
        return nil unless node.respond_to?(:type)

        nodes = []
        nodes << node.children.first if leaf_node?(node)
        nodes << collect_leaves_from_children(node.children)

        nodes.flatten.compact
      end

      def collect_leaves_from_children(children)
        return [] if children.blank?

        head, *tail = children
        nodes = []
        nodes << collect_leaves_from_node(head)
        nodes << collect_leaves_from_children(tail)

        nodes.flatten.compact
      end

      def leaf_node?(node)
        node.type == :LIT
      end

      def valid_node?(node)
        node.children.first == :transitions
      end
    end
  end
end
