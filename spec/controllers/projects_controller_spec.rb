require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe '#index' do
    context '認証済みのユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
      end

      it '正常にレスポンスを返すこと' do
        sign_in @user
        get :index

        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
      end
    end

    context 'ゲストの場合' do
      it 'サインイン画面にリダイレクトすること' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end

      it '302レスポンスを返すこと' do
        get :index
        expect(response).to have_http_status '302'
      end
    end
  end

  describe '#show' do
    context '認可されたユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it '正常にレスポンスを返すこと' do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to be_successful
      end
    end

    context '認可されていないユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it 'ダッシュボードにリダイレクトすること' do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#create' do
    context '認証済みのユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
      end

      context '有効な属性値の場合' do
        it 'プロジェクトを追加できること' do
          project_params = FactoryBot.attributes_for(:project)
          sign_in @user
          expect do
            post :create, params: { project: project_params }
          end.to change(@user.projects, :count).by(1)
        end
      end

      context '無効な属性値の場合' do
        it 'プロジェクトを追加できないこと' do
          project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in @user
          expect do
            post :create, params: { project: project_params }
          end.to_not change(@user.projects, :count)
        end
      end
    end

    context 'ゲストの場合' do
      it '302レスポンスを返すこと' do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { proejct: project_params }
        expect(response).to have_http_status '302'
      end

      it 'サインイン画面にリダイレクトすること' do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#update' do
    context '認可されたユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it 'プロジェクトを更新できること' do
        project_params = FactoryBot.attributes_for(:project, name: 'New Project Name')
        sign_in @user
        patch :update, params: { id: @project, project: project_params }
        expect(@project.reload.name).to eq 'New Project Name'
      end
    end

    context '認可されていないユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.build(:user)
        @project = FactoryBot.create(:project, owner: other_user, name: 'Same Old Name')
      end

      it 'プロジェクトを更新できないこと' do
        project_params = FactoryBot.attributes_for(:project, name: 'New Name')
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq 'Same Old Name'
      end

      it 'ダッシュボードへリダイレクトすること'do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to root_path
      end
    end

    context 'ゲストの場合' do
      before do
        @project = FactoryBot.create(:project)
      end

      it '302レスポンスを返すこと' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status '302'
      end

      it 'ログイン画面へリダイレクトされること' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#destroy'do
    context '認可されたユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it 'プロジェクトを削除できること' do
        sign_in @user
        expect do
          delete :destroy, params: { id: @project.id }
        end.to change(@user.projects, :count).by(-1)
      end
    end

    context '認可されていないユーザーの場合' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it 'プロジェクトを削除できないこと' do
        sign_in @user
        expect do
          delete :destroy, params: { id: @project.id }
        end.to_not change(Project, :count)
      end

      it 'ダッシュボードにリダイレクトすること' do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end

    context 'ゲストの場合' do
      before do
        @project = FactoryBot.create(:project)
      end

      it '302レスポンスを返すこと' do
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status '302'
      end

      it 'サインイン画面にリダイレクトすること' do
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to new_user_session_path
      end

      it 'プロジェクトを削除できないこと' do
        expect do
          delete :destroy, params: { id: @project.id }
        end.to_not change(Project, :count)
      end
    end
  end
end
