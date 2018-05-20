# Copyright 2018 Daniel Azuma
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# * Neither the name of the copyright holder, nor the names of any other
#   contributors to this software, may be used to endorse or promote products
#   derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
;

require "optparse"

require "toys/utils/wrappable_string"

module Toys
  class Tool
    ##
    # Representation of a formal positional argument
    #
    class ArgDefinition
      ##
      # Create an ArgDefinition
      # @private
      #
      def initialize(key, type, accept, default, desc, long_desc, display_name)
        @key = key
        @type = type
        @accept = accept
        @default = default
        @desc = Utils::WrappableString.make(desc)
        @long_desc = Utils::WrappableString.make_array(long_desc)
        @display_name = display_name || key.to_s.tr("-", "_").gsub(/\W/, "").upcase
      end

      ##
      # Returns the key.
      # @return [Symbol]
      #
      attr_reader :key

      ##
      # Type of this argument.
      # @return [:required,:optional,:remaining]
      #
      attr_reader :type

      ##
      # Returns the acceptor, which may be `nil`.
      # @return [Object]
      #
      attr_accessor :accept

      ##
      # Returns the default value, which may be `nil`.
      # @return [Object]
      #
      attr_reader :default

      ##
      # Returns the short description string.
      # @return [Toys::Utils::WrappableString]
      #
      attr_reader :desc

      ##
      # Returns the long description strings as an array.
      # @return [Array<Toys::Utils::WrappableString>]
      #
      attr_reader :long_desc

      ##
      # Returns the displayable name.
      # @return [String]
      #
      attr_accessor :display_name

      ##
      # Process the given value through the acceptor.
      # May raise an exception if the acceptor rejected the input.
      #
      # @param [String] input Input value
      # @return [Object] Accepted value
      #
      def process_value(input)
        return input unless accept
        result = input
        optparse = ::OptionParser.new
        optparse.accept(accept) if accept.is_a?(Acceptor)
        optparse.on("--abc=VALUE", accept) { |v| result = v }
        optparse.parse(["--abc", input])
        result
      end

      ##
      # Set description
      # @param [String,Array<String>,Toys::Utils::WrappableString] desc
      #
      def desc=(desc)
        @desc = Utils::WrappableString.make(desc)
      end

      ##
      # Set long description
      # @param [Array<String,Array<String>,Toys::Utils::WrappableString>] long_desc
      #
      def long_desc=(long_desc)
        @long_desc = Utils::WrappableString.make_array(long_desc)
      end
    end
  end
end