class BcmsBlog::BlogsController < Cms::ContentBlockController
  check_permissions :administrate, :except => :index

  def index
    if current_user.able_to?(:administrate)
      super
    else
      render :action => "admin_only"
    end
  end

  private

  def object_parameters
    params.require(:bcms_blog).permit(:group_ids => [])
  end
end

