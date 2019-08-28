# frozen_string_literal: true

module AasmToPlantuml
  module Aasm
    class Transition
      attr_reader :from, :to

      class << self
        def parse_from(event)
          transition_nodes = event.transition_nodes
          raise unless transition_nodes.all?(&method(:valid_node?))

          transition_nodes.map do |node|
            attributes = collect_leaves_from_node(node).each_slice(2).to_h
            new(attributes)
          end
        end

        private

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

      def initialize(from:, to:)
        @from = from
        @to = to
      end
    end
  end
end
