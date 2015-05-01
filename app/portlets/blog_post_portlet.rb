class BlogPostPortlet < Cms::Portlet

  enable_template_editor false

  def render

    scope = BcmsBlog::Blog.find(self.blog_id).posts
    if params[:blog_post_id]
      @blog_post = scope.find(params[:blog_post_id])
    elsif params[:slug]
      if params[:year]
        date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
        scope = scope.published_between(date, date + 1.day)
      end
      @blog_post = scope.find_by_slug!(params[:slug])
    else
      raise BcmsBlog::BlogPost::INCORRECT_PARAMETERS
    end

    make_page_title_use_blog_post_name(@blog_post)

    pmap = flash[instance_name] || params
    pmap[:blog_comment] ||= {}
    @blog_comment = @blog_post.comments.build(blog_comment_params)
    @blog_comment.errors.add_from_hash flash["#{instance_name}_errors"]
  end

  def create_comment
    params[:blog_comment].merge! :ip => request.remote_ip
    blog_comment = BcmsBlog::BlogComment.new(blog_comment_params)

    blog_comment.update_attributes(created_by: Cms::User.current,
                                   updated_by: Cms::User.current ,
                                   created_by_type:Cms::User.current.class.to_s ,
                                   updated_by_type:Cms::User.current.class.to_s )
    if blog_comment.valid? && blog_comment.save
      url_for_success
    else
      store_params_in_flash
      store_errors_in_flash(blog_comment.errors)
      url_for_failure
    end
  end

  def like_comment
    blog_post = BcmsBlog::BlogPost.find_by_id(params[:blog_post])
    liker = params[:liker_type].constantize.find_by_id(params[:liker])

    if blog_post && liker
      begin
        blog_post.is_liked_by!(liker)
        url_for_success
      rescue
        store_params_in_flash
        store_errors_in_flash(blog_post.errors)
        url_for_failure
      end
    end
  end

  private
  # This is a work around for a bug in bcms 3.3 where the Cms::PageHelper#page_title doesnt
  #   share state between the portlet view and the page view.
  #   When the portlet view (app/views/portlets/blog_post/render) calls 'page_title @post.name'
  #   that instance variable isn't shared back to the page template.
  # Instead, we just temporarily set the name of the page itself.
  def make_page_title_use_blog_post_name(post)
    page = @controller.current_page
    page.name = post.name
  end

  def blog_comment_params
    params[:blog_comment].permit(BcmsBlog::BlogComment.permitted_params) unless params[:blog_comment].nil?
  end
end
