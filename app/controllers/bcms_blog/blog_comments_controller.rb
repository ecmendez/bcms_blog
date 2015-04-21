class BcmsBlog::BlogCommentsController < Cms::ContentBlockController

  private
  def blog_comment_params
     params.require(:blog_comment).permit(:name, :author, :email, :body, :url, :post_id, :ip)
  end
end

