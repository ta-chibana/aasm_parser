# frozen_string_literal: true

module AasmToPlantuml
  module Aasm
    class Event
      attr_reader :name

      class << self
        def parse(event_node)
          name = find_name_from_node(event_node)
          new(name: name, transitions_node: [])
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
      end

      def initialize(name:, transitions_node:)
        @name = name
        @transitions_node = transitions_node
      end
    end
  end
end
