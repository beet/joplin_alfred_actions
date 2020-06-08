RSpec.describe Joplin::TableOfContents do
  let(:filename) { "#{id}#{Joplin::Base::EXT_NAME}" }
  let(:id) { "051c175223fc4987bbc8b2bb22356037" }

  context "find_note" do
    let(:text_note_file) { Joplin::NoteFile.new(text_note_file_filename) }
    let(:text_note_file_filename) { "text_note_file/#{filename}" }
    let(:not_note_file) { Joplin::NoteFile.new(not_note_file_filename) }
    let(:not_note_file_filename) { "not_note_file/#{filename}" }
    let(:notes_dir) { "#{ENV["HOME"]}#{Alfred::Settings.base_directory}/*#{Joplin::Base::EXT_NAME}" }
    let(:base_directory) { "/base_directory" }

    before do
      ENV["base_directory"] = base_directory

      allow(text_note_file).to receive(:is_note?).and_return(true)
      allow(not_note_file).to receive(:is_note?).and_return(false)

      allow(Dir).to receive(:glob).
        with(notes_dir).
        and_yield(text_note_file_filename).
        and_yield(not_note_file_filename)
    end

    it 'fetches the Joplin::NoteFile instance with the matching ID' do
      allow(Joplin::NoteFile).to receive(:new).with(text_note_file_filename).and_return(text_note_file)
      allow(Joplin::NoteFile).to receive(:new).with(not_note_file_filename).and_return(not_note_file)

      expect(Joplin::TableOfContents.find_note(id)).to eq(text_note_file)
    end

    it 'has the same object_id (is the same Joplin::NoteFile instance) each time' do
      allow_any_instance_of(Joplin::NoteFile).to receive(:is_note?).and_return(true)

      expect(Joplin::TableOfContents.find_note(id).object_id).to eq(Joplin::TableOfContents.find_note(id).object_id)
    end
  end

  context "process" do
    let(:path) { "/Users/foo/Library/Mobile Documents/com~apple~CloudDocs/Docs/Joplin/#{id}.md" }
    let(:note_file) { double(Joplin::NoteFile) }
    let(:toc_processor) { double(Joplin::TableOfContents::TocProcessor) }

    before do
      allow(Joplin::TableOfContents).to receive(:find_note).with(id).and_return(note_file)

      allow(Joplin::TableOfContents::TocProcessor).to receive(:new).with(note_file).and_return(toc_processor)
    end

    it 'extracts the note ID from the path argument passes the matching note into Joplin::TableOfContents::TocProcessor' do
      expect(toc_processor).to receive(:process)

      Joplin::TableOfContents.process(path)
    end


    context "when the processor takes more than #{Joplin::TableOfContents::TIMEOUT_SECONDS} seconds" do
      before do
        allow(toc_processor).to receive(:process).and_raise(Timeout::Error)
      end

      it 'times out and returns an error message' do
        expect(Joplin::TableOfContents.process(path)).to eq("Failed to generate TOC in #{Joplin::TableOfContents::TIMEOUT_SECONDS} seconds")
      end
    end
  end
end
