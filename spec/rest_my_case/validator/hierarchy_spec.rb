require 'spec_helper'

describe 'Testing hierarchy capabilities' do

  it "HierarchyValidation::Son should be able to inherit Father's validations and alter them" do
    # post_for_father = RubyPost.new
    # father_context  = HierarchyValidation::Father.perform(post: post_for_father)

    # expect(father_context.ok?).to be false
    # expect(post_for_father.errors.added?(:title, :blank)).to be true
    # expect(post_for_father.errors.size).to be 1

    post_for_son  = RubyPost.new
    son_context   = HierarchyValidation::Son.perform(post: post_for_son)

    expect(son_context.ok?).to be false
    expect(post_for_son.errors.added?(:title, :blank)).to be true
    expect(post_for_son.errors.added?(:email, :blank)).to be true
    expect(post_for_son.errors.size).to be 2
  end

end

