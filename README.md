# Sleep Tracker API

A Rails-based API for tracking and sharing sleep records.  
Provides endpoints to clock in/out sleep sessions, view weekly summaries, and follow other users.

---

## Ruby Version
3.3.0

---

## Configuration
Before running the app or tests, make sure to set the required environment variables.

```bash
DB_USERNAME=db_username
DB_PASSWORD=db_password
DB_HOST=db_host
```

---

## Running Test Suite
To install dependencies and run the test suite:

```bash
bundle install
bundle exec rails db:create db:schema:load RAILS_ENV=test
bundle exec rspec spec/requests/v1/sleep_trackers_spec.rb
```

---

## Running the Rails Server
Start the server in development:
```bash
bin/rails server
```
Default server runs at:
```bash
http://localhost:3000
```

---

## API Endpoints
### Authentication
<b>POST</b> `/v1/login` – log in <br>
payload
```json
{
  "user": {
    "name": "username",
    "password": "password"
  }
}
```
response
```json
{
  "token": "...."
}
```

### Sleep Tracker <br>
<b>POST</b> `/v1/sleep_tracker/toggle` – Clock in / clock out <br>
header
```json
{
  "Authorization": "Bearer ...."
}
```
<b>GET</b> `/v1/sleep_tracker/followed` – Get paginated sleep records from followed users <br>
header
```json
{
  "Authorization": "Bearer ...."
}
```

### Users <br>
<b>POST</b> `/v1/follow/:user_id` – Follow a user <br>
header
```json
{
  "Authorization": "Bearer ...."
}
```
<b>DELETE</b> `/v1/unfollow/:user_id` – Unfollow a user <br>
header
```json
{
  "Authorization": "Bearer ...."
}
```
