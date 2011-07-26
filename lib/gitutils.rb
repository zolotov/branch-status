$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'git'
require 'gitutils/repo'
require 'gitutils/git_lib_extended'
require 'gitutils/git_branch_extended'
require 'gitutils/git_base_extended'
require 'gitutils/git_log_extended'

class Git::Lib
	include GitLibExtended
end

class Git::Base
	include GitBaseExtended
end

class Git::Branch
	include GitBranchExtended
end

class Git::Log
	include GitLogExtended
end

