require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ChordSuggestor
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join('app/classes')
    config.eager_load_paths << Rails.root.join('app/presenters')
    config.eager_load_paths << Rails.root.join('app/services')

    # add samples folder in the assets folder
    config.assets.paths << Rails.root.join('app', 'assets', 'samples')

    # precompile the samples folder
    config.assets.precompile += %w[*.wav]
  end
end
