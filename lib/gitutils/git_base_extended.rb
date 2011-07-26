module GitBaseExtended
	def branches_merged(&block)
		branches = {}
		lib.branches_merged(&block).each do |branch|
			branches[branch[0]] = Git::Branch.new(self, branch[0])
		end
		branches
	end

	def merge_noff(branch, message = 'merge')
      self.lib.merge_noff(branch, message)
    end

end
