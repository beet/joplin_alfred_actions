RSpec.describe Joplin::NoteFile do
  let(:filename) { "foo/bar/#{basename}" }
  let(:basename) { "#{id}#{Joplin::NoteFile::EXT_NAME}" }
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
end
