# Software Design Document

## Architecture

StudyMate starts as a modular monolith: one Flutter client, one NestJS API, and
one MySQL database. This is simpler to develop and deploy while preserving clear
module boundaries for future workers and vector storage.

```text
Flutter client
    |
    | HTTPS / JSON
    v
NestJS API
    |-- Auth module
    |-- Users module
    |-- Materials module
    |-- Reviewers module
    |-- Flashcards module
    |-- Quizzes module
    |-- Chat module
    |-- Recommendations module
    |
    +--> MySQL (application records)
    +--> local storage in development / object storage in production
    +--> AI provider through a backend-only adapter
```

## Important design decisions

### Backend-only AI access

The Flutter application never calls an AI provider directly. The NestJS API
owns API credentials, prompt templates, validation, rate limits, audit metadata,
and provider switching.

### Asynchronous document processing

Uploading and processing are separate operations. A material has a status such
as `UPLOADED`, `PROCESSING`, `READY`, or `FAILED`. The MVP may process small
files in-process; BullMQ/Redis is introduced before production workloads.

### Grounded answers

Document chat retrieves relevant chunks from the selected material and sends
only those chunks as evidence. Each answer should return source references. If
evidence is inadequate, the assistant must say so.

### Data ownership

Every user-owned record includes `user_id` directly or derives ownership through
a parent record. Backend authorization checks ownership; client-side hiding is
not considered security.

## Initial data model

- `users`: account and profile
- `materials`: uploaded file metadata and processing state
- `material_chunks`: extracted text chunks and source locations
- `reviewers`: generated summaries and structured concepts
- `flashcard_decks`, `flashcards`, `flashcard_progress`
- `quizzes`, `quiz_questions`, `quiz_attempts`, `quiz_answers`
- `chat_sessions`, `chat_messages`
- `study_activities`, `recommendations`

## API conventions

- Prefix routes with `/api/v1`.
- Return consistent JSON error objects.
- Validate all request DTOs.
- Generate Swagger/OpenAPI documentation from the API.
- Use UTC timestamps in storage and ISO 8601 in responses.
- Paginate list endpoints.

## Quality gates

- Backend unit tests for business rules and authorization
- Backend integration tests for database/API flows
- Flutter unit tests for state and models
- Flutter widget tests for critical screens
- Linting and formatting in both projects
- Manual smoke test: login, upload, reviewer, quiz, and document chat
