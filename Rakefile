require 'rake'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'rake/clean'

NAME = "redis-load"
VER = "0.2"

RDOC_OPTS = ['--quiet', '--title', 'redis-load Reference', '--main', 'README.md']

PKG_FILES = %w( README.md Rakefile CHANGES ) + 
  Dir.glob("{bin,doc,tests,examples,lib}/**/*")

CLEAN.include ['*.gem', 'pkg']  
SPEC =
  Gem::Specification.new do |s|
    s.name = NAME
    s.version = VER
    s.platform = Gem::Platform::RUBY
    s.required_ruby_version = ">= 1.8.5"    
    s.has_rdoc = true
    s.extra_rdoc_files = ["README.md", "CHANGES"]
    s.rdoc_options = RDOC_OPTS
    s.summary = "Utility of loading/saving data structures from Redis"
    s.description = s.summary
    s.author = "Leigh Dodds"
    s.email = 'leigh.dodds@talis.com'
    s.homepage = 'http://github.org/ldodds/redis-load'
    #s.rubyforge_project = ''
    s.files = PKG_FILES
    s.require_path = "lib" 
    s.bindir = "bin"
    s.executables = ["redis-load"]
    s.test_file = "tests/ts_redis-load.rb"
    s.add_dependency("redis")
    s.add_dependency("json_pure")
    s.add_dependency("siren")        
  end
      
Rake::GemPackageTask.new(SPEC) do |pkg|
    pkg.need_tar = true
end

Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = 'doc/rdoc'
    rdoc.options += RDOC_OPTS
    rdoc.rdoc_files.include("README.md", "CHANGES", "lib/**/*.rb")
    rdoc.main = "README.md"
    
end

Rake::TestTask.new do |test|
  test.test_files = FileList['tests/tc_*.rb']
end

desc "Install from a locally built copy of the gem"
task :install do
  sh %{rake package}
  sh %{sudo gem install pkg/#{NAME}-#{VER}}
end

desc "Uninstall the gem"
task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end
