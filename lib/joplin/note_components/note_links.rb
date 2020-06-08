=begin

This component returns a collection of Joplin::NoteFile objects for all notes
that a note file has outbound links to:

    Joplin::NoteComponents::NoteLinks.new(contents).child_notes
    =>  [<#Jolin::NoteFile>, <#Jolin::NoteFile>, <#Jolin::NoteFile>]

=end
module Joplin
  module NoteComponents
    class NoteLinks < Base
      def child_notes
        ids.map do |id|
          Joplin::TableOfContents.find_note(id)
        end.compact.sort
      end

      private

      # Map the links like "[text](:/119ddf766b7142f1bd1342e7bde12d82)" to a
      # collection of ID strings like ["119ddf766b7142f1bd1342e7bde12d82"]
      def ids
        links.map do |link|
          link.match(/\[[^\]]+\]\(:\/([^)]+)\)/)[1]
        end.uniq
      end

      # Links to nother Joplin notes look like
      # [text](:/119ddf766b7142f1bd1342e7bde12d82)
      def links
        note_contents.scan(/\[[^\]]+\]\(:\/[^)]+\)/)
      end
    end
  end
end
