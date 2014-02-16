require 'rake/testtask'

# use `rake test` to run all the tests
desc "Run all the current tests"
Rake::TestTask.new do |t|
  # glob doesn't work in a directory like you think it should
  t.pattern = "test/test_*.rb"
end

desc "Test metadata extraction"
task :test_metadata do
	ruby "test/test_metadata.rb"
end

desc "Test commandline options"
task :test_options do
	ruby "test/test_options.rb"
end

desc "Test image resize"
task :test_resize do
	ruby "test/test_resize.rb"
end

desc "Test full process"
task :test_full do
	ruby "test/test_full.rb"
end
