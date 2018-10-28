# mailer-microservice
example microservice for sending emails 


# Configuration 

Edit config/config.yml and put your SMTP credentials.
The service was made to work with AWS SES but will work with any smtp service. 

```yml
smtp:
  aws:
    host: email-smtp.us-east-1.amazonaws.com 
    port: 587 
    user: <%= ENV['AWS_SMTP_USER'] %>
    pass: <%= ENV['AWS_SMTP_PASS'] %> 
    domain: <%= ENV['AWS_SMTP_DOMAIN'] %>
```    

# API 

`POST /job` will add a job to the mailer worker 

`GET /templates` returns a json list of all the available templates

`GET /status` returns the current status of the queue taken from sidekiq


try this curl for testing:

```bash
curl --header "Content-Type: application/json" --request POST --data '{"type": "mailer", "params": {"template":"bienvenido_V3.html","from":"info@mycompany.com","to":"john@hotmail.com","subject":"Hola amigo como va"}}'  http://localhost:8080/job
```


# Templates

On `/templates/` you will find the mail template.
It is rendered with erb, so you can add your own variables. 

# Start the serivce

Just use foreman

```bash
foreman start
```
