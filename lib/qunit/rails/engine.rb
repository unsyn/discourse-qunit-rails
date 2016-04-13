module QUnit
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace QUnit::Rails

      config.qunit = ActiveSupport::OrderedOptions.new
      config.qunit.tests_path       = "test"
      config.qunit.javascripts_path = "javascripts"
      config.qunit.stylesheets_path = "stylesheets"

      # https://github.com/rails/sprockets-rails/issues/299#issuecomment-167701012
      # This doesn't really make sense since the assets are not going to be
      # available in production.
      config.after_initialize do
        ActiveSupport.on_load(:action_view) do
          default_checker = ActionView::Base.precompiled_asset_checker

          ActionView::Base.precompiled_asset_checker = -> logical_path do
           default_checker[logical_path] ||
           %w{qunit.js qunit.css test_helper.css test_helper.js}.include?(logical_path)
          end
        end
      end
    end
  end
end
