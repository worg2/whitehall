require File.expand_path('../boot', __FILE__)

require "rails"
require 'active_record'

unless ENV["SKIP_OBSERVERS_FOR_ASSET_TASKS"].present?
  require "active_record/railtie"
end
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(assets: %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Whitehall
  class Application < Rails::Application
    require 'whitehall'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(
      #{config.root}/app/presenters
      #{config.root}/app/services
      #{config.root}/app/uploaders
      #{config.root}/app/validators
      #{config.root}/app/workers
      #{config.root}/lib
      #{config.root}/app/concerns
    )

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # Active record will be disabled when compiling assets.
    if config.respond_to?(:active_record)
      config.active_record.observers = [
        :ministerial_role_search_index_observer,
        :corporate_information_page_search_index_observer
      ]
    end

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'London'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]

    # We need to set the I18n.available_locales early in the initialization process
    # as it is used to generate the regex for the LocalizedRouting patch. To keep things DRY
    # we use Whitehall.available_locales for the canonical definition of this.
    config.i18n.default_locale = :en
    config.i18n.available_locales = Whitehall.available_locales

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.initialize_on_precompile = true

    config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.prefix = Whitehall.router_prefix + config.assets.prefix
    config.slimmer.wrapper_id = "whitehall-wrapper"

    config.action_dispatch.ignore_accept_header = true

    # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
    # the I18n.default_locale when a translation can not be found)
    config.i18n.fallbacks = true

    config.generators do |generate|
      generate.helper false
      generate.assets false
      generate.test_framework :test_unit, fixture: false
    end
  end
end
