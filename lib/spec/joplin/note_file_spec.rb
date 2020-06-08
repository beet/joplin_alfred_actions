RSpec.describe Joplin::NoteFile do
  let(:filename) { "foo/bar/#{basename}" }
  let(:basename) { "#{id}#{Joplin::Base::EXT_NAME}" }
  let(:id) { "8775cd41e1d84ac2b631473f88fd8095" }

  subject(:note_file) { Joplin::NoteFile.new(filename) }

  context "#contents" do
    let(:contents) { double("contents") }

    before do
      allow(File).to receive(:read).with(filename).and_return(contents)
    end

    it 'is the file contents' do
      expect(note_file.contents).to eq(contents)
    end
  end

  context "#is_metadata?" do
    before do
      allow(note_file).to receive(:contents).and_return(contents)
    end

    context "when the first line of the contents contains 'id: '" do
      let(:contents) { "id: foo\nline 2\n" }

      it 'is true' do
        expect(note_file.is_metadata?).to be_truthy
      end
    end

    context "when the first line of the contents does not contain 'id: '" do
      let(:contents) { "Line 1\nline 2\n" }

      it 'is false' do
        expect(note_file.is_metadata?).to be_falsey
      end
    end
  end

  context "#is_attachment?" do
    before do
      allow(note_file).to receive(:contents).and_return(contents)
    end

    context "when the contents contain a mime: line" do
      let(:contents) { "Line 1\nmime: foo\nLine 3\n" }

      it 'is true' do
        expect(note_file.is_attachment?).to be_truthy
      end
    end

    context "when the contents do not contain a mime: line" do
      let(:contents) { "Line 1\nLine 2\nLine 3\n" }

      it 'is false' do
        expect(note_file.is_attachment?).to be_falsey
      end
    end
  end

  context "#is_note?" do
    before do
      allow(note_file).to receive(:is_metadata?).and_return(is_metadata)
      allow(note_file).to receive(:is_attachment?).and_return(is_attachment)
    end

    let(:is_metadata) { false }
    let(:is_attachment) { false }

    context "when the note file is metadata" do
      let(:is_metadata) { true }

      it 'is false' do
        expect(note_file).to_not be_is_note
      end
    end

    context "when the note file is an attachment" do
      let(:is_attachment) { true }

      it 'is false' do
        expect(note_file).to_not be_is_note
      end
    end

    context "when the note file is not metadata or an attachment" do
      before do
        allow(note_file).to receive(:has_heading?).and_return(has_heading)
      end

      context "when it does not have a heading" do
        let(:has_heading) { false }

        it 'is false' do
          expect(note_file).to_not be_is_note
        end
      end

      context "when it has a heading" do
        let(:has_heading) { true }

        it 'is true' do
          expect(note_file).to be_is_note
        end
      end
    end
  end

  context "#heading" do
    let(:file_contents) { double("file_contents") }
    let(:heading_component) { double(Joplin::NoteComponents::Heading, contents: heading_contents) }
    let(:heading_contents) { double("heading_contents") }

    before do
      allow(note_file).to receive(:contents).and_return(file_contents)

      allow(Joplin::NoteComponents::Heading).to receive(:new).with(file_contents).and_return(heading_component)
    end

    it 'extracts the heading from the file contents with Joplin::NoteComponents::Heading' do
      expect(note_file.heading).to eq(heading_contents)
    end
  end

  context "#has_heading?" do
    before do
      allow(note_file).to receive(:heading).and_return(heading)
    end

    context "when the heading has a value" do
      let(:heading) { "heading" }

      it 'is true' do
        expect(note_file.has_heading?).to be_truthy
      end
    end

    context "when the heading is blank" do
      let(:heading) { "" }

      it 'is false' do
        expect(note_file.has_heading?).to be_falsey
      end
    end
  end

  context "#basename" do
    it 'extracts the basename from the filename' do
      expect(note_file.basename).to eq(basename)
    end
  end

  context "#id" do
    it 'extracts the Joplin ID from the filename' do
      expect(note_file.id).to eq(id)
    end
  end

  context "#markdown_link" do
    let(:markdown_link) { "[#{heading}](:/#{id})" }
    let(:heading) { "heading" }
    let(:id) { "id" }

    before do
      allow(note_file).to receive(:heading).and_return(heading)
      allow(note_file).to receive(:id).and_return(id)
    end

    it 'constructs a Markdown link from the heading and ID' do
      expect(note_file.markdown_link).to eq(markdown_link)
    end
  end

  context "#child_notes" do
    let(:note_contents) { double("note_contents") }
    let(:note_links_component) { double(Joplin::NoteComponents::NoteLinks, child_notes: child_notes) }
    let(:child_notes) { double("child_notes") }

    before do
      allow(note_file).to receive(:contents).and_return(note_contents)

      allow(Joplin::NoteComponents::NoteLinks).to receive(:new).with(note_file.contents).and_return(note_links_component)
    end

    it 'is a collection of child notes provided by Joplin::NoteComponents::NoteLinks#child_notes' do
      expect(note_file.child_notes).to eq(child_notes)
    end
  end

  context "comparisons" do
    let(:note1) { Joplin::NoteFile.new("") }
    let(:note2) { Joplin::NoteFile.new("") }

    context "sort" do
      before do
        allow(note1).to receive(:heading).and_return("Zelta")
        allow(note2).to receive(:heading).and_return("Alpha")
      end

      it 'uses the note heading' do
        expect([note1, note2].sort).to eq([note2, note1])
      end
    end

    context "equality" do
      before do
        allow(note1).to receive(:id).and_return(note1_id)
        allow(note2).to receive(:id).and_return(note2_id)
      end

      context "for notes with the same ID" do
        let(:note1_id) { "123" }
        let(:note2_id) { "123" }

        it 'is true' do
          expect(note1 == note2).to eq(true)
        end
      end

      context "for notes with different IDs" do
        let(:note1_id) { "123" }
        let(:note2_id) { "234" }

        it 'is false' do
          expect(note1 == note2).to eq(false)
        end
      end
    end

    context "uniqueness" do
      before do
        allow(note1).to receive(:id).and_return("123")
      end

      it 'removes duplicates with the same ID' do
        expect([note1, note1, note1].uniq).to eq([note1])
      end
    end
  end
end
