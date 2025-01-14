require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'ユーザー単位では重複すたプロジェクト名を許可しないこと' do
    user = User.create(first_name: 'tanaka',
                       last_name:  'taro',
                       email:      'taro@example.com',
                       password:   'foobar')
    user.projects.create(name: 'Test Project')
    new_project = user.projects.new(name: 'Test Project')
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it '二人のユーザーが同じプロジェクト名を使うのを許可すること' do
    user = User.create(first_name: 'tanaka',
                       last_name:  'taro',
                       email:      'taro@example.com',
                       password:   'foobar')
    user.projects.create(name: 'Test Project')

    other_user = User.create(first_name: 'yamada',
                             last_name:  'jiro',
                             email:      'jiro@example.com',
                             password:   'foobar')
    other_project = other_user.projects.new(name: 'Test Project')
    expect(other_project).to be_valid
  end
end
