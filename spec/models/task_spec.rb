require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }

  it 'プロジェクトと名前があれば有効な状態であること' do
    task = Task.new(name: 'Test task', project: project)
    expect(task).to be_valid
  end

  it 'プロジェクトがなければ無効な状態であること' do
    task = Task.new(project: nil)
    task.valid?
    expect(task.errors[:project]).to include('must exist')
  end

  it '名前がなければ無効な状態であること' do
    task = Task.new(name: nil)
    task.valid?
    expect(task.errors[:name]).to include("can't be blank")
  end

  describe '.search' do
    let!(:note1) do
      FactoryBot.create(:note, message: 'This is the first note.',
                               user: user,
                               project: project)
    end

    let!(:note2) do
      FactoryBot.create(:note, message: 'This is the second note.',
                               user: user,
                               project: project)
    end

    let!(:note3) do
      FactoryBot.create(:note, message: 'First, preheat the oven.',
                               user: user,
                               project: project)
    end

    context '一致するデータが見つかる場合' do
      it '検索文字列に一致するメモを返すこと' do
        expect(Note.search('first')).to include(note1, note3)
      end
    end

    context '一致するデータが１件も見つからない場合' do
      it '空のコレクションを返すこと' do
        expect(Note.search('hoge')).to be_empty
        expect(Note.count).to eq 3
      end
    end
  end
end
