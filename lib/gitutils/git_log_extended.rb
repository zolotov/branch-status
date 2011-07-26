module GitLogExtended
	def merges_only(value)
		dirty_log
		@merges_only = value
		self
	end

	def run_log      
		log = @base.lib.full_log_commits(:count => @count, :object => @object, 
										 :path_limiter => @path, :since => @since, 
										 :author => @author, :grep => @grep, :skip => @skip,
										 :merges_only => @merges_only,
										 :until => @until, :between => @between)
		@commits = log.map { |c| Git::Object::Commit.new(@base, c['sha'], c) }
	end
end
