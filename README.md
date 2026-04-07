# Save Puffendale

A gamified task management app where completing your to-dos earns magic points that restore a cursed village from the Witch of Procrastination.

## How It Works

- Create task lists and add tasks
- Mark tasks as complete to earn **+10 magic points**
- Unmark tasks to lose **-10 magic points**
- Magic points unlock achievements and improve the village status
- Choose a difficulty level — harder modes apply a weekly magic points decay

See [GAME_DESIGN.md](GAME_DESIGN.md) for full mechanics.

## Tech Stack

- **Ruby** 3.2.9 / **Rails** 7.2
- **PostgreSQL**
- **Tailwind CSS** + **DaisyUI**
- **Hotwire** (Turbo + Stimulus)
- **Devise** (authentication)
- **Resend** (email)
- **PWA** support

## Setup

### Prerequisites

- Ruby 3.2.9
- PostgreSQL
- Node.js (for Tailwind)

### Install

```bash
bin/setup
```

This installs gems, creates and migrates the database.

### Run

```bash
bin/dev
```

App runs at `http://localhost:3000`. This also starts the Tailwind CSS watcher.

## Environment Variables

| Variable | Description |
|---|---|
| `DATABASE_URL` | PostgreSQL connection string (production) |
| `RESEND_API_KEY` | API key for email sending via Resend |
| `SECRET_KEY_BASE` | Rails secret key (production) |

## Testing

```bash
bin/rails test           # Unit and integration tests
bin/rails test:system    # System tests (requires Chrome)
bin/brakeman             # Security scan
bin/rubocop              # Linting
```

## Docker

```bash
docker build .
```

The `bin/docker-entrypoint` script handles startup.

## Database Schema

```
users          — id, name, email, magic_points, difficulty, devise fields
task_lists     — id, name, user_id
tasks          — id, name, completed, task_list_id
```
