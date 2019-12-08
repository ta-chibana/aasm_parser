# frozen_string_literal: true

module AasmParser
  module Aasm
    class Event
      def initialize(event_node)
        @event_node = event_node
      end

      def name
        @name ||= find_name_from_node(@event_node)
      end

      def transitions
        @transitions ||= transition_nodes.map { |e| Transition.new(e) }
      end

      def transition_nodes
        @transition_nodes ||= find_transition_nodes_from_node(@event_node)
      end

      private

      def find_name_from_node(node)
        return nil unless node.respond_to?(:type)
        return node.children.first if node.type == :LIT

        find_name_from_children(node.children)
      end

      def find_name_from_children(children)
        return nil if children.blank?

        head, *tail = children
        result = find_name_from_node(head)
        return result if result

        find_name_from_children(tail)
      end

      def find_transition_nodes_from_node(node)
        return nil unless node.respond_to?(:type)

        nodes = []
        nodes << node if transitions_node?(node)
        nodes << find_transitions_node_from_children(node.children)

        nodes.flatten.compact
      end

      def find_transitions_node_from_children(children)
        return nil if children.blank?

        head, *tail = children
        nodes = []
        nodes << find_transition_nodes_from_node(head)
        nodes << find_transitions_node_from_children(tail)

        nodes.flatten.compact
      end

      def transitions_node?(node)
        node.type == :FCALL && node.children.first == :transitions
      end
    end
  end
end
