
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

ensure_in_path 'lib'
require 'conditions_fu'

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name  'conditions_fu'
  authors  'Cameron Barrie'
  email  'camwritescode@gmail.com'
  url  'http://wiki.github.com/whalec/conditions_fu'
  version  ConditionsFu::VERSION
}

# EOF
