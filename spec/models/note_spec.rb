require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @user = User.create!(first_name: 'tanaka',
                        last_name:  'taro',
                        email:      'taro@example.com',
                        password:   'foobar')

    @project = @user.projects.create!(name: 'Test Project')
  end

  it 'ユーザー、プロジェクト、メッセージがあれば有効な状態であること' do
    note = Note.new(message: 'This note is valid.', user: @user, project: @project)
    expect(note).to be_valid
  end

  it 'メッセージが無ければ無効な状態であること' do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe '.search' do
    before do
      @note1 = @project.notes.create!(message: 'This is first note.', user: @user)
      @note2 = @project.notes.create!(message: 'This is second note.', user: @user)
      @note3 = @project.notes.create!(message: 'First, preheat the oven.', user: @user)
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
