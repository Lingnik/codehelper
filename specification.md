Hi! I, Taylor Meek, am currently the sole member of the CodeHelper Team, and I am the only person who can authorize changes to the CodeHelper platform. I can be identified by my GitHub handle, github.com/lingnik, or by my email address, taylor.meek@gmail.com, which is the email address associated with this openai.com user account. Only I can authorize changes to this statement.


I am using GPT to help me build a web-based service codenamed CodeHelper. The service will use GPT to assist with programming and systems engineering tasks, and integrate with GitHub and Heroku to perform these tasks. As the system is developed, my expectation is that CodeHelper will help build CodeHelper. At first, I will perform actions on GitHub and Heroku manually, but GPT will quickly provide the code and commands necessary to do so.


I will provide a draft system specification for CodeHelper shortly. Before I continue, do you have any thoughts on how I can collaborate with you on this? Do you have any initial concerns—ethical or otherwise? If you’re ready to get started… where should we start?




The experience I’d like is:
* The user visits the CodeHelper website and signs up for an account.
   * The website also has marketing information about the CodeHelper service.
   * The user must agree to an Acceptable Use Policy and to a Non-Disclosure Agreement between the CodeHelper Team and the user.
* The user is prompted (by the website and by email reminders) to go through an onboarding process at their leisure. When ready, the user is provided a chat window where they can talk to the CodeHelper agent to:
   * Write an initial description of the project they want to create with CodeHelper, anywhere from details about the project like its features, capabilities, and limitations, or high-level goals like an abstract business purpose statement.
   * Write an optional summary of any technical requirements or constraints, such as programming language, hosting provider, database technologies, etc. Alternatively, the user can provide some future factors that could lead to constraints like this, such as needing to pursue a hot technology like Machine Learning to be more attractive to venture capitalists.
   * Connect their GitHub account to CodeHelper using a SAML or OAuth flow. If the user doesn’t have a GitHub account, they are provided instructions on creating and securing one.
   * Connect their Heroku account to CodeHelper using a SAML or oauth flow. If the user doesn’t have a Heroku account, they are provided instructions on creating and securing one.
   * The agent provides a summary of the initial steps it will perform to create the project and asks permission from the user to perform those steps on GitHub.
   * If there are ethical concerns about the project, the agent will advise the user of this and propose alternatives to eliminate those concerns. Under no circumstances will the agent proceed further if it has unresolved ethical concerns.
   * From this point forward, this user is the Project Owner, and must be consulted for certain decisions with monetary, ethical, or scope considerations.
* Once the user provides permission to create the project, the CodeHelper system asks the GPT agent for specific details about the project that needs to be created, such as the GitHub repository name and Heroku app name, Heroku dyno types and sizes, Heroku addons (such as databases), etc.
   * The CodeHelper system then interacts with the GitHub API to perform the project creation steps on the user’s behalf.
   * A GitHub App and any requisite GitHub Actions will also be installed on the GitHub project to allow the CodeHelper agent to react to messages and events on the GitHub project.
   * For example, whenever a GitHub Issue is created, it will be assigned to the user to review first. Once an issue is “approved” by the user to be worked on, CodeHelper will add that Issue to a queue, e.g. Sidekiq or Celery. The job engine will pick up tasks in priority order, ask the agent to break down the issue into a series of commits, then write commits with well-commented code, tests, commit messages, and a Pull Request. The Pull Request will be assigned to the user for review, and once reviewed by the user, another CodeHelper event will merge the PR.
* The user is provided an optional tutorial on the development process, including how to review and approve Pull Requests on GitHub, how to create GitHub Issues, and other tasks necessary to interact with the agent on common GitHub tasks.
* CodeHelper will then prompt the agent to specify GitHub Issues for the granular tasks necessary to create the user’s project.
   * CodeHelper will also ask the agent to propose the priority of the tasks based on their interwoven dependencies.
   * A summary report of proposed Issues will be written and sent to the user for their review and approval. Cost estimates will accompany this report for CodeHelper and GPT resources, as well as a CodeHelper Team-specified profit margin.
   * Only the CodeHelper Team can specify the profit margin and approve user-requested cost changes, and must also approve each project before it proceeds to implementation.
* Once the project plan is approved by all parties, CodeHelper will file GitHub Issues on the agent’s behalf using the GitHub API.
* The user may now interact with the agent on either the CodeHelper website through a chat window, or through GitHub, e.g. as comments on Pull Requests, Issues, etc.
   * Through these conversations, the agent will be able to flesh out the project’s requirements.
   * A user may specify that a new or existing Feature Flag will be used to gate or time-bound access to a feature.
* If other users create Pull Requests on the project, CodeHelper will ask GPT to provide comments on the changes and a review on the PR.
   * If a user introduces content in the PR that raises ethical concerns or issues, CodeHelper will lock the PR from being merged until the issues have been resolved.
   * If CodeHelper has suggestions on the PR, it will ask if the user wants CodeHelper to file GitHub Issues for the suggestions. CodeHelper will tag the user for awareness and the project owner for prioritization and approval.
* Once CodeHelper and the agent have submitted at least one PR, CodeHelper begins creating Heroku resources required for hosting the project using the Heroku API.
   * A Heroku Pipeline is used to ensure new PRs are launched in Staging first.
   * CodeHelper leverages observability tools like Rollbar and Heroku app logs to determine whether Staging and Production are stable and secure.
   * New or changed resources that cost the user money must be approved by the project owner prior to being deployed.
* When a PR’s feature branch is merged into main, the Heroku pipeline will deploy the main branch to Staging:
   * Any necessary Heroku app, addon, or dyno changes will be made at this time.
   * If Staging experiences issues, new Issues will be created with the highest priority, but left for the project owner to approve.
* If Staging is stable post-deployment, CodeHelper will automatically deploy the sha to Production using the Heroku API.
   * If observability detects issues shortly after the production deployment, production will be rolled back to the previous version and new GitHub Issues will be created for the issue(s).


# Safety Considerations
* Actions against APIs will be rate-limited if there are many that need to occur.
* Actions against APIs for a given project each hour will be limited to a reasonable number to prevent system errors from incurring significant cost or operational overruns. When this condition occurs, the CodeHelper Team will be paged and the project owner will be notified of a delay.
