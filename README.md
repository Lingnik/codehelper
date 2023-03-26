# Intelligent Code Generator

This project is an experiment in generating Ruby code using GPT-3.5 and GitHub Issues. It provides a framework for specifying a project in terms of desired functionality, then generating the code necessary to accomplish those goals using an AI language model.

## Requirements

- Ruby 2.7.2 or higher
- A GitHub account
- An OpenAI API key

## Installation

1. Clone this repository.
2. Install dependencies: `bundle install`
3. Copy `.env.example` to `.env`: `cp .env.example .env`
4. Update `.env` with your GitHub and OpenAI API keys.
5. Run `ruby gh_create_project_issues.rb your_username repo_name project_title` to create GitHub Issues for your project.
6. Tag the issues that you want to generate code for with the "approved" label.
7. Run `ruby gh_auto_code_generation.rb your_username repo_name` to generate code for the approved issues.

## Usage

### Creating Project Issues

To create project issues, run the following command:
```
ruby gh_create_project_issues.rb your_username repo_name project_title
```

Replace `your_username`, `repo_name`, and `project_title` with the appropriate values for your project. This will create a new GitHub Issue for each item in the `specification.md` file in the root of this repository.

### Generating Code

To generate code for approved project issues, first tag the issue with the "approved" label in GitHub. Then run the following command:

```
ruby gh_auto_code_generation.rb your_username repo_name
```

Replace `your_username` and `repo_name` with the appropriate values for your project. This will generate Ruby code files in the `generated_code` directory for each approved issue.

### Testing Generated Code

To test generated code, first ensure that the necessary Ruby Gems are installed. Then run the following command:

```
ruby generated_code/issue_1.rb
```

Replace `issue_1.rb` with the appropriate filename for the code you wish to test. This will execute the generated code.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)

