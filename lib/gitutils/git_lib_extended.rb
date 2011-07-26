module GitLibExtended

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
