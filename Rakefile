require 'rake'
require 'rake/testtask'

task :default => [:test_all]
	
# # use `rake` to run all the tests
# desc "Run all the current tests"
# Rake::TestTask.new("test_units") do |t|
#   # glob doesn't work in a directory like you think it should
#   t.pattern = "test/test_*.rb"
#   t.verbose = true
#   t.warning = true
# end

desc "Run all the current tests"
task :test_all do
	ruby "test/test_metadata.rb"
	ruby "test/test_options.rb"
	ruby "test/test_resize.rb"
	ruby "test/test_stage.rb"
	ruby "test/test_resize_long.rb"
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

desc "Test image resize long"
task :test_resize_long do
	ruby "test/test_resize_long.rb"
end

desc "Test image stage"
task :test_stage do
	ruby "test/test_stage.rb"
end
