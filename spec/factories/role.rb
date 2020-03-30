Factory.define(:role) do |f|
  f.name { 'admin' }

  f.permissions do
    Sequel.pg_json(ROLE_PERMISSIONS['admin'])
  end
end

Factory.define(support_role: :role) do |f|
  f.name { 'support' }

  f.permissions do
    Sequel.pg_json(ROLE_PERMISSIONS['support'])
  end
end
