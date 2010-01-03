
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
  authors  'FIXME (who is writing this software)'
  email  'FIXME (your e-mail)'
  url  'FIXME (project homepage)'
  version  ConditionsFu::VERSION
}

# EOF
