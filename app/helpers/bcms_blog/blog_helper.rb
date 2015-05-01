module BcmsBlog
  module BlogHelper
    # We can't call it 'blog_path' because that would conflict with the actual named route method if there's a blog named "Blog".
    def _blog_path(blog, route_name, route_params)
      send("#{blog.name_for_path}_#{route_name}_path", route_params)
    end

    def _blog_post_path(blog_post)
      send("#{blog_post.route_name}_path", blog_post.route_params)
    end
  
    def feeds_link_tag_for(name)
      blog = Blog.find_by_name(name)
      auto_discovery_link_tag(:rss, main_app.blog_feeds_url(:blog_id => blog), :title => "#{blog.name}")
    end

    def like_comment(user, blog_post)
      Cms::Engine.routes.url_helpers.portlet_handler_path(:id=>@portlet.id, :handler=>'like_comment', :liker => user, :liker_type => user.class.to_s, :blog_post => blog_post)
    end

  end
end
