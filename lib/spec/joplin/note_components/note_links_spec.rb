RSpec.describe Joplin::NoteComponents::NoteLinks do
  let(:contents) { %(
    # Heading

    Lorem ipsum dolor sit amet, consectetur adipiscing elit.

    * [#{heading_1}](:/#{id_1})
    * [#{heading_2}](:/#{id_2})
    * [#{heading_3}](:/#{id_3})
  ) }
  let(:id_1) { "68452624633787105385534405760771" }
  let(:id_2) { "26124086375045357804537730673805" }
  let(:id_3) { "52236057733770220525440233834384" }
  let(:heading_1) { "Heading 3" }
  let(:heading_2) { "Heading 2" }
  let(:heading_3) { "Heading 1" }
  let(:note_1) { Joplin::NoteFile.new(filename = "") }
  let(:note_2) { Joplin::NoteFile.new(filename = "") }
  let(:note_3) { Joplin::NoteFile.new(filename = "") }

  subject(:note_links) { Joplin::NoteComponents::NoteLinks.new(contents) }

  before do
    allow(Joplin::TableOfContents).to receive(:find_note).with(id_1).and_return(note_1)
    allow(Joplin::TableOfContents).to receive(:find_note).with(id_2).and_return(note_2)
    allow(Joplin::TableOfContents).to receive(:find_note).with(id_3).and_return(note_3)

    allow(note_1).to receive(:id).and_return(id_1)
    allow(note_2).to receive(:id).and_return(id_2)
    allow(note_3).to receive(:id).and_return(id_3)

    allow(note_1).to receive(:heading).and_return(heading_1)
    allow(note_2).to receive(:heading).and_return(heading_2)
    allow(note_3).to receive(:heading).and_return(heading_3)
  end

  context "#child_notes" do
    it 'is a sorted collection of Joplin::NoteFile objects' do
      expect(note_links.child_notes).to eq([note_3, note_2, note_1])
    end
  end
end
