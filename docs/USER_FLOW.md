# MVP User Flow

```text
Open app
  -> Register or sign in
  -> Dashboard
      -> Upload PDF/TXT
      -> Wait for processing
      -> Open material
          -> Read reviewer
          -> Study flashcards
          -> Take quiz
          -> Ask document questions
      -> Return to dashboard
          -> See score, weak topics, and recommendation
```

## Required screen states

Each network-driven screen must support:

- loading
- success
- empty data
- validation error
- server/network error with retry

## Upload flow

1. Student chooses a PDF or TXT file.
2. Client shows file name and size for confirmation.
3. Backend validates authentication, file type, size, and ownership.
4. Backend stores metadata and returns a material ID and status.
5. Processing extracts text and creates study content.
6. Client polls status initially; real-time updates can be added later.
7. Failed processing shows a clear error and retry action.
