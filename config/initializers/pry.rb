# frozen_string_literal: true

# Show red environment name in pry prompt for production environment
if Rails.env.production?
  old_prompt = Pry.config.prompt
  app = Pry::Helpers::Text.red('APOLLO')
  Pry.config.prompt = [
    proc { |*a| "#{app} #{old_prompt.first.call(*a)}" },
    proc { |*a| "#{app} #{old_prompt.second.call(*a)}" }
  ]
end
