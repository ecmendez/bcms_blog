class BcmsBlog::BlogsController < Cms::ContentBlockController
  check_permissions :administrate, :except => :index

  def index
    if current_user.able_to?(:administrate)
      super
    else
      render :action => 'admin_only'
    end
  end

  private

  def blog_params
    params.require(:blog).permit(
        :name,
        :format,
        :template,
        :moderate_comments,
        :version,
        :lock_version,
        :published,
        :deleted,
        :archived,
        :created_by_id,
        :updated_by_id,
        :created_at,
        :updated_at,
        :group_ids => []
    )
  end
end

