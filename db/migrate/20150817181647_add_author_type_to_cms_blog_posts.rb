class AddAuthorTypeToCmsBlogPosts < ActiveRecord::Migration
  def change
    add_column :cms_blog_posts, :author_type, :string
    add_column :cms_blog_post_versions, :author_type, :string
  end
end
