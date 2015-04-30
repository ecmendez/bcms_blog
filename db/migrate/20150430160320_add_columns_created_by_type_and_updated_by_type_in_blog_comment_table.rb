class AddColumnsCreatedByTypeAndUpdatedByTypeInBlogCommentTable < ActiveRecord::Migration
  def change
    add_column :cms_blog_comments, :created_by_type, :string
    add_column :cms_blog_comments, :updated_by_type, :string
  end
end
