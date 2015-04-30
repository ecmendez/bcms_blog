class BcmsBlog::BlogCommentsController < Cms::ContentBlockController
  after_filter :check_if_published, :only => :update

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

