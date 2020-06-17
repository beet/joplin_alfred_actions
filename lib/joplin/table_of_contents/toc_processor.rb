=begin

Service for recursively processing the child notes of a given note file and
generating a nested table of contents in Markdown bullet list format:

    Joplin::TocProcessor::TocProcessor.new(note_file).process

As it recursively processes its child notes, it will pass in the nesting
level, TOC string, and branch array.

The NESTING_LIMIT constant defines how many levels deep it will go, which
could be abstracted out to Alfred::Settings

=end
module Joplin
  module TableOfContents
    class TocProcessor
      attr_reader :note_file, :level, :toc, :branch

      NESTING_LIMIT = 5

      def initialize(note_file, level: nil, toc: nil, branch: nil)
        @note_file = note_file
        @level = level || 0
        @toc = toc || ""
        @branch = branch.dup || []
      end

      def process
        toc << note_file_link(note_file, indentation)

        branch << note_file

        process_child_notes

        toc
      end

      private

      def note_file_link(note_file, indentation)
        "#{indentation}* #{note_file.markdown_link}\n"
      end

      def indentation
        "  " * level
      end

      def process_child_notes
        return if child_notes.none?

        if level > NESTING_LIMIT
          toc << "#{indentation}  * _Skipped #{child_notes.size} child notes_\n"

          return
        end

        # Add all of this note's child notes to the branch before processing
        # them for scenarios where the child notes have links to each other,
        # which just clutters up the TOC and creates duplicate nested
        # branches
        branch.concat(child_notes)

        child_notes.each do |child_note|
          TocProcessor.new(child_note, level: level + 1, toc: toc, branch: branch).process
        end
      end

      def child_notes
        @child_notes ||= note_file.child_notes - branch
      end
    end
  end
end
