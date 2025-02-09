require 'rails_helper'

RSpec.describe "Home", type: :request do
  it '正常なレスポンスを返すこと' do
    get root_path
    expect(response).to be_successful
    expect(response).to have_http_status(:success)
  end
end
