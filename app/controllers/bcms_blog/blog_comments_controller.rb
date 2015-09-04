class BcmsBlog::BlogCommentsController < Cms::ContentBlockController
  after_filter :check_if_published, :only => :update

  # this is the same method called from BrowserCMS on controllers/cms/content_block_controller.rb
  # it was needed to move it here to add the extra layout of verification and avoid to show the
  # comments that are not allowed to see based on permissions
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
    scope = scope.eager_load(post: :blog).where('cms_blogs.deleted = 0 and cms_blog_posts.deleted = 0')
    authorized = scope.to_a.select{|b| !b.deleted? && !b.post.deleted? && b.post.editable_by?(current_user)}

    @total_number_of_items = authorized.count
    @blocks = authorized.paginate(:page => params[:page])
    check_permissions
  end

  private

  def check_if_published
    if params[:commit].parameterize.underscore.eql?('publish')
      model_class.find(params[:id].to_i).publish!
    end
  end

  def blog_comment_params
    params.require(:blog_comment).permit(
        :name,
        :post_id,
        :author,
        :email,
        :url,
        :ip,
        :body,
        :version,
        :lock_version,
        :name,
        :published,
        :deleted,
        :archived,
        :created_by_id,
        :updated_by_id,
        :created_by_type,
        :updated_by_type,
        :created_at,
        :updated_at
    )
  end
end

