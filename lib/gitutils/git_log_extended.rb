module GitLogExtended

	def self.included(mod)
		override_run_log_method(mod)
	end

	def self.override_run_log_method(mod)
		mod.class_eval do
			def run_log      
				log = @base.lib.full_log_commits(:count => @count, :object => @object, 
												 :path_limiter => @path, :since => @since, 
												 :author => @author, :grep => @grep, :skip => @skip,
												 :merges_only => @merges_only,
												 :until => @until, :between => @between)
				@commits = log.map { |c| Git::Object::Commit.new(@base, c['sha'], c) }
			end
		end
	end

	def merges_only(value)
		dirty_log
		@merges_only = value
		self
	end

end
