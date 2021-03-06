require "spec_helper"

RSpec.describe Joplin::NoteComponents::Heading do
  let(:note_contents) { "# Heading 1\n\n# Another Heading 1\n\nBody\n\n## Heading 2\n\n### Heading 3\n" }

  subject(:component) { Joplin::NoteComponents::Heading.new(note_contents) }

  context "#contents" do
    it 'extracts the first heading 1 from the note contents' do
      expect(component.contents).to eq("Heading 1")
    end

    context "when the note contents do not contain a Markdown heading" do
      let(:note_contents) { "Body\n\n" }

      it 'is blank' do
        expect(component.contents).to eq("")
      end
    end
  end
end
