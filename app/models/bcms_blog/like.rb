class BcmsBlog::Like < ActiveRecord::Base
  self.table_name= 'cms_likes'

  belongs_to :likeable, :polymorphic => true

  class << self
    def likers_relation!(liker, likeable)
      self.create! do |like|
        like.liker_id = liker.id
        like.liker_type = liker.class.to_s
        like.likeable_id = likeable.id
        like.likeable_type = likeable.class.to_s
      end
    end

    def likes?(liker, likeable)
      !like_for(liker, likeable).empty?
    end

    private

    def like_for(liker, likeable)
      where(:liker_id => liker.id,
            :liker_type => liker.class.to_s,
            :likeable_id => likeable.id,
            :likeable_type => likeable.class.to_s
      )
    end
  end
end
