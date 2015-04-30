class BcmsBlog::BlogPostsController < Cms::ContentBlockController
  before_filter :show_no_access_if_none_editable

  def build_block
    super
    ensure_blog_editable
    @block.author = current_user
  end

  def load_block
    super
    ensure_blog_editable
  end

  def load_blocks
    super
    @blocks.to_a.delete_if { |b| !b.editable_by?(current_user) }
  end

  private

  def blog_post_params
    params.require(:blog_post).permit(
        :blog_id,
        :author_id,
        :category_id,
        :name,
        :slug,
        :summary,
        :body,
        :comments_count,
        :published_at,
        :attachment_id,
        :attachment_version,
        :version,
        :lock_version,
        :published,
        :deleted,
        :archived,
        :created_by_id,
        :updated_by_id,
        :created_at,
        :updated_at
    )
  end

    # If the current user is not able to edit any blog, just show them a page saying so
    def show_no_access_if_none_editable
      if BcmsBlog::Blog.editable_by(current_user).empty?
        render :action => 'no_access'
      end
    end

    # Ensure the current user can actually edit the blog this blog post is associated with
    def ensure_blog_editable
      if @block.blog
        raise Cms::Errors::AccessDenied unless @block.blog.editable_by?(current_user)
      end
    end

end
