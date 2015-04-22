module BcmsBlog
  class BlogGroupMembership < ActiveRecord::Base
    self.table_name= 'cms_blog_group_memberships'
    belongs_to :blog, :class_name => "Blog"
    belongs_to :group, :class_name => "Cms::Group"
  end
end
