module GitUtils

	class Repo
		def initialize(repo_path, remote_url = '')
			@repo_path = repo_path
			
			unless File.exists?(@repo_path) 
				Dir.mkdir @repo_path 
				@repo = Git.init(@repo_path)
			else
				@repo = Git.open @repo_path
			end
			
			unless remote_url.empty?
				origin = remotes.select { |remote| remote.name == 'origin' }
				add_remote 'origin', remote_url if origin.empty?
			end
		end

		def method_missing(sym, *args, &block)
			@repo.send sym, *args, &block
		end
	end

end
