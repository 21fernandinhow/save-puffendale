# CLAUDE.md — Save Puffendale

Project context and coding conventions for AI assistance.

## What This App Does

Gamified to-do list. Completing tasks earns magic points that restore a cursed village. See [GAME_DESIGN.md](GAME_DESIGN.md).

## Key Commands

```bash
bin/dev             # Start server + Tailwind watcher (localhost:3000)
bin/setup           # Install gems, create/migrate DB
bin/rails test      # Run tests
bin/rails test:system
bin/brakeman        # Security scan
bin/rubocop         # Linting
```

## Tech Stack

- Ruby 3.2.9 / Rails 7.2 / PostgreSQL
- Tailwind CSS + DaisyUI (via CDN, theme: `bumblebee`)
- Hotwire: Turbo (page-level, no turbo_stream/turbo_frame) + Stimulus (minimally used)
- Devise (auth) + Resend (email)
- Import maps (no bundler/webpack)

## Database

```
users          id, name, email, magic_points (int, default 0), difficulty (string enum)
task_lists     id, name, user_id
tasks          id, name, completed (bool, default false), task_list_id
```

## Controller Conventions

```ruby
# Always: authenticate first, then set record, then check ownership
before_action :authenticate_user!
before_action :set_task_list, only: %i[show edit update destroy]
before_action :require_ownership, only: %i[show edit update destroy]

# Ownership check pattern
def require_ownership
  redirect_to task_lists_path, alert: "Acesso negado." unless @task_list.user == current_user
end

# Scope records to current_user to prevent unauthorized access
def set_task_list
  @task_list = current_user.task_lists.find(params[:task_list_id])
end

# Strong params: always exclude user_id from create/update
@task_list = current_user.task_lists.new(task_list_params.except(:user_id))

# Redirect after create/update: use home_path (not show)
# Use status: :see_other on PATCH/DELETE redirects
```

## Model Conventions

```ruby
# Associations with dependent: :destroy
has_many :task_lists, dependent: :destroy
has_many :tasks, -> { order(updated_at: :desc) }, dependent: :destroy

# Callbacks: always use conditionals to avoid unnecessary runs
after_update :update_magic_points, if: :saved_change_to_completed?

# Enums: use string values
enum difficulty: { easy: "easy", normal: "normal", hard: "hard" }

# Game constants belong in the model
WEEKLY_DECAY = { easy: 5, normal: 25, hard: 50 }

# Bang methods for immediate point updates
user.increment!(:magic_points, 10)
user.decrement!(:magic_points, 10)
```

## View Conventions

- All user-facing text is in **Portuguese** — do NOT use `t()` i18n keys, write strings directly
- Layout: `application.html.erb` — renders `_header_logged_in` or `_header_logged_out` conditionally
- Forms: use `form_with local: true` (not remote/ajax)
- Partials: pass variables explicitly — `render 'tasks/new_task', task: Task.new, task_list: @task_list`
- Flash: notice = success (alert-success), alert = error (alert-error)
- Task checkbox auto-submits the form: `onchange: 'this.form.submit()'`

## Tailwind/DaisyUI Patterns

```erb
<!-- Cards -->
<div class="card bg-base-100 shadow-xl">
  <div class="card-body">
    <h2 class="card-title">...</h2>
  </div>
</div>

<!-- Buttons -->
<button class="btn btn-primary">Primary</button>
<button class="btn btn-ghost">Ghost</button>
<a class="btn btn-outline btn-error">Delete</a>

<!-- Inputs -->
<input class="input input-bordered" />
<input class="checkbox checkbox-primary" />

<!-- Progress -->
<progress class="progress progress-primary w-full" value="50" max="100"></progress>

<!-- Grid (responsive) -->
<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
```

## Stimulus Conventions

```javascript
export default class extends Controller {
  static targets = ["someTarget"]  // camelCase target names

  connect() {
    // initialization here
  }

  // Private helpers: underscore prefix
  _helperMethod() {}
}
```

## Routes

```ruby
devise_for :users, path: '', path_names: { sign_in: 'login', sign_up: 'signup', sign_out: 'logout' }

root "home#index"
get "home", to: "home#index"
get "village"
get "install"

resource :game_mode, only: [:show, :update]

resources :task_lists do
  resources :tasks  # /task_lists/:task_list_id/tasks/:id
end
```

## Gotchas

- **No Turbo Streams or Turbo Frames** — all forms do full-page redirects
- **No background job runner configured** — `WeeklyMagicPointsDecayJob` exists but needs a scheduler (Sidekiq/cron) to actually run
- **Tailwind is CDN** — no build step, changes in CSS classes work immediately
- **Test suite is mostly stubs** — tests exist but have no assertions implemented yet
- **Home controller** renders different templates based on `user_signed_in?` (single action, two views)
- **Magic points floor is 0** — `[magic_points - decay, 0].max` when applying decay
