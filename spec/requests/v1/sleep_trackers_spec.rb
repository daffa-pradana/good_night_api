require 'rails_helper'

RSpec.describe "Sleep Trackers", type: :request do
  before do
    50.times do |i|
      user = i.zero? ? create(:user, name: "User A") : create(:user)
      clocked_in  = Time.current
      clocked_out = clocked_in + ((i + 1) * 30).minutes
      tracker = create(
        :sleep_tracker,
        user: user,
        clocked_in_at: clocked_in,
        clocked_out_at: clocked_out,
      )
      tracker.calculate_duration!
    end

    @user_a = User.find_by(name: "User A")
    users = User.all.where.not(id: @user_a.id)
    users.each { |user| @user_a.following << user }
  end

  describe "GET /v1/sleep_tracker/followed" do
    it "returns ok" do
      get "/v1/sleep_tracker/followed", **as_user(@user_a)
      expect(response).to have_http_status(:ok)
    end

    it "returns unauthorized without correct auth" do
      get "/v1/sleep_tracker/followed"
      expect(response).to have_http_status(:unauthorized)
    end

    it "doesn't do n+1 query" do
      expect_max_queries(3) do
        get "/v1/sleep_tracker/followed", **as_user(@user_a)
        expect(response).to have_http_status(:ok)
      end
    end

    it "returns correct limited result when paginated params provided" do
      headers = { params: { page: 1, per_page: 5 }, **as_user(@user_a) }
      get "/v1/sleep_tracker/followed", **headers
      expect(response_body.count).to eq(5)
    end

    it "returns default limit result when paginated params weren't provided" do
      get "/v1/sleep_tracker/followed", **as_user(@user_a)
      expect(response_body.count).to eq(20)
    end
  end
end
