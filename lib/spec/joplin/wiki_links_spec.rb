require "spec_helper"

RSpec.describe Joplin::WikiLinks do
  subject(:wiki_links) { Joplin::WikiLinks.new }

  context "#alfred_items" do
    let(:note_file_1) {
      double(
        Joplin::NoteFile,
        heading: heading_1,
        basename: basename_1,
        markdown_link: markdown_link_1,
        is_note?: true
      )
    }
    let(:heading_1) { double("heading_1") }
    let(:basename_1) { double("basename_1") }
    let(:markdown_link_1) { double("markdown_link_1") }

    let(:note_file_2) {
      double(
        Joplin::NoteFile,
        heading: heading_2,
        basename: basename_2,
        markdown_link: markdown_link_2,
        is_note?: true
      )
    }
    let(:heading_2) { double("heading_2") }
    let(:basename_2) { double("basename_2") }
    let(:markdown_link_2) { double("markdown_link_2") }

    let(:note_file_3) {
      double(
        Joplin::NoteFile,
        heading: heading_3,
        basename: basename_3,
        markdown_link: markdown_link_3,
        is_note?: false
      )
    }
    let(:heading_3) { double("heading_3") }
    let(:basename_3) { double("basename_3") }
    let(:markdown_link_3) { double("markdown_link_3") }

    let(:alfred_item_1) { double(Alfred::Item, title: title_1) }
    let(:title_1) { "title_B" }

    let(:alfred_item_2) { double(Alfred::Item, title: title_2) }
    let(:title_2) { "title_A" }

    before do
      allow(Alfred::Item).to receive(:new)
        .with(
          heading_1,
          subtitle: basename_1,
          arg: markdown_link_1
        )
        .and_return(alfred_item_1)

      allow(Alfred::Item).to receive(:new)
        .with(
          heading_2,
          subtitle: basename_2,
          arg: markdown_link_2
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
