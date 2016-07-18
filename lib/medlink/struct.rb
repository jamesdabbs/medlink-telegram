# This magik packages up the base object model used throughout
# - objects have a collection of fields
# - `initialize` receives each field as a keyword argument and stores it
# - objects are always immutable
# - `with` is a non-destructive `merge` on fields
#
# TODO:
# - `with` should error explicitly if given bad kwargs
module Medlink
  def self.struct *fields
    Class.new do
      attr_reader *fields

      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def initialize(#{fields.map { |f| "#{f}: " }.join(", ")})
          #{fields.map { |f| "@#{f} = #{f}" }.join "\n"}
          freeze
        end

        def with #{fields.map { |f| "#{f}: nil" }.join(", ")}
          self.class.new(
            #{fields.map { |f| "#{f}: #{f} || self.#{f}" }.join(", ")}
          )
        end
      METHOD
    end
  end
end
