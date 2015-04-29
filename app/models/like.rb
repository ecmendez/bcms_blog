class Like < Socialization::ActiveRecordStores::Like
  scope :liked_by, lambda { |liker| where(
                     :liker_type    => 'Cms::PersistentUser',
                     :liker_id      => liker.id)
                 }

  scope :liking,   lambda { |likeable| where(
                   :likeable_type => likeable.class.to_s,
                   :likeable_id   => likeable.id)
               }

  class << self
    def like!(liker, likeable)
      unless likes?(liker, likeable)
        self.create! do |like|
          like.liker = liker
          like.likeable = likeable
        end
        call_after_create_hooks(liker, likeable)
        true
      else
        false
      end
    end

    def likes?(liker, likeable)
      !like_for(liker, likeable).empty?
    end

    # Returns an ActiveRecord::Relation of all the likers of a certain type that are liking  likeable
    def likers_relation(likeable, klass, opts = {})
      rel = klass.where(:id =>
                            self.select(:liker_id).
                                where(:liker_type => 'Cms::PersistentUser').
                                where(:likeable_type => likeable.class.to_s).
                                where(:likeable_id => likeable.id)
      )

      if opts[:pluck]
        rel.pluck(opts[:pluck])
      else
        rel
      end
    end

    # Returns all the likers of a certain type that are liking  likeable
    def likers(likeable, klass, opts = {})
      rel = likers_relation(likeable, klass, opts)
      if rel.is_a?(ActiveRecord::Relation)
        rel.to_a
      else
        rel
      end
    end

    # Returns an ActiveRecord::Relation of all the likeables of a certain type that are liked by liker
    def likeables_relation(liker, klass, opts = {})
      rel = klass.where(:id =>
                            self.select(:likeable_id).
                                where(:likeable_type => likeable.class.name.classify).
                                where(:liker_type => 'Cms::PersistentUser').
                                where(:liker_id => liker.id)
      )

      if opts[:pluck]
        rel.pluck(opts[:pluck])
      else
        rel
      end
    end

    # Returns all the likeables of a certain type that are liked by liker
    def likeables(liker, klass, opts = {})
      rel = likeables_relation(liker, klass, opts)
      if rel.is_a?(ActiveRecord::Relation)
        rel.to_a
      else
        rel
      end
    end

    # Remove all the likers for likeable
    def remove_likers(likeable)
      self.where(:likeable_type => likeable.class.name.classify).
          where(:likeable_id => likeable.id).destroy_all
    end

    # Remove all the likeables for liker
    def remove_likeables(liker)
      self.where(:liker_type => 'Cms::PersistentUser').
          where(:liker_id => liker.id).destroy_all
    end

    private
    def like_for(liker, likeable)
      liked_by(liker).liking( likeable)
    end
  end # class << self

end

