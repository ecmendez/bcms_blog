class CreateBlogComments < ActiveRecord::Migration
  def self.up

    create_table :cms_blog_comment_versions do |t|
      t.integer  :blog_comment_id
      t.integer  :version
      t.string   :version_comment
      t.integer :post_id
      t.string :author
      t.string :email
      t.string :url
      t.string :ip
      t.text :body
    end
    add_index "cms_blog_comment_versions", ["blog_comment_id", "version"], :name => "index_cms_blog_comment_versions_on_id_and_version"

    create_table :cms_blog_comments do |t|
      t.integer  :version
      t.integer  :lock_version,   :default => 0
      t.integer :post_id
      t.string :author
      t.string :email
      t.string :url
      t.string :ip
      t.text :body
    end
  end

  def self.down
    drop_table :cms_blog_comment_versions
    drop_table :cms_blog_comments
  end
end
