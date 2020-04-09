require 'db_schema'

DbSchema.describe do |db|
  db.extension 'uuid-ossp'

  db.enum :role, %w[admin support user]

  db.table :roles do |t|
    t.serial :id,          primary_key: true
    t.role   :name,        null: false, unique: true
    t.jsonb  :permissions, null: false, default: '[]'
  end

  db.table :users do |t|
    t.serial  :id,              primary_key: true
    t.varchar :email,           null: false, unique: true
    t.varchar :password_digest, null: false
    t.role    :role,            null: false, references: %i[roles name]
    t.varchar :name,            null: false
    t.bigint  :phone,           check: 'phone < 100000000000'

    t.boolean :active, null: false, default: true

    t.timestamptz :created_at, null: false
    t.timestamptz :updated_at, null: false
  end

  db.table :attachments do |t|
    t.uuid    :id,          primary_key: true
    t.varchar :filename,    null: false
    t.varchar :extension,   null: false
    t.boolean :visible,     null: false, default: true
    t.integer :uploaded_by, null: false, references: :users

    t.timestamptz :created_at, null: false
    t.timestamptz :updated_at, null: false
  end
end

Sequel.connect(ENV['DATABASE_URL']) do |db|
  db.extension :pg_array
  db.extension :pg_json

  if Hanami.env?(:development, :staging)
    def load_seed_data(filename)
      path = Pathname.new("../seeds/#{filename}.yml").expand_path(__FILE__)
      YAML.load_file(path)
    end

    load_seed_data(:roles).each do |role_name, desired_permissions|
      role = db[:roles].where(name: role_name).first

      if role
        actual_permissions = role[:permissions]

        added_permissions = desired_permissions - actual_permissions
        removed_permissions = actual_permissions - desired_permissions

        next unless added_permissions.any? || removed_permissions.any?

        puts "Updating #{role_name.ai} role permissions"
        puts "Adding: #{added_permissions.ai}" if added_permissions.any?
        puts "Removing: #{removed_permissions.ai}" if removed_permissions.any?

        db[:roles].where(name: role_name).update(
          permissions: Sequel.pg_json(desired_permissions)
        )
      else
        db[:roles].insert(
          name:        role_name,
          permissions: Sequel.pg_json(desired_permissions)
        )
      end
    end

    email = 'admin@example.com'

    if db[:users].where(email: email).none?
      db[:users].insert(
        email:           email,
        password_digest: BCrypt::Password.create('secret'),
        role:            'admin',
        name:            'John Smith',
        phone:           18_005_555_000,
        created_at:      Time.now,
        updated_at:      Time.now
      )
    end
  end
end
