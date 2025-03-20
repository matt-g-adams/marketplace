# README

## [Rate Limiter](https://github.com/matt-g-adams/marketplace/blob/main/lib/rate_limiter.rb)

* I made constants for `MAX_REQUESTS` and `WINDOW` so there are no magic numbers in the code.
* I used a `Hash` data structure to allow constant time lookups of requests by `user_id`.
* The values in the `Hash` are Arrays of request timestamps for the each user.
* I decided that if a user makes two requests at exactly 30 seconds apart, those would be considered part of the same window.
* Each time `allow_request?` is called, timestamps that are more than 30 seconds old are deleted from the user's `Array`.
* A `timestamp` is only added to the `Array` if the request is accepted.
* Assuming that the number of allowed requests per time window is a contant, this ensures that the algorithm runs in constant time.
* If i needed to scale to more users or if I needed to coordinate rate limiting across server instances, I could easily use Redis instead of a `Hash`.

## Job Marketplace API

* API Endpoints (CRUD) - I used resourceful routing to map paths to OpportunitiesController actions.
* Performance
    * I made sure to call `Opportunity.includes(:client)` to prevent N+1 queries.
    * I added indexes to `Client.email`, `Client.name`, and `Opportunity.salary`. This will ensure a constant time index seek vs a linear time table scan when searching by these fields.
    * All primary keys and foreign keys should have indexes by default.
    * I used simple `LIKE` queries to search `Opportunity.title` and `Opportunity.description`, and unfortunately, indexes can't prevent a table scan here. If this caused performance inssues, I might use the `pg_search` gem or perhaps even something like Elasticsearch.
    * I cached search results keyed on the request parameters, with a TTL of 1 minute.
* Modular Code
    * I put some of the complexity of searching opportunities in an `OpportunityService`.
    * I put some of the complexity of creating a `JobApplication` for an `Opportunity` in a `JobApplicationService`.
* Background Job
    * I added the sidekiq gem and configured Active Job to use Sidekiq as a backend in production. This should ensure that all delayed sending of emails happens through Sidekiq.
    * I created a previewable email in html and text format as a fallback.
* Good Test Coverage - I focused my testing on the routing and request level since that's what was asked for. In real life, I'd test the models, services, and mailer as well.
