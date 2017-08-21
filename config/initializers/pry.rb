# frozen_string_literal: true

# Show red environment name in pry prompt for production environment
if Rails.env.production?
  old_prompt = Pry.config.prompt
  env = Pry::Helpers::Text.red(Rails.env.upcase)
  Pry.config.prompt = [
    proc { |*a| "#{env} #{old_prompt.first.call(*a)}" },
    proc { |*a| "#{env} #{old_prompt.second.call(*a)}" }
  ]
end
