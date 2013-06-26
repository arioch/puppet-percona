require 'diff_matcher'
require 'rspec/matchers'

module RSpec
  module Matchers
    class BeMatching
      attr_reader :expected

      def initialize(expected, opts)
        @expected = expected
        @opts = opts.update(:color_enabled=>RSpec::configuration.color_enabled?)
      end

      def matches?(actual)
        @difference = DiffMatcher::Difference.new(expected, actual, @opts)
        @difference.matching?
      end

      def failure_message_for_should
        @difference.to_s
      end
    end

    def be_matching(expected, opts={})
      Matchers::BeMatching.new(expected, opts)
    end
  end
end

