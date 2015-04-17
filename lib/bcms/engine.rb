require 'browsercms'

module Bcms
  class Engine < Rails::Engine
    include Cms::Module
    isolate_namespace Bcms

    config.active_record.observers = 'bcms/blog_observer'

    config.to_prepare do
      Cms::ViewContext.send(:include, Bcms::BlogHelper)
      ApplicationHelper.send(:include, Bcms::BlogHelper)
    end

    initializer 'bcms.route_extensions', :after => 'action_dispatch.prepare_dispatcher' do |app|
       ActionDispatch::Routing::Mapper.send :include, Bcms::RouteExtensions
    end

    config.before_configuration do |app|
      # Used by blog_feed_url to determine the host
      Rails.application.routes.default_url_options[:host]= config.cms.site_domain
    end
  end
end
