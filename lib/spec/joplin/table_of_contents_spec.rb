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
end
