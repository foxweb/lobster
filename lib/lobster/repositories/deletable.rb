module Deletable
  def find_visible(id)
    root.where(id: id, visible: true).map_to(self.class.entity).one
  end

  def only_visible
    root.where(visible: true).map_to(self.class.entity)
  end
end
