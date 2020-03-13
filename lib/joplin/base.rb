=begin

Template class for interacting with Joplin files.

Concrete classes must implement a #alfred_items abstract method that returns
an array of Alfred::Item instances.

Provides the #for_each_note block method that iterates through all Joplin
note files and yields a Joplin::NoteFile instance.

=end
module Joplin
  class Base
    attr_reader :alfred_script_filter

    def initialize
      @alfred_script_filter = Alfred::ScriptFilter.new
    end

    def json
      alfred_script_filter.items.concat(alfred_items.map(&:attributes))

      alfred_script_filter.json
    end

    private

    def for_each_note(&block)
      Dir.glob(notes_directory) do |filename|
        yield Joplin::NoteFile.new(filename)
      end
    end

    def notes_directory
      "#{base_directory}/*.md"
    end

    def base_directory
      "#{ENV["HOME"]}#{Alfred::Settings.base_directory}"
    end
  end
end
