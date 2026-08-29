# StudyMate

StudyMate is an AI-powered learning companion that turns student learning
materials into summaries, reviewers, flashcards, quizzes, document-based chat,
and personalized study recommendations.

## Project status

The project is in its foundation phase. The first release will focus on a small,
testable MVP before adding voice tutoring, OCR-heavy workflows, and automatic
schedule extraction.

## MVP scope

The first usable version will let a student:

1. Create an account and sign in.
2. Upload a PDF or TXT learning material.
3. Generate and view a summary and key concepts.
4. Generate flashcards and mark cards as easy or difficult.
5. Generate a multiple-choice quiz and receive a score with explanations.
6. Ask questions whose answers are grounded in the uploaded material.
7. View study activity and weak topics on a dashboard.

Voice tutoring, handwritten-note OCR, schedule import, spaced repetition, and
resume/thesis simulations will follow after the MVP is stable.

## Planned stack

- Mobile/web client: Flutter, Dart, Riverpod, Dio, GoRouter
- API: Node.js, NestJS, TypeScript, TypeORM, Swagger
- Database: MySQL
- Later infrastructure: Redis, BullMQ, Qdrant, object storage
- AI services: LLM, embeddings, OCR, speech-to-text, text-to-speech

## Repository structure

```text
StudyMate AI/
├── frontend/       Flutter application
├── backend/        NestJS API
├── database/       Schema, seeds, migrations, and ERD
├── docs/           Architecture, API, roadmap, and user flows
├── assets/         Brand assets and mockups
└── scripts/        Development helper scripts
```

## Start here

1. Follow [docs/SETUP.md](docs/SETUP.md) to install and verify the toolchain.
2. Review [docs/ROADMAP.md](docs/ROADMAP.md) for the development order.
3. Review [docs/SDD.md](docs/SDD.md) before making architecture changes.
4. Never commit `.env` files or API keys.

## Development commands

These commands will work after the frontend and backend are scaffolded:

```bash
# Terminal 1
cd frontend
flutter run

# Terminal 2
cd backend
npm run start:dev
```

## Author

Erwin Klith Dingcong
