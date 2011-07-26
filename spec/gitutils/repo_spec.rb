require File.join(File.dirname(__FILE__), "/../spec_helper.rb")

module GitUtils
	describe Repo do
		before(:each) do
			@repo_path = "/tmp/testRepo"
			@repo_remote = "git://remote/"
			FileUtils.rm_rf @repo_path
		end

		context "creating repo" do
			it "should be init repo if it does not exist" do
				repo = Repo.new @repo_path, @repo_remote
				File.exists?(File.join(@repo_path, "/.git")).should be_true
			end

			it "should add origin remote to new repo if it does not exist" do
				repo = Repo.new @repo_path, @repo_remote
				repo.remotes.first.url.should == @repo_remote
				repo.remotes.first.name.should == "origin"
			end

			it "should not edit origin remote if it exists" do
				existing_remote_url = "git://existing_remote"
				existing_repo = Git.init @repo_path
				existing_repo.add_remote 'origin', existing_remote_url

				repo = Repo.new @repo_path, @repo_remote
				repo.remotes.first.url.should == existing_remote_url
			end
		end

		context "working with branches" do
			before(:each) do
				@repo = Repo.new @repo_path, @repo_remote
				FileUtils.touch File.join(@repo_path, '/readme')
				@repo.add 'readme'
				@repo.commit 'init'
				@repo.branch('merged').in_branch('merged message') do
					FileUtils.touch File.join(@repo_path, '/merged-file')
					@repo.add 'merged-file'
				end
				@repo.branch('no-merged').in_branch('no-merged message') do
					FileUtils.touch File.join(@repo_path, '/no-merged-file')
					@repo.add 'no-merged-file'
				end

				@repo.merge_noff('merged', nil)
			end

			it "should return merged branches only" do
				@repo.branches_merged['no-merged'].should be_nil
				@repo.branches_merged['merged'].should_not be_nil
				@repo.branches_merged['merged'].name.should == 'merged'
			end

			it "should return branch merged status" do
				@repo.branch('merged').should be_merged
				@repo.branch('no-merged').should_not be_merged
			end

			it "should return merge commit" do
				@repo.branch('merged').merge_commit.message.should =~ /Merge branch 'merged'/
				@repo.branch('no-merged').merge_commit.should be_nil
			end
		end
	end

end
