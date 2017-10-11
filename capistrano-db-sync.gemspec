Gem::Specification.new do |s|
  s.name        = 'capistrano-db-sync'
  s.version     = '1.0.0'
  s.date        = Date.today.to_s
  s.summary     = "Capistrano synchronization databases task"
  s.description = "Capistrano synchronization task for syncing databases between the local development environment and different multi_stage environments"
  s.authors     = ["Albuisson Stéphane"]
  s.email       = 'stephane.albuisson@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'http://www.stephane-albuisson.com'
  s.license     = 'MIT'
end