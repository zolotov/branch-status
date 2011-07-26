module GitBranchExtended
	def merged?
		# filter non appropriate branches at IO level in order to performance improve
		merged_branches = @base.branches_merged do |fd| 
			branches = ""
			fd.each_line do |line|
				branches << line if line =~ /#{@name}/
			end
			branches
		end

		not merged_branches.empty?
	end

	def merge_commit
		@base.log.merges_only(true).object(@base.branch).between(gcommit.sha).grep(@name).first
	end

end
