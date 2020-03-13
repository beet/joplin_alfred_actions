require "spec_helper"

RSpec.describe Joplin::Base do
  class Joplin::ConcreteClass < Joplin::Base
    # Abstract method that should return a collection of Alfred::Item objects
    def alfred_items; end

    def note_files
      [].tap do |array|
        for_each_note do |note_file|
          array << note_file
        end
      end
    end
  end

  module Settings
    def base_directory
      method_missing(:base_directory)
    end
  end

  before do
    Alfred::Settings.extend(Settings)

    allow(Alfred::Settings).to receive(:base_directory).and_return(base_directory)
  end

  let(:alfred_item) { double(Alfred::Item, attributes: attributes) }
  let(:attributes) { { foo: "bar" } }
  let(:base_directory) { "/Library/Mobile Documents/iCloud~co~Joplin~Joplin/Documents" }

  subject(:concrete_class) { Joplin::ConcreteClass.new }

  context "#json" do
    let(:alfred_script_filter) {
      double(
        Alfred::ScriptFilter,
        items: alfred_script_filter_items,
        json: alfred_script_filter_json
      )
    }
    let(:alfred_script_filter_items) { double(Array) }
    let(:alfred_script_filter_json) { double("alfred_script_filter_json") }

    before do
      allow(Alfred::ScriptFilter).to receive(:new).and_return(alfred_script_filter)

      allow(concrete_class).to receive(:alfred_items).and_return([alfred_item])
    end

    it 'adds the concrete class alfred items to the Alfred script filter' do
      allow(alfred_script_filter).to receive(:json)

      expect(alfred_script_filter_items).to receive(:concat).with([alfred_item.attributes])

      concrete_class.json
    end

    it 'returns the Alfred script filter json' do
      allow(alfred_script_filter_items).to receive(:concat)
      
      expect(concrete_class.json).to eq(alfred_script_filter_json)
    end
  end

  context "text note iteration" do
    let(:notes_directory) { "#{ENV["HOME"]}#{base_directory}/*.md" }
    let(:note_file) { double(Joplin::NoteFile, filename: filename) }
    let(:filename) { "filename" }

    before do
      allow(Dir).to receive(:glob).with(notes_directory).and_yield(filename)

      allow(Joplin::NoteFile).to receive(:new).with(filename).and_return(note_file)
    end

    it 'yields a Joplin::NoteFile object instantiated with each filename in the text notes directory' do
      expect(concrete_class.note_files).to eq([note_file])
    end
  end
end
