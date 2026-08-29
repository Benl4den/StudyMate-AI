# Product Roadmap

## Phase 0 — Foundation

Exit criteria:

- Repository structure and documentation are committed.
- Node.js, Flutter, and MySQL are installed and verified.
- Flutter and NestJS applications start locally.
- Environment examples and health-check endpoint exist.

## Phase 1 — Accounts and library

Build:

- Email/password registration and login
- Password hashing and JWT access/refresh tokens
- Profile screen
- Material library
- PDF and TXT upload with type and size validation
- Private ownership checks on every material endpoint

Exit criteria: a signed-in student can upload, list, open, and delete only their
own materials.

## Phase 2 — AI reviewer

Build:

- Text extraction from PDF and TXT
- Background processing status
- Summary, key concepts, definitions, and simplified explanation
- Persisted generated output
- Retry and failure states

Exit criteria: an uploaded material reliably produces a saved reviewer with
traceable processing status.

## Phase 3 — Flashcards and quizzes

Build:

- AI-generated flashcard decks
- Easy/difficult status and bookmarks
- Multiple-choice quiz generation
- Quiz attempts, scores, explanations, and weak-topic calculation

Exit criteria: quiz answers are graded deterministically and the dashboard can
display weak topics from saved attempts.

## Phase 4 — Grounded document chat

Build:

- Chunking and embeddings
- Vector search
- Answers restricted to the selected document
- Source citations and an explicit insufficient-context response

Exit criteria: test questions return relevant cited passages and do not claim
unsupported facts from outside the material.

## Phase 5 — Dashboard and recommendations

Build:

- Recent materials and study activity
- Quiz performance and weak topics
- Flashcards due
- Rule-based recommendations first, AI-written phrasing second

## Phase 6 — Advanced capabilities

- Spaced repetition scheduling
- OCR for images and handwritten notes
- Schedule extraction with confirmation before save
- Voice oral exam, resume interview, and thesis defense modes
- Redis/BullMQ workers, Qdrant, and object storage for production scale

## Delivery rhythm

For every feature:

1. Define the user-visible acceptance criteria.
2. Add/update database migration and API contract.
3. Implement backend validation, authorization, and tests.
4. Implement loading, success, empty, and error states in Flutter.
5. Run automated tests and manually exercise the full flow.
6. Commit one coherent change with no secrets.
