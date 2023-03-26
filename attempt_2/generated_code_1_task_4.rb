Here's a Ruby function that adds an initial commit with Rails project structure:

```
def add_initial_commit
  # This function adds an initial commit with Rails project structure.
  # Assumes that the project has already been created and initialized with Git.
  
  # Add all files to staging
  `git add .`
  
  # Create initial commit with message
  `git commit -m "Initial commit with Rails project structure"`
end
```

You can call this function at the beginning of your project to create an initial commit with the Rails project structure. The function assumes that the project has already been created and initialized with Git.
