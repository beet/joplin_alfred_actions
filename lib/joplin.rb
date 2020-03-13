Dir["#{__dir__}/joplin/**/*.rb"].each do |file|
  require_relative file
end
