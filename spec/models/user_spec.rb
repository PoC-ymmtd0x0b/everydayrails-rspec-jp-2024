require 'rails_helper'

RSpec.describe User, type: :model do
  it '有効なファクトリを持つこと' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it '姓、名、メール、パスワードがあれば有効な状態であること' do
    user = User.new(first_name: 'tanaka',
                    last_name:  'taro',
                    email:      'taro@example.com',
                    password:   'foobar')

    expect(user).to be_valid
  end

  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it 'ユーザーのフルネームを文字列で返すこと' do
    user = FactoryBot.build(:user, first_name: 'tanaka', last_name: 'taro')
    expect(user.name).to eq 'tanaka taro'
  end

  it 'アカウントが作成された際にウェルカムメールを送信すること' do
    allow(UserMailer).to receive_message_chain(:welcome_email, :deliver_later)
    user = FactoryBot.create(:user)
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end
end
