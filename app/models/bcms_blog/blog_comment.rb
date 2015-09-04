module BcmsBlog
  class BlogComment < ActiveRecord::Base
    self.table_name= 'cms_blog_comments'

    acts_as_content_block :is_searchable => {:searchable_columns => ['body']}, :userstamped => false
    belongs_to :created_by, :polymorphic => true
    belongs_to :updated_by, :polymorphic => true
    belongs_to :post, :class_name => "BlogPost", :counter_cache => "comments_count"
    has_many :likes, :class_name => "Like", :foreign_key => "likeable_id"

    validates_presence_of :post_id, :body
  
    before_create :publish_if_comments_are_enabled

    scope :ordered_by_likes, ->{
      joins('left join cms_likes on cms_likes.likeable_id = cms_blog_comments.id').group('cms_blog_comments.id').order('count(cms_likes.id) desc')
    }

    def publish_if_comments_are_enabled
      self.publish_on_save = !post.blog.moderate_comments?
      return true
    end

    def self.default_order
      "#{table_name}.created_at desc"
    end

    def self.default_order_for_search
      default_order
    end

    def self.columns_for_index
      [ {:label => "Comment",    :method => :name,                 :order => "#{table_name}.body" },
        {:label => "Post (order by id)",    :method => :post_name, :order => "#{table_name}.post_id" },
        {:label => "Blog",    :method => :blog_name},
        {:label => "Created At", :method => :formatted_created_at, :order => "#{table_name}.created_at"} ]
    end

    def name
      body ? body[0..50] : ""
    end

    def website
      if !url.starts_with?('http')
      "http://#{url}"
      else
        url
      end
    end

    def self.permitted_params
      attribute_names.map{|string| string.to_sym}
    end

    def is_liked_by!(user)
      exist_relation = Like.likes?(user, self)
      unless exist_relation
        relation = Like.likers_relation!(user,self)
      end
      return true
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
