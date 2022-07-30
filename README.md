# lambda-scraper

Lambda deployment for automated website scraping.

## Commands

Create `requirements.txt` from `pyproject.toml`, skip everything after `;`

```bash
poetry export -f requirements.txt --without-hashes | sed -e 's/;.*//' > requirements.txt
```

## Considerations

- to send emails to other people move out of [AWS SES Sandbox](https://docs.aws.amazon.com/ses/latest/dg/request-production-access.html?icmpid=docs_ses_console)
