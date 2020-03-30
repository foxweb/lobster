Factory.define(:user) do |f|
  f.name             { fake(:name) }
  f.email            { fake(:internet, :email) }
  f.password_digest  BCrypt::Password.create('secret')
  f.role             'user'

  f.timestamps
end

Factory.define(admin: :user) do |f|
  f.role 'admin'
end

Factory.define(support: :user) do |f|
  f.role 'support'
end
