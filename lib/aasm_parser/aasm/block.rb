# frozen_string_literal: true

class AasmParser
  module Aasm
    class Block
      class << self
        def parse(aasm_node)
          new(find_aasm_block_from_node(aasm_node))
        end

        private

        def find_aasm_block_from_node(node)
          return nil unless node.respond_to?(:type)
          return node if block_node?(node)

          find_aasm_block_from_children(node.children)
        end

        def find_aasm_block_from_children(children)
          return nil if children.blank?

          head, *tail = children
          result = find_aasm_block_from_node(head)
          return result if result

          find_aasm_block_from_children(tail)
        end

        def block_node?(node)
          node.type == :BLOCK
        end
      end

      def initialize(ast_block)
        @ast = ast_block
      end

      def initial_state
        state = states.find(&:initial_state?)
        return nil if state.nil?

        state.names.first
      end

      def states
        state_nodes.map { |node| State.new(node) }
      end

      def state_names
        states.flat_map(&:names)
      end

      def events
        event_nodes.map { |event_node| Event.new(event_node) }
      end

      private

      attr_reader :ast

      def children
        @children ||= ast.children
      end

      def state_nodes
        children.select do |node|
          node.type == :FCALL && node.children.first == :state
        end
      end

      def event_nodes
        children.select { |node| node.type == :ITER }
      end
    end
  end
end
