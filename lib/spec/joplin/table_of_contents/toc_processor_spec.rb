RSpec.describe Joplin::TableOfContents::TocProcessor do
  context "#process" do
    context "when processing the top level note file" do
      let(:note_file) { double(Joplin::NoteFile, markdown_link: markdown_link, child_notes: child_notes) }
      let(:markdown_link) { "markdown_link" }
      let(:child_notes) { [] }

      subject(:toc_processor) { Joplin::TableOfContents::TocProcessor.new(note_file) }

      it 'adds a link to the note file to the TOC' do
        expect(toc_processor.process).to eq("* #{markdown_link}\n")
      end

      it 'adds the note file to the branch array' do
        toc_processor.process

        expect(toc_processor.branch).to include(note_file)
      end

      context "child note processing" do
        let(:child_notes) { [child_note] }
        let(:child_note) { double(Joplin::NoteFile) }
        let(:nesting_level) { 1 }

        before do
          allow(Joplin::TableOfContents::TocProcessor).to receive(:new).with(
            child_note,
            level: nesting_level,
            toc: toc_processor.toc,
            branch: toc_processor.branch
          ).and_return(child_note)
        end

        it 'processes the child notes with the nesting level incremented by one and the toc and branch objects' do
          expect(child_note).to receive(:process)

          toc_processor.process
        end

        context "for child notes that have already been processed in the current branch" do
          before do
            toc_processor.branch << child_note
          end

          it 'excludes any notes already processed in the current branch' do
            expect(child_note).to_not receive(:process)

            toc_processor.process
          end
        end

        context "when the nesting level is over #{Joplin::TableOfContents::TocProcessor::NESTING_LIMIT}" do
          let(:nesting_level) { Joplin::TableOfContents::TocProcessor::NESTING_LIMIT + 1 }
          let(:child_markdown_link) { "child_markdown_link" }

          before do
            allow(child_note).to receive(:markdown_link).and_return(child_markdown_link)
          end

          subject(:toc_processor) { Joplin::TableOfContents::TocProcessor.new(note_file, level: nesting_level) }

          it 'adds an indented skipped notes line to the TOC' do
            expect(toc_processor.process).to include("    * _Skipped 1 child notes_")
          end
        end
      end
    end
  end
end
