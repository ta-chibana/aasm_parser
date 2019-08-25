# frozen_string_literal: true

module AasmToPlantuml
  module Aasm
    class Block
      def initialize(ast_block)
        @root = ast_block
      end

      def initial_state
        children
          .select(&method(:calling_state_node?))
          .find(&method(:initial_state_node?))
          .children
          .last
          .children
          .find(&method(:state_node?))
          .children
          .first
      end

      def states
        children
          .select(&method(:calling_state_node?))
          .flat_map { |node| node.children.last.children }
          .select(&method(:state_node?))
          .flat_map(&:children)
      end

      def events
        event_nodes.map { |event_node| Event.parse(event_node) }
      end

      private

      attr_reader :root

      def children
        @children ||= root.children
      end

      def calling_state_node?(node)
        node.type == :FCALL && node.children.first == :state
      end

      def state_node?(node)
        node.present? && node.type == :LIT
      end

      def initial_state_node?(node)
        return false unless node.type == :FCALL

        hash_node = node
                    .children
                    .last
                    .children
                    .find { |n| n&.type == :HASH }

        return false if hash_node.nil?

        hash_node.children.first.children.one? { |n| n&.type == :TRUE }
      end

      def event_nodes
        children.select { |node| node.type == :ITER }
      end
    end
  end
end
