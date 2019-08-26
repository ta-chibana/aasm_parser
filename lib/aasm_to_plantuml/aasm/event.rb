# frozen_string_literal: true

module AasmToPlantuml
  module Aasm
    class Event
      attr_reader :name, :transitions_node

      class << self
        def parse(event_node)
          name = find_name_from_node(event_node)
          transtions_node = find_transitions_node_from_node(event_node)
          new(name: name, transitions_node: transtions_node)
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

        def find_transitions_node_from_node(node)
          return nil unless node.respond_to?(:type)
          return node if transitions_node?(node)

          find_transitions_node_from_children(node.children)
        end

        def find_transitions_node_from_children(children)
          return nil if children.blank?

          head, *tail = children
          result = find_transitions_node_from_node(head)
          return result if result

          find_transitions_node_from_children(tail)
        end

        def transitions_node?(node)
          node.type == :FCALL && node.children.first == :transitions
        end
      end

      def initialize(name:, transitions_node:)
        @name = name
        @transitions_node = transitions_node
      end

      def transitions
        # TODO: implements it
      end
    end
  end
end
