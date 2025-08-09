# Task Management API (Rails 8, API-only) 🚀

Secure, JSON-only Rails 8 API with JWT auth and PostgreSQL.

## 🔐 Auth

- POST /register — create an account and receive a JWT
- POST /login — authenticate and receive a JWT
- Authorization — send token on protected endpoints with `Authorization: Bearer <JWT>`

### curl: Register
```bash
curl -X POST http://localhost:3000/register \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "name": "Demo User",
      "email": "demo@example.com",
      "password": "password",
      "password_confirmation": "password"
    }
  }'
```

### curl: Login
```bash
curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "demo@example.com",
    "password": "password"
  }'
```

Response includes `{ token, user }`. Use the token below.

## 👤 Profile

- GET /me — current user profile

### curl: Me
```bash
curl -X GET http://localhost:3000/me \
  -H "Authorization: Bearer <JWT>"
```

## ✅ Tasks (scoped by user)

- GET    /users/:user_id/tasks
- POST   /users/:user_id/tasks { task: { title, description, status, due_date } }
- GET    /users/:user_id/tasks/:id
- PATCH  /users/:user_id/tasks/:id { task: { ... } }
- PUT    /users/:user_id/tasks/:id { task: { ... } }
- DELETE /users/:user_id/tasks/:id

Status enum: `pending`, `in_progress`, `done`

### curl: List Tasks
```bash
curl -X GET http://localhost:3000/users/<USER_ID>/tasks \
  -H "Authorization: Bearer <JWT>"
```

### curl: Create Task
```bash
curl -X POST http://localhost:3000/users/<USER_ID>/tasks \
  -H "Authorization: Bearer <JWT>" \
  -H "Content-Type: application/json" \
  -d '{
    "task": {
      "title": "New Task",
      "description": "Created via curl",
      "status": "pending",
      "due_date": "2025-08-15"
    }
  }'
```

### curl: Show Task
```bash
curl -X GET http://localhost:3000/users/<USER_ID>/tasks/<TASK_ID> \
  -H "Authorization: Bearer <JWT>"
```

### curl: Update Task (PATCH)
```bash
curl -X PATCH http://localhost:3000/users/<USER_ID>/tasks/<TASK_ID> \
  -H "Authorization: Bearer <JWT>" \
  -H "Content-Type: application/json" \
  -d '{
    "task": { "status": "in_progress" }
  }'
```

### curl: Replace Task (PUT)
```bash
curl -X PUT http://localhost:3000/users/<USER_ID>/tasks/<TASK_ID> \
  -H "Authorization: Bearer <JWT>" \
  -H "Content-Type: application/json" \
  -d '{
    "task": {
      "title": "Replaced Title",
      "description": "Fully replaced",
      "status": "done",
      "due_date": "2025-08-20"
    }
  }'
```

### curl: Delete Task
```bash
curl -X DELETE http://localhost:3000/users/<USER_ID>/tasks/<TASK_ID> \
  -H "Authorization: Bearer <JWT>"
```

## 🧪 Seeds & Fixtures
- 🌱 `bin/rails db:seed` creates `demo@example.com / password` and 3 tasks
- 📦 Load fixtures into development for quick testing:
  - All: `bundle exec rails db:fixtures:load RAILS_ENV=development`
  - Specific: `bundle exec rails db:fixtures:load FIXTURES=users,tasks RAILS_ENV=development`

## 🧰 Bruno collection
- Import folder `bruno/TaskAPI` (or use root-level `bruno/*.bru`)
- Run: Register/Login → Me → Tasks CRUD
- JWT is captured automatically in the provided Bruno scripts

## ⚙️ Env
- Set `JWT_SECRET` in environment (fallback to credentials or secret_key_base)

## ❗️ Errors
- 401 Unauthorized — `{ error }`
- 403 Forbidden — `{ error }`
- 404 Not Found — `{ error, message }`
- 422 Validation Failed — `{ error, details: [] }`
