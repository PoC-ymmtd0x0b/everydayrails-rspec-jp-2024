require 'rails_helper'

RSpec.describe User, type: :model do
  it '姓、名、メール、パスワードがあれば有効な状態であること' do
    user = User.new(first_name: 'tanaka',
                    last_name:  'taro',
                    email:      'taro@example.com',
                    password:   'foobar')

    expect(user).to be_valid
  end

  it '名が無ければ無効な状態であること' do
    user = User.new(first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it '姓が無ければ無効な状態であること' do
    user = User.new(last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it 'メールアドレスが無ければ無効な状態であること' do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it '重複したメールアドレスなら無効な状態であること' do
    User.create!(first_name: 'tanaka',
                last_name:  'taro',
                email:      'duplicate@example.com',
                password:   'foobar')

    user = User.new(first_name: 'yamada',
                    last_name:  'jiro',
                    email:      'duplicate@example.com',
                    password:   'foobar')
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end

  it 'ユーザーのフルネームを文字列で返すこと' do
    user = User.new(first_name: 'tanaka', last_name: 'taro')
    expect(user.name).to eq 'tanaka taro'
  end
end
