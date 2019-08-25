# frozen_string_literal: true

module AasmToPlantuml
  module Aasm
    class Block
      def initialize(ast_block)
        @root = ast_block
      end

      def initial_state
        # TODO: return state with `initial: true`
      end

      def states
        children
          .select(&method(:calling_state_node?))
          .flat_map { |node| node.children.last.children }
          .select(&method(:state_node?))
          .flat_map(&:children)
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
    end
  end
end
