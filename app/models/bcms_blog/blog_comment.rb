module BcmsBlog
  class BlogComment < ActiveRecord::Base
    self.table_name= 'cms_blog_comments'

    acts_as_content_block :is_searchable => {:searchable_columns => ['body']}, :userstamped => false
    belongs_to :created_by, :polymorphic => true
    belongs_to :updated_by, :polymorphic => true
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
        {:label => "Post (order by id)",    :method => :post_name, :order => "post_id" },
        {:label => "Blog",    :method => :blog_name},
        {:label => "Created At", :method => :formatted_created_at, :order => "created_at"} ]
    end

    def name
      body ? body[0..50] : ""
    end


    def self.permitted_params
      attribute_names.map{|string| string.to_sym}
    end

    private


    def post_name
      self.post.name
    end

    def blog_name
      self.post.blog.name
    end

    def formatted_created_at
      created_at.to_s(:date)
    end


  end
end
