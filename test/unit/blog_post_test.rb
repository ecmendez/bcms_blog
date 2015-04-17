require 'test_helper'

module BcmsBlog
  class BlogPostTest < ActiveSupport::TestCase

    def setup
      setup_blog_stubs
      @post = create(:blog_post, :name => "This is the first Post")
    end

    test "cretates a valid instance" do
      assert @post.valid?
    end

    test "requires name" do
      assert build(:blog_post, :name => nil).invalid?
    end

    test "requires blog_id" do
      assert build(:blog_post, :bcms_blog =>  nil).invalid?
    end

    test "requires author_id" do
      assert build(:blog_post, :author => nil).invalid?
    end

    test "should set slug" do
      assert_equal('this-is-the-first-post', @post.slug)
    end

    test "should set published_at when published" do
      assert_nil @post.published_at
      @post.publish!
      assert_not_nil @post.published_at
    end

    test "BlogPost should find posts published between 2 given dates" do
      @post.publish!
      create(:blog_post, :published_at => 5.days.ago)
      create(:blog_post, :published_at => 10.days.ago)
      assert_equal(1, BlogPost.published_between(6.days.ago, 4.days.ago).count)
    end

  end
end
