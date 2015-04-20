class BcmsBlog::FeedsController < ApplicationController
  def index
    @blog = Blog.find(params[:blog_id])
    @blog_posts = @blog.posts.published.all.order('published_at DESC').limit(10)
  end
end
