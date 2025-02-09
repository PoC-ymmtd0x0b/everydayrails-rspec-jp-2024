require 'rails_helper'

RSpec.describe Note, type: :model do
  it '有効なファクトリを持つこと' do
    note = FactoryBot.build(:note)
    expect(note).to be_valid
  end

  it 'ユーザー、プロジェクト、メッセージがあれば有効な状態であること' do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project)
    note = Note.new(message: 'This note is valid.', user:, project:)
    expect(note).to be_valid
  end

  it 'メッセージが無ければ無効な状態であること' do
    note = FactoryBot.build(:note, message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe '#user_name' do
    it '名前の取得をメモを作成したユーザーに移譲すること' do
      user = instance_double('User', name: 'Fake User')
      note = Note.new
      allow(note).to receive(:user).and_return(user)
      expect(note.user_name).to eq 'Fake User'
    end
  end

  describe '.search' do
    before do
      @note1 = FactoryBot.create(:note, message: 'This is first note.')
      @note2 = FactoryBot.create(:note, message: 'This is second note.')
      @note3 = FactoryBot.create(:note, message: 'First, preheat the oven.')
    end

    context '検索文字列に一致するデータが"見つかる"とき' do
      it '該当するノートを含んだコレクションで返すこと' do
        expect(Note.search('first')).to include(@note1, @note3)
        expect(Note.search('first')).to_not include(@note2)
      end
    end

    context '検索文字列に一致するデータが"見つからない"とき' do
      it '空のコレクションを返すこと' do
        expect(Note.search('message')).to be_empty
      end
    end
  end
end
