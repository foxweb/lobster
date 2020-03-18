class RoleRepository < Hanami::Repository
  def find_by_name(name)
    roles.where(name: name).one
  end
end
