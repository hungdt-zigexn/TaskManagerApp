require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'associations' do
    it { should have_many(:taggings).dependent(:destroy) }
    it { should have_many(:tags).through(:taggings) }
  end

  describe '#tag_list' do
    let(:task) { create(:task) }
    let!(:tag1) { create(:tag, name: 'urgent') }
    let!(:tag2) { create(:tag, name: 'feature') }

    before do
      task.tags << [ tag1, tag2 ]
    end

    it 'returns comma-separated list of tag names' do
      expect(task.tag_list).to eq('urgent, feature')
    end
  end

  describe '#tag_list=' do
    let(:task) { create(:task) }

    context 'when adding new tags' do
      it 'creates new tags if they dont exist' do
        expect {
          task.tag_list = 'new_tag1, new_tag2'
        }.to change(Tag, :count).by(2)
      end

      it 'associates existing tags' do
        existing_tag = create(:tag, name: 'existing')
        task.tag_list = 'existing, new_tag'
        expect(task.tags.pluck(:name)).to include('existing', 'new_tag')
      end
    end

    context 'when updating tags' do
      before do
        task.tags << create(:tag, name: 'old_tag')
      end

      it 'replaces old tags with new ones' do
        task.tag_list = 'new_tag1, new_tag2'
        expect(task.tag_list).to eq('new_tag1, new_tag2')
        expect(task.tags.pluck(:name)).not_to include('old_tag')
      end
    end
  end
end
