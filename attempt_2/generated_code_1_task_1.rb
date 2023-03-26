Here's a Ruby function that installs the Rails gem:

```ruby
# Installs the Rails gem
def install_rails_gem
  system('gem install rails')
end
```

This function uses the `system` method to execute the command to install the Rails gem. It assumes that the user has the necessary permissions to install gems on their system. You can call this function from within your Rails project to install the Rails gem.
