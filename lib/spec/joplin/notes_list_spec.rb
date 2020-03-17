require "spec_helper"

RSpec.describe Joplin::NotesList do
  subject(:wiki_links) { Joplin::NotesList.new }

  context "#alfred_items" do
    let(:note_file_1) {
      double(
        Joplin::NoteFile,
        heading: heading_1,
        basename: basename_1,
        filename: filename_1,
        is_note?: true
      )
    }
    let(:heading_1) { double("heading_1") }
    let(:basename_1) { double("basename_1") }
    let(:filename_1) { double("filename_1") }

    let(:note_file_2) {
      double(
        Joplin::NoteFile,
        heading: heading_2,
        basename: basename_2,
        filename: filename_2,
        is_note?: true
      )
    }
    let(:heading_2) { double("heading_2") }
    let(:basename_2) { double("basename_2") }
    let(:filename_2) { double("filename_2") }

    let(:note_file_3) {
      double(
        Joplin::NoteFile,
        heading: heading_3,
        basename: basename_3,
        filename: filename_3,
        is_note?: false
      )
    }
    let(:heading_3) { double("heading_3") }
    let(:basename_3) { double("basename_3") }
    let(:filename_3) { double("filename_3") }

    let(:alfred_item_1) { double(Alfred::Item, title: title_1) }
    let(:title_1) { "title_B" }

    let(:alfred_item_2) { double(Alfred::Item, title: title_2) }
    let(:title_2) { "title_A" }

    before do
      allow(Alfred::Item).to receive(:new)
        .with(
          heading_1,
          subtitle: basename_1,
          arg: filename_1
        )
        .and_return(alfred_item_1)

      allow(Alfred::Item).to receive(:new)
        .with(
          heading_2,
          subtitle: basename_2,
          arg: filename_2
        )
        .and_return(alfred_item_2)

      allow(wiki_links).to(
        receive(:for_each_note)
          .and_yield(note_file_1)
          .and_yield(note_file_2)
          .and_yield(note_file_3))
    end

    it "sorts a collection of Alfred::Item objects for each file note that is not metadata or an attachment" do
      expect(wiki_links.alfred_items).to eq([alfred_item_2, alfred_item_1])
    end
  end
end
