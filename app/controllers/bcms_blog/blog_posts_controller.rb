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

  # this is the same method called from BrowserCMS on controllers/cms/content_block_controller.rb
  # it was needed to move it here to add the extra layout of verification and avoid to show the
  # posts that are not allowed to see based on permissions
  def load_blocks
    @search_filter = Cms::SearchFilter.build(params[:search_filter], model_class)

    scope = model_class.respond_to?(:list) ? model_class.list : model_class
    if scope.searchable?
      scope = scope.search(@search_filter.term)
    end
    if params[:section_id] && model_class.respond_to?(:with_parent_id)
      scope = scope.with_parent_id(params[:section_id])
    end

    if params[:order].present?
      scope = scope.reorder(params[:order])
    elsif model_class.respond_to?(:default_order)
      scope = scope.reorder(model_class.default_order)
    end

    authorized = scope.to_a.select{|b| b.editable_by?(current_user)}

    @total_number_of_items = authorized.count
    @blocks = authorized.paginate(:page => params[:page])
    check_permissions
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
