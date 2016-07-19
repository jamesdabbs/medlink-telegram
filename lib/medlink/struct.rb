# This magik packages up the base object model used throughout
# - objects have a collection of fields
# - `initialize` receives each field as a keyword argument and stores it
# - objects are always immutable
# - `with` is a non-destructive `merge` on fields
module Medlink
  def self.struct *fields
    Class.new do
      attr_reader *fields

      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        # Required keyword args for each field
        def initialize(#{fields.map { |f| "#{f}: " }.join(", ")})
          #{fields.map { |f| "@#{f} = #{f}" }.join "\n"}
          freeze
        end

        # Optional keyword args for each field
        def with #{fields.map { |f| "#{f}: nil" }.join(", ")}
          self.class.new({
            #{fields.map { |f| "#{f}: #{f} || @#{f}" }.join ",\n"}
          })
        end

        def self.fields
          %i(#{fields.map(&:to_s).join " "})
        end
      METHOD

      def to_h
        self.class.fields.each_with_object({}) { |f,h| h[f] = public_send(f) }
      end

      def self.from_json j
        new fields.each_with_object({}) { |f,h| h[f] = j[f.to_s] }
      end
    end
  end
end
