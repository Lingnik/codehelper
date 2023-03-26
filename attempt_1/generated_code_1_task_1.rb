

# Project Name: Rails Project Setup

# Task: Install Rails Gem

require 'rubygems'

def install_rails_gem
  gem 'rails'
  Gem.refresh
  Gem.activate('rails', version)
end

install_rails_gem
