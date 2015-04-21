class BcmsBlog::BlogCommentsController < Cms::ContentBlockController

  private
  def blog_comment_params
    params.require(:blog_comment).permit(BcmsBlog::BlogComment.permitted_params)
  end
end

