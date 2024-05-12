```markdown
This README provides instructions for setting up, running, and using the Rails application via Docker. This setup ensures a consistent environment for development and deployment.

## Prerequisites

- **Docker**
- **Docker Compose**

## Setup and Running the Application

1. **Clone the repository**:
   ```bash
   git clone https://github.com/ruuke/match_performance.git
   cd your-repo-name
   ```

2. **Build and start the application using Docker Compose**:
   ```bash
   docker-compose up --build
   ```
   This command builds the Docker image if it's not already built and starts all containers specified in the `docker-compose.yml` file.

3. **Create and migrate the database**:
   ```bash
   docker-compose run web rails db:create db:migrate
   ```

4. **Seed the database**:
   ```bash
   docker-compose run web rails db:seed
   ```

## Using the Application
- **Access**: Navigate to `http://localhost:3000`

### API Endpoints

#### Record a New Performance

- **Endpoint**: `POST /v1/performances`
- **Payload**:
   ```json
   {
     "player_id": 1,
     "match_id": 2,
     "performance_indicator_id": 3,
     "achieved": true
   }
   ```
- **Response**:
   - `201 Created`:
      ```json
      {
        "message": "Performance successfully recorded"
      }
      ```
   - `422 Unprocessable Entity`:
      ```json
      {
        "errors": {
          "player_id": ["can't be blank"],
          "match_id": ["can't be blank"],
          "performance_indicator_id": ["can't be blank"],
          "achieved": ["can't be blank"]
        }
      }
      ```

#### Check Performance Indicator

- **Endpoint**: `GET /v1/performances/check_indicator`
- **Query Parameters**: `player_id=1&indicator_id=2`
- **Response**:
   - `200 OK`:
      ```json
      {
        "status": true
      }
      ```

#### Get Top Performers

- **Endpoint**: `GET /v1/performances/top_performers`
- **Query Parameters**: `indicator_id=3` (optional `team_id=1`)
- **Response**:
   - `200 OK`:
      ```json
      [
        {"id": 1, "name": "John Doe", "performances_count": 5},
        {"id": 2, "name": "Jane Doe", "performances_count": 4},
        {"id": 3, "name": "Sam Smith", "performances_count": 3}
      ]
      ```

### Using PgHero

- **Access**: Navigate to `http://localhost:8080` to view the PgHero dashboard for database performance insights.

## Contribution

Feel free to fork the repository, make changes, and submit a pull request if you have improvements or fixes to contribute.
```
