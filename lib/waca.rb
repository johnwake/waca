require "waca/version"

module Waca
  class JsonValidator
    class << self
      def validate(json, json_definition)
        fail 'missing definition' if json_definition.nil?

        case json_definition
          when Array
            validate_collection_with(json, json_definition) do |element|
              validate(element, json_definition.first)
            end
          when Hash
            return false unless json.nil? || json.is_a?(Hash) && (json.count == json_definition.count)

            validate_collection_with(json, json_definition) do |(element_key, element_value)|
              validate(element_value, json_definition[element_key])
            end
          when String
            _validate(json, json_definition)
        end
      end

      private

      def validate_collection_with(collection, collection_definition)
        return true if collection.nil?

        if collection.is_a?(collection_definition.class)
          collection.reduce(true) do |_memo, element|
            yield(element) || break
          end
        end
      end

      def _validate(element, json_definition)
        definition = json_definition.capitalize

        case definition
          when %r{Integer|Float}
            element.is_a? const_get(definition)
          when 'String'
            element.is_a?(NilClass) || element.is_a?(String)
          when 'Boolean'
            element.is_a?(TrueClass) || element.is_a?(FalseClass)
          when %r{Date|Datetime}
            element.is_a?(String) && validate_datetime?(element) || element.is_a?(NilClass)
          else
            fail 'This is not a supported type'
        end
      end

      def validate_datetime?(value)
        DateTime.parse(value)
        true
      rescue
        false
      end
    end
  end
end
