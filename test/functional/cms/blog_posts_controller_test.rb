require 'test_helper'

module BcmsBlog
  class BlogPostsControllerTest < ActionController::TestCase

    def setup
      setup_blog_stubs
      Cms::ContentType.create!(:name => 'BcmsBlog::BlogPost', :group_name => 'Blog')
      login_as(create_user)
    end

    def test_access_denied_on_create_if_blog_not_user_editable
      @editable = create(:bcms_blog, :groups => [@group])
      @non_editable = create(:bcms_blog)
      post :create, :blog_post => { :blog_id => @non_editable.id }
      assert @response.body.include?("Access Denied")
    end

    def test_access_denied_on_update_if_blog_not_user_editable
      @editable = create(:bcms_blog, :groups => [@group])
      @non_editable = create(:bcms_blog)
      @blog_post = create(:blog_post, :bcms_blog => @non_editable)
      put :update, :id => @blog_post, :blog_post => { :name => "Foo" }
      assert @response.body.include?("Access Denied")
     end

     def test_no_access_if_no_editable_blogs
       @blog = create(:bcms_blog)
       get :index
       assert_template "no_access"
     end

     def test_index_shouldnt_show_non_editable_posts
       @editable = create(:bcms_blog, :groups => [@group])
       @non_editable = create(:bcms_blog)
       @blog_post = create(:blog_post, :name => "Non-editable", :bcms_blog => @non_editable)
       get :index
       assert !@response.body.include?("Non-editable")
     end

     def test_create_sets_author
       @blog = create(:bcms_blog, :groups => [@group])
       post :create, :blog_post => { :blog_id => @blog.id }
       assert_equal @user, assigns(:block).author
     end
  end
end
