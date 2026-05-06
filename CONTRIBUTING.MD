# Contributing


## Basic rules for everyone

1. Make a pull request early to enable discussion
2. Ask for a reviewer and allow sufficient time for reviewing
3. Merge only after a review


## Making changes using pull requests

The lumi-userguide repository uses the `production` as the default
branch. You can make changes in web gui, command line or desktop application.

`production` branch is protected. You cannot make changes to it directly, but you
must use pull requests.


### Workflow for a pull request
 - Create your own branch (or work in an already existing branch, if agreed)
    - from `production` if you are a member of the repository
    - [fork the repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) otherwise
 - Create / bring there the content you want to work with. Pay attention to file naming!
 - Make sure to check that the language is correct, commands work, and style is same as in other articles.
 - When creating a new page, add it also to the `mkdocs.yml` navigation.
 - Make a pull request for your work to be added to `production`
    - Assign one or more reviewers, try to choose someone who knows the _content_.
        - Please add a link to the rahtiapp-preview page `https://lumi-supercomputer-docs-preview.rahtiapp.fi/origin/<your-branch-name>/rest-of-url/` in the Pull Request description to help reviewer.
    - Pull requests which do not meet the requirements will not be accepted. Note that you can keep committing to a pull request after it has been submitted.
    - Write meaningful pull request messages, so it is easier for reviewers to do their job.
    - Communicate! Use a [draft PR](https://github.blog/news-insights/product-news/introducing-draft-pull-requests/), if you don't wish the branch to be merged to master (i.e. you want to continue working with it).
 - Once your PR has been accepted, remove the temporary branch (if not deleted automatically at merge)


### Previewing changes

#### Active branches

The GitHub web interface gives a preview but it does not render all syntax used in mkdocs correctly.
A full preview for ongoing work is available for all branches: <https://lumi-supercomputer-docs-preview.rahtiapp.fi/origin>.
Note that this means that your changes can be seen by anyone including search-engines and AI web crawler, so remember that if you proposed change is sensitive.

#### Local preview

You can also build the documentation locally. See the [README](README.md) for instructions.

