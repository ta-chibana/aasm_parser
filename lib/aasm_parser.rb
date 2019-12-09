# frozen_string_literal: true

require 'aasm_parser/version'
require 'aasm_parser/aasm_node_finder'
require 'aasm_parser/aasm/block'
require 'aasm_parser/aasm/state'
require 'aasm_parser/aasm/event'
require 'aasm_parser/aasm/transition'
require 'active_support/core_ext/object/blank'

class AasmParser
  def self.parse_file(path)
    root = RubyVM::AbstractSyntaxTree.parse_file(path)
    AasmNodeFinder.call(root)
  end
end
