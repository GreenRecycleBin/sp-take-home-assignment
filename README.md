# Technical Choices
  - API: [Ruby Grape](http://www.ruby-grape.org/)
  - Documentation: [Swagger](https://swagger.io/)
  - Server: [Ruby on Rails](http://rubyonrails.org/)
  - Database: [PostgreSQL](https://www.postgresql.org/)
  - PaaS: [Heroku](https://www.heroku.com/)

Heroku greatly simplifies deployement. PostgreSQL is its recommended database.
Rails is fast to get up and running. I'm familiar with these technologies.

I've heard of Grape and Swagger before, but have never tried them. Since they
fit for this exercise (i.e. building APIs), I decided to try them out.

I used TDD for this exercise.

# OpenAPI documentation
  1. Visit http://petstore.swagger.io
  2. Paste https://glacial-badlands-97178.herokuapp.com/api/swagger_doc into the input field
  3. Click "Explore" button

# Sample Run
```shell
$ curl -H 'Content-Type: application/json' -X POST -d '{"friends": ["a@example.com", "b@example.com"]}' https://glacial-badlands-97178.herokuapp.com/api/friendship
{"success": true}

$ curl -H 'Content-Type: application/json' -G -d 'email=a@example.com' https://glacial-badlands-97178.herokuapp.com/api/friendship
{"success":true,"friends":["b@example.com"],"count":1}

$ curl -H 'Content-Type: application/json' -G -d 'email=b@example.com' https://glacial-badlands-97178.herokuapp.com/api/friendship
{"success":true,"friends":["a@example.com"],"count":1}

$ curl -H 'Content-Type: application/json' -G -d 'friends[]=a@example.com' -d 'friends[]=b@example.com' https://glacial-badlands-97178.herokuapp.com/api/friendship/common
{"success":true,"friends":[],"count":0}

$ curl -H 'Content-Type: application/json' -X POST -d '{"friends": ["a@example.com", "c@example.com"]}' https://glacial-badlands-97178.herokuapp.com/api/friendship
{"success": true}

$ curl -H 'Content-Type: application/json' -X POST -d '{"friends": ["b@example.com", "c@example.com"]}' https://glacial-badlands-97178.herokuapp.com/api/friendship
{"success": true}

$ curl -H 'Content-Type: application/json' -G -d 'friends[]=a@example.com' -d 'friends[]=b@example.com' https://glacial-badlands-97178.herokuapp.com/api/friendship/common
{"success":true,"friends":["c@example.com"],"count":1}

$ curl -H 'Content-Type: application/json' -X POST -d '{"requestor": "d@example.com", "target": "a@example.com"}' https://glacial-badlands-97178.herokuapp.com/api/update
{"success": true}

$ curl -H 'Content-Type: application/json' -G -d 'sender=a@example.com' -d 'text=Hello,%20e@example.com%20and%20f@example.com' https://glacial-badlands-97178.herokuapp.com/api/update
{"success":true,"recipients":["b@example.com","c@example.com","d@example.com","e@example.com","f@example.com"]}

$ curl -H 'Content-Type: application/json' -X POST -d '{"requestor": "e@example.com", "target": "a@example.com"}' https://glacial-badlands-97178.herokuapp.com/api/update/block
{"success": true}

$ curl -H 'Content-Type: application/json' -G -d 'sender=a@example.com' -d 'text=Hello,%20e@example.com%20and%20f@example.com' https://glacial-badlands-97178.herokuapp.com/api/update
{"success":true,"recipients":["b@example.com","c@example.com","d@example.com","f@example.com"]}

$ curl -H 'Content-Type: application/json' -X POST -d '{"friends": ["a@example.com", "d@example.com"]}' https://glacial-badlands-97178.herokuapp.com/api/friendship
{"success":true}

$ curl -H 'Content-Type: application/json' -G -d 'email=d@example.com' https://glacial-badlands-97178.herokuapp.com/api/friendship
{"success":true,"friends":["a@example.com"],"count":1}

$ curl -H 'Content-Type: application/json' -X POST -d '{"friends": ["a@example.com", "e@example.com"]}' https://glacial-badlands-97178.herokuapp.com/api/friendship
{"success":true}

$ curl -H 'Content-Type: application/json' -G -d 'email=e@example.com' https://glacial-badlands-97178.herokuapp.com/api/friendship
{"success":true,"friends":[],"count":0}
```
