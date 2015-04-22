module BcmsBlog
  class BlogComment < ActiveRecord::Base
    self.table_name= 'cms_blog_comments'

    acts_as_content_block :is_searachable => "body"
    belongs_to :post, :class_name => "BlogPost", :counter_cache => "comments_count"

    validates_presence_of :post_id, :author, :body
  
    before_create :publish_if_comments_are_enabled
  
    def publish_if_comments_are_enabled
      self.publish_on_save = !post.blog.moderate_comments?
      return true
    end

    def self.default_order
      "created_at desc"
    end

    def self.default_order_for_search
      default_order
    end

    def self.columns_for_index
      [ {:label => "Comment",    :method => :name,                 :order => "body" },
        {:label => "Created At", :method => :formatted_created_at, :order => "created_at"} ]
    end

    def name
      body ? body[0..50] : ""
    end

    def formatted_created_at
      created_at.to_s(:date)
    end

    def self.permitted_params
      [:post_id, :author, :email, :url, :ip, :body, :version, :lock_version, :name, :published, :deleted, :archived]
    end

  end
end
