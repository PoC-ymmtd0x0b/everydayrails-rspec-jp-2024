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
        expect(response).to be_successful
      end

      it '200レスポンスを返すこと' do
        sign_in @user
        get :index
        expect(response).to have_http_status '200'
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
end
