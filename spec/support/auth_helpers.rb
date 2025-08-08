module AuthHelpers
  def as_user(user)
    auth_headers_for(user)
  end

  def auth_headers_for(user)
    token = JsonWebToken.encode({ user_id: user.id })
    { headers: { "Authorization" => "Bearer #{token}" } }
  end
end
