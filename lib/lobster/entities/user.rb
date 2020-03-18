class User < Hanami::Entity
  def password_correct?(password)
    BCrypt::Password.new(password_digest) == password
  end

  def generate_token
    data = {
      user_id: id,
      exp:     Time.now.to_i + self.class.jwt_ttl
    }

    JWT.encode(data, ENV['HMAC_SECRET'], 'HS256')
  end

  def active?
    active
  end

  class << self
    def jwt_ttl
      ENV['JWT_TTL'].to_i
    end
  end
end
