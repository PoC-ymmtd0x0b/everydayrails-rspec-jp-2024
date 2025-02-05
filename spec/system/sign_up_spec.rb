require 'rails_helper'

RSpec.describe "Sign up", type: :system do
  include ActiveJob::TestHelper

  scenario 'ユーザーはサインアップに成功する' do
    visit root_path
    click_link 'Sign up'

    perform_enqueued_jobs do
      expect do
        fill_in 'First name', with: 'First'
        fill_in 'Last name', with: 'Last'
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'test123'
        fill_in 'Password confirmation', with: 'test123'
        click_button 'Sign up'
      end.to change(User, :count).by(1)

      expect(page).to have_content 'Welcome! You have signed up successfully.'
      expect(current_path).to eq root_path
      expect(page).to have_content 'First Last'
    end

    mail = ActionMailer::Base.deliveries.last

    aggregate_failures do
      expect(mail.to).to eq ['test@example.com']
      expect(mail.subject).to eq 'Welcome to Projects!'
    end
  end
end
