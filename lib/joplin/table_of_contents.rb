=begin

Abstraction layer for interacting with Joplin's notes through a table of
contents:

Fetch a Joplin::NoteFile instance for the given note ID. Will always return
the same instance, so if two different note files contain links to the same
file, .find_note() will return the same object.

    Joplin::TableOfContents.find_note("051c175223fc4987bbc8b2bb22356037")
    => <#Joplin::NoteFile>

Generate a Markdown table of contents from the path of a note file. Has a 5
second timeout in case of particularly large note structures.

    filename = "/Users/foo/Library/Mobile Documents/com~apple~CloudDocs/Docs/Joplin/051c175223fc4987bbc8b2bb22356037.md"
    Joplin::TableOfContents.process(filename)

=end
module Joplin
  module TableOfContents
    require 'timeout'

    TIMEOUT_SECONDS = 5

    class << self
      def find_note(id)
        note_files.detect do |note_file|
          note_file.id == id
        end
      end

      def process(path)
        begin
          Timeout::timeout(TIMEOUT_SECONDS) do
            TocProcessor.new(find_note(id_for_path(path))).process
          end
        rescue Timeout::Error
          "Failed to generate TOC in #{TIMEOUT_SECONDS} seconds"
        end
      end

      private

      def note_files
        @note_files ||= [].tap do |array|
          Dir.glob("#{ENV["HOME"]}#{Alfred::Settings.base_directory}/*#{Joplin::Base::EXT_NAME}") do |filename|
            note_file = Joplin::NoteFile.new(filename)

            array << note_file if note_file.is_note?
          end

          array.uniq!
        end
      end

      # The Joplin::NotesList argument to Alfred is actually the file's full
      # path when first invoking the TOC generator
      def id_for_path(path)
        path.split("/").last.chomp(Joplin::Base::EXT_NAME)
      end
    end
  end
end
