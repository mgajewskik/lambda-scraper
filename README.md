# lambda-scraper

TODO:
- create lambda layer
- package dependencies in a lambda layer with a script? or try to use a makefile
- create a cloudwatch event to invoke lambda automatically
- how do I send email via lambda? maybe I don't need any external packages?
- write scraper that scrapes the movies
- create github actions pipeline that automatially deploys the code with each push to master
- create backend of S3 for terraform state, or maybe terraform online?
- create s3 buckets to store state files there
- pass email as an environment variable to lambda function
- how to I use the damn makefile?
- how to pass github secrets to terraform variables?

# Considerations
- to send emails to other people move out of [AWS SES Sandbox](https://docs.aws.amazon.com/ses/latest/dg/request-production-access.html?icmpid=docs_ses_console)
