=begin

Instantiate with a note's contents, and it will return the first instance of a
level 1 heading:

    > Joplin::NoteComponents::Heading.new(note_contents).contents
    => "# Foo"

=end
module Joplin
  module NoteComponents
    class Heading < Base
      def contents
        first_heading_string.gsub(/^# /, "")
      end

      private

      def first_heading_string
        first_heading.to_s
      end

      def first_heading
        headings.first
      end

      def headings
        note_contents.scan(/^#[\s]+.*$/)
      end
    end
  end
end
