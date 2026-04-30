# Sinatra URL Shortener

A production-friendly Sinatra URL shortener with authentication, roles, audit logging, dashboard analytics, API endpoints, and OpenSearch support.

## Features

- Role-based access (`admin`, `editor`, `reader`)
- Link creation, redirect, and hit tracking
- Advanced search by name, URL, category, and tags
- Account settings page for password changes
- Audit logging for security-sensitive actions
- JSON API for listing/creating/deleting links
- RSpec request tests
- Dockerized runtime

## Tech Stack

- Ruby + Sinatra
- Sequel ORM
- SQLite
- RSpec + Rack::Test

## Quick Start

```bash
bundle install
bundle exec rackup
```

Then open `http://localhost:4567`.

## Seed Admin User

```bash
ruby db/seeds.rb
```

Default credentials:

- username: `admin`
- password: `admin123`

## Roles and Permissions

- `admin`: full access (manage links, remove links, dashboard)
- `editor`: can create links and view dashboard
- `reader`: read-only access and redirects

## Test

```bash
bundle exec rspec
```

## Docker

Build:

```bash
docker build -t sinatra-shortener .
```

Run:

```bash
docker run --rm -p 4567:4567 \
  -e SESSION_SECRET=replace-this-secret \
  sinatra-shortener
```

## API Overview

### `GET /api/links`
Returns all links.

### `POST /api/links` (admin only)
Body:

```json
{
  "name": "docs",
  "url": "https://example.com/docs"
}
```

### `GET /api/links/:id`
Returns link details by ID.

### `DELETE /api/links/:id` (admin only)
Deletes a link.

## Suggested Next Upgrades

- OAuth login (Google/GitHub)
- Email notifications on create/delete events
- Auto-generated API docs with Rswag/OpenAPI
