require 'rails_helper'

RSpec.describe "Projects", type: :system do
  scenario 'ユーザーは新しいプロジェクトを作成する' do
    user = FactoryBot.create(:user)
    sign_in user

    visit root_path
    expect do
      click_link 'New Project'
      fill_in 'Name', with: 'Test Project'
      fill_in 'Description', with: 'Trying out Capybara'
      click_button 'Create Project'
    end.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content 'Project was successfully created'
      expect(page).to have_content 'Test Project'
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  scenario 'ユーザーはプロジェクトを完了済みにする' do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: 'Complete Project', owner: user)
    sign_in_as(user)

    visit project_path(project)

    expect(page).to_not have_content 'Completed'

    click_button 'Complete'

    expect(project.reload.completed?).to be true
    expect(page).to have_content 'Congratulations, this project is complete!'
    expect(page).to have_content 'Completed'
    expect(page).to_not have_button 'Complete'
  end
end
