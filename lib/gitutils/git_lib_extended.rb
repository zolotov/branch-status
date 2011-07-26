module GitLibExtended

	def self.included(mod)
		override_full_log_commits_method(mod)
	end

	def self.override_full_log_commits_method(mod)
		mod.class_eval do
			def full_log_commits(opts={})
				arr_opts = ['--pretty=raw']
				arr_opts << "--merges" if opts[:merges_only]
				arr_opts << "-#{opts[:count]}" if opts[:count]
				arr_opts << "--skip=#{opts[:skip]}" if opts[:skip]
				arr_opts << "--since=#{opts[:since]}" if opts[:since].is_a? String
				arr_opts << "--until=#{opts[:until]}" if opts[:until].is_a? String
				arr_opts << "--grep=#{opts[:grep]}" if opts[:grep].is_a? String
				arr_opts << "--author=#{opts[:author]}" if opts[:author].is_a? String
				arr_opts << "#{opts[:between][0].to_s}..#{opts[:between][1].to_s}" if (opts[:between] && opts[:between].size == 2)
				arr_opts << opts[:object] if opts[:object].is_a? String
				arr_opts << '--' << opts[:path_limiter] if opts[:path_limiter].is_a? String

				full_log = command_lines('log', arr_opts, true)
				process_commit_data(full_log)
			end
		end
	end

	def branches_merged(&block)
		branches = []
		command('branch', ['-a', '--merged'], true, '', &block).split("\n").each do |branch|
			current = (branch[0, 2] == '* ')
			branches << [branch.gsub('* ', '').strip, current]
		end
		branches
	end

	def merge_noff(branch, message = nil)      
		arr_opts = [] 
		arr_opts << '-m' << message if message
		arr_opts << '--no-ff'
		arr_opts += [branch]
		command('merge', arr_opts)
	end

end
