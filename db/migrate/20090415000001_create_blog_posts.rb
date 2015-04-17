class CreateBlogPosts < ActiveRecord::Migration
  def self.up
    create_table :cms_blog_post_versions do |t|
      t.integer  :blog_post_id
      t.integer  :version
      t.string   :version_comment
      t.integer :blog_id
      t.integer :author_id
      t.integer :category_id
      t.string :name
      t.string :slug
      t.text :summary
      t.text :body, :size => (64.kilobytes + 1)
      t.integer :comments_count
      t.datetime :published_at
    end

    add_index "cms_blog_post_versions", ["blog_post_id", "version"], :name => "index_cms_blog_post_versions_on_id_and_version"

    create_table :cms_blog_posts do |t|
      t.integer  :version
      t.integer  :lock_version,   :default => 0
      t.integer :blog_id
      t.integer :author_id
      t.integer :category_id
      t.string :name
      t.string :slug
      t.text :summary
      t.text :body, :size => (64.kilobytes + 1)
      t.integer :comments_count
      t.datetime :published_at
    end

  end

  def self.down
    drop_table :cms_blog_post_versions
    drop_table :cms_blog_posts
  end
end
