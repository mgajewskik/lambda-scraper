# lambda-scraper

Create `requirements.txt` from `pyproject.toml`, skip everything after `;`

```bash
poetry export -f requirements.txt --without-hashes | sed -e 's/;.*//' > requirements.txt
```

TODO:

- create a cloudwatch event to invoke lambda automatically
- create github actions pipeline that automatially deploys the code with each push to master

## Considerations

- to send emails to other people move out of [AWS SES Sandbox](https://docs.aws.amazon.com/ses/latest/dg/request-production-access.html?icmpid=docs_ses_console)
