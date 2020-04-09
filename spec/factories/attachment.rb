Factory.define(:attachment) do |f|
  f.id          { SecureRandom.uuid }
  f.filename    'shufutinsky'
  f.extension   'jpg'

  f.timestamps
end
