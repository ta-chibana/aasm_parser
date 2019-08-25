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
        state_nodes.flat_map do |node|
          node
            .children
            .last
            .children
            .flat_map { |lit| lit.present? ? lit.children : nil }
        end.compact
      end

      private

      attr_reader :root

      def children
        @children ||= root.children
      end

      def state_nodes
        children.select do |node|
          node.type == :FCALL && node.children.first == :state
        end
      end
    end
  end
end
