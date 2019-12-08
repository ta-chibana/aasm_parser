# frozen_string_literal: true

module AasmToPlantuml
  module Aasm
    class State
      def initialize(state_node)
        @node = state_node
      end

      def names
        state_arguments
          .select { |e| e.type == :LIT }
          .flat_map(&:children)
      end

      def initial_state?
        return false if options.nil?

        lit_node_index = options.find_index do |e|
          e.type == :LIT && e.children[0] == :initial
        end

        return false if lit_node_index.nil?

        options[lit_node_index + 1].type == :TRUE
      end

      private

      def state_arguments
        @node
          .children
          .last # type ARRAY
          .children
          .compact
      end

      def options
        @options ||= begin
          hash_node = state_arguments.find { |e| e.type == :HASH }
          return [] if hash_node.nil?

          hash_node
            .children
            .first # type ARRAY
            .children
        end
      end
    end
  end
end
