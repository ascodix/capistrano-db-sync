lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name        = 'capistrano-db-sync'
  spec.version     = '1.0.0'
  spec.date        = Date.today.to_s
  spec.summary     = "Capistrano synchronization databases task"
  spec.description = "Capistrano synchronization task for syncing databases between the local development environment and different multi_stage environments"
  spec.authors     = ["Albuisson Stéphane"]
  spec.email       = 'stephane.albuisson@gmail.com'
  spec.files       = `git ls-files`.split("\n")
  spec.homepage    = 'http://www.stephane-albuisson.com'
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]

  spec.add_dependency 'capistrano', '~> 3.1'
end