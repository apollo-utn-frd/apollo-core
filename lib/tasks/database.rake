# frozen_string_literal: true

namespace :db do
  desc 'Delete all images when drop database'
  task :drop do
    Dir[Rails.root.join('public', '*', '**.jpg')].each { |f| File.delete(f) }
  end
end
