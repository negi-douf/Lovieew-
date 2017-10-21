require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Lovieew
  class Application < Rails::Application
    config.i18n.default_locale = :ja
    config.active_record.raise_in_transactional_callbacks = true

    # CarrierWave NameError 回避
    config.autoload_paths += Dir[Rails.root.join('app', 'uploaders')]
  end
end
