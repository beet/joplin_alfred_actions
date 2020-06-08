=begin

Abstraction layer for interacting with Joplin's notes through a table of
contents:

Fetch a Joplin::NoteFile instance for the given note ID. Will always return
the same instance, so if two different note files contain links to the same
file, .find_note() will return the same object.

    Joplin::TableOfContents.find_note("051c175223fc4987bbc8b2bb22356037")
    => <#Joplin::NoteFile>

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
    end
  end
end
