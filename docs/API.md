# Initial API Contract

All routes are prefixed with `/api/v1`.

## Health

- `GET /health` — service and database readiness

## Authentication

- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/refresh`
- `POST /auth/logout`
- `GET /users/me`

## Materials

- `POST /materials` — upload a material
- `GET /materials` — list the signed-in user's materials
- `GET /materials/:id`
- `DELETE /materials/:id`
- `POST /materials/:id/process`

## Reviewers

- `GET /materials/:materialId/reviewer`
- `POST /materials/:materialId/reviewer/generate`

## Flashcards

- `GET /materials/:materialId/flashcard-decks`
- `POST /materials/:materialId/flashcard-decks/generate`
- `PATCH /flashcards/:id/progress`

## Quizzes

- `POST /materials/:materialId/quizzes/generate`
- `GET /quizzes/:id`
- `POST /quizzes/:id/attempts`
- `GET /quiz-attempts/:id/results`

## Document chat

- `POST /materials/:materialId/chat-sessions`
- `POST /chat-sessions/:id/messages`
- `GET /chat-sessions/:id/messages`

The detailed request/response schemas will be generated from NestJS DTOs in
Swagger when each module is implemented.
