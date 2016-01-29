require 'spec_helper'

describe RestMyCase::Base do

  describe ".dependencies" do

    it "should only list the class's dependencies" do
      expect(RestMyCaseBase::CreatePostWithComments.dependencies).to \
        eq [RestMyCaseBase::BuildComments, RestMyCaseBase::CreateComments]
    end

  end

end
