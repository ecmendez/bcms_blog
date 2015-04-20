class BcmsBlog::BlogPostsController < Cms::ContentBlockController
  before_filter :show_no_access_if_none_editable

  def build_block
    binding.pry
    super
    ensure_blog_editable
    @block.author = current_user
  end

  def load_block
    binding.pry

    super
    ensure_blog_editable
  end

  def load_blocks
    binding.pry

    super
    @blocks.to_a.delete_if { |b| !b.editable_by?(current_user) }
  end

  private

    # If the current user is not able to edit any blog, just show them a page saying so
    def show_no_access_if_none_editable
      if BcmsBlog::Blog.editable_by(current_user).empty?
        render :action => "no_access"
      end
    end

    # Ensure the current user can actually edit the blog this blog post is associated with
    def ensure_blog_editable
      if @block.blog
        raise Cms::Errors::AccessDenied unless @block.blog.editable_by?(current_user)
      end
    end

  private

  def object_parameters

  end
end
