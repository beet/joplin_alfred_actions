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
    EXT_NAME = ".md"

    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    def contents
      @contents ||= File.read(filename)
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

    def heading
      NoteComponents::Heading.new(contents).contents
    end

    def id
      basename.gsub(EXT_NAME, "")
    end

    def basename
      File.basename(filename)
    end

    private

    def content_lines
      @content_lines ||= contents.split("\n")
    end
  end
end
