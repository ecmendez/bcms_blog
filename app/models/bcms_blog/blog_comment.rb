module BcmsBlog
  class BlogComment < ActiveRecord::Base
    self.table_name= 'cms_blog_comments'
    is_versioned

    acts_as_content_block :is_searachable => "body"
    belongs_to :post, :class_name => "BcmsBlog::BlogPost", :counter_cache => "comments_count"

    validates_presence_of :post_id, :author, :body
  
    before_create :publish_if_comments_are_enabled
  
    def publish_if_comments_are_enabled
      self.published = !post.blog.moderate_comments?
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

    def permitted_params
      attribute_names.map{|string| string.to_sym}
    end

  end
end
