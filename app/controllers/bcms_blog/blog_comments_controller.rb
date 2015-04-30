class BcmsBlog::BlogCommentsController < Cms::ContentBlockController
  private
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

