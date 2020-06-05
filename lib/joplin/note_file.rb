=begin

PORO to encapsulate a note file:

    note_file = Joplin::NoteFile.new(filename)

    note_file.contents
    => <#String>

    note_file.basename
    => "foo.txt"

    note_file.heading
    => "# Foo"

=end
module Joplin
  class NoteFile
    include Comparable

    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    def contents
      @contents ||= File.read(filename)
    end

    def is_note?
      !is_metadata? && !is_attachment?  && has_heading?
    end

    def is_metadata?
      content_lines.first.match?(/^id:\s/)
    end

    def is_attachment?
      content_lines.any? do |line|
        line.match?(/^mime:\s/)
      end
    end

    def markdown_link
      "[#{heading}](:/#{id})"
    end

    def has_heading?
      heading != ""
    end

    def heading
      NoteComponents::Heading.new(contents).contents
    end

    def id
      basename.gsub(Joplin::Base::EXT_NAME, "")
    end

    def basename
      File.basename(filename)
    end

    def <=>(other_note)
      heading <=> other_note.heading
    end

    def ==(other_note)
      id == other_note.id
    end

    private

    def content_lines
      @content_lines ||= contents.split("\n")
    end
  end
end
