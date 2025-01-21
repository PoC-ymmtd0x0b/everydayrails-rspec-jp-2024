require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }
  let(:task) { project.tasks.create!(name: 'Test task') }

  describe '#show' do
    it 'JSON形式でレスポンスを返すこと' do
      sign_in user
      get :show, format: :json, params: { project_id: project.id, id: task.id }
      expect(response.content_type).to include 'application/json'
    end
  end

  describe '#create' do
    it 'JSON形式でレスポンスを返すこと' do
      new_task = { name: 'New test task' }
      sign_in user
      post :create, format: :json, params: { project_id: project.id, task: new_task }
      expect(response.content_type).to include 'application/json'
    end

    it '新しいタスクをプロジェクトに追加すること' do
      new_task = { name: 'New test task' }
      sign_in user
      expect do
        post :create, format: :json, params: { project_id: project.id, task: new_task }
      end.to change(project.tasks, :count).by(1)
    end

    it '認証を要求すること' do
      new_task = { name: 'New test task' }
      # ここでは敢えてログインしない
      expect do
        post :create, format: :json, params: { project_id: project.id, task: new_task }
      end.to_not change(project.tasks, :count)
      expect(response).to_not be_successful
    end
  end
end
