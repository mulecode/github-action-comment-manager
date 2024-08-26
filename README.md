# Comment Manager

GitHub plugin for commenting PR's

## How to use it

```yaml
  test_commenter:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: mulecode/github-action-comment-manager@main
        with:
          authToken: ${{ secrets.GITHUB_TOKEN }}
          issueNumber: ${{ github.event.pull_request.number }}
          commentTitle: "TEST-1234"
          commentBody: |
            Hello, I am a comment.
            Thank you!
```

The commentTitle is used to identify the comment,
if the comment already exists, it will be updated, otherwise it will be created.
