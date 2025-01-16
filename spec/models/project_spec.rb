require 'rails_helper'

RSpec.describe Project, type: :model do
  it '有効なファクトリを持つこと' do
    project = FactoryBot.build(:project)
    expect(project).to be_valid
  end

  it 'ユーザー単位では重複したプロジェクト名を許可しないこと' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:project, name: 'Test Project', owner: user)

    new_project = FactoryBot.build(:project, name: 'Test Project', owner: user)
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it '二人のユーザーが同じプロジェクト名を使うのを許可すること' do
    user = FactoryBot.create(:user, first_name: '田中', last_name: '太郎')
    FactoryBot.create(:project, name: 'Test Project', owner: user)

    other_user = FactoryBot.create(:user, first_name: '日本', last_name: '花子')
    other_project = FactoryBot.build(:project, name: 'Test Project', owner: other_user)
    expect(other_project).to be_valid
  end

  describe '#late?' do
    it '締切日が過ぎていれば遅延していること' do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    it '締切日が今日ならスケジュール通りであること' do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    it '締切日が未来ならスケジュール通りであること' do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
