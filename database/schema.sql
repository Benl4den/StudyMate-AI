-- StudyMate development schema
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS studymate_dev
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE studymate_dev;

CREATE TABLE users (
  id CHAR(36) NOT NULL,
  email VARCHAR(254) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB;

CREATE TABLE refresh_tokens (
  id CHAR(36) NOT NULL,
  user_id CHAR(36) NOT NULL,
  token_hash CHAR(64) NOT NULL,
  expires_at DATETIME(6) NOT NULL,
  revoked_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_refresh_tokens_hash (token_hash),
  KEY idx_refresh_tokens_user (user_id),
  CONSTRAINT fk_refresh_tokens_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE materials (
  id CHAR(36) NOT NULL,
  user_id CHAR(36) NOT NULL,
  title VARCHAR(255) NOT NULL,
  original_filename VARCHAR(255) NOT NULL,
  mime_type VARCHAR(100) NOT NULL,
  size_bytes BIGINT UNSIGNED NOT NULL,
  storage_key VARCHAR(500) NOT NULL,
  status ENUM('UPLOADED', 'PROCESSING', 'READY', 'FAILED')
    NOT NULL DEFAULT 'UPLOADED',
  failure_reason VARCHAR(1000) NULL,
  processed_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_materials_user_created (user_id, created_at),
  KEY idx_materials_status (status),
  CONSTRAINT fk_materials_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE material_chunks (
  id CHAR(36) NOT NULL,
  material_id CHAR(36) NOT NULL,
  chunk_index INT UNSIGNED NOT NULL,
  content MEDIUMTEXT NOT NULL,
  source_label VARCHAR(255) NULL,
  source_page INT UNSIGNED NULL,
  embedding_ref VARCHAR(255) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_material_chunks_order (material_id, chunk_index),
  CONSTRAINT fk_material_chunks_material FOREIGN KEY (material_id)
    REFERENCES materials (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE reviewers (
  id CHAR(36) NOT NULL,
  material_id CHAR(36) NOT NULL,
  summary MEDIUMTEXT NOT NULL,
  simplified_explanation MEDIUMTEXT NULL,
  key_concepts JSON NOT NULL,
  definitions JSON NOT NULL,
  formulas JSON NULL,
  frequently_asked_questions JSON NULL,
  model_name VARCHAR(100) NULL,
  prompt_version VARCHAR(50) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_reviewers_material (material_id),
  CONSTRAINT fk_reviewers_material FOREIGN KEY (material_id)
    REFERENCES materials (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE flashcard_decks (
  id CHAR(36) NOT NULL,
  material_id CHAR(36) NOT NULL,
  title VARCHAR(255) NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_flashcard_decks_material (material_id),
  CONSTRAINT fk_flashcard_decks_material FOREIGN KEY (material_id)
    REFERENCES materials (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE flashcards (
  id CHAR(36) NOT NULL,
  deck_id CHAR(36) NOT NULL,
  front TEXT NOT NULL,
  back TEXT NOT NULL,
  topic VARCHAR(255) NULL,
  card_order INT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_flashcards_deck_order (deck_id, card_order),
  CONSTRAINT fk_flashcards_deck FOREIGN KEY (deck_id)
    REFERENCES flashcard_decks (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE flashcard_progress (
  id CHAR(36) NOT NULL,
  user_id CHAR(36) NOT NULL,
  flashcard_id CHAR(36) NOT NULL,
  rating ENUM('EASY', 'DIFFICULT') NULL,
  is_bookmarked BOOLEAN NOT NULL DEFAULT FALSE,
  review_count INT UNSIGNED NOT NULL DEFAULT 0,
  last_reviewed_at DATETIME(6) NULL,
  next_review_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_flashcard_progress_user_card (user_id, flashcard_id),
  KEY idx_flashcard_progress_due (user_id, next_review_at),
  CONSTRAINT fk_flashcard_progress_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT fk_flashcard_progress_card FOREIGN KEY (flashcard_id)
    REFERENCES flashcards (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE quizzes (
  id CHAR(36) NOT NULL,
  material_id CHAR(36) NOT NULL,
  title VARCHAR(255) NOT NULL,
  difficulty ENUM('EASY', 'MEDIUM', 'HARD') NOT NULL DEFAULT 'MEDIUM',
  time_limit_minutes SMALLINT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_quizzes_material (material_id),
  CONSTRAINT fk_quizzes_material FOREIGN KEY (material_id)
    REFERENCES materials (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE quiz_questions (
  id CHAR(36) NOT NULL,
  quiz_id CHAR(36) NOT NULL,
  question_text TEXT NOT NULL,
  question_type ENUM('MULTIPLE_CHOICE') NOT NULL DEFAULT 'MULTIPLE_CHOICE',
  choices JSON NOT NULL,
  correct_answer VARCHAR(500) NOT NULL,
  explanation TEXT NOT NULL,
  topic VARCHAR(255) NULL,
  question_order INT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_quiz_questions_order (quiz_id, question_order),
  CONSTRAINT fk_quiz_questions_quiz FOREIGN KEY (quiz_id)
    REFERENCES quizzes (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE quiz_attempts (
  id CHAR(36) NOT NULL,
  quiz_id CHAR(36) NOT NULL,
  user_id CHAR(36) NOT NULL,
  score DECIMAL(5,2) NULL,
  started_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  submitted_at DATETIME(6) NULL,
  PRIMARY KEY (id),
  KEY idx_quiz_attempts_user_submitted (user_id, submitted_at),
  CONSTRAINT fk_quiz_attempts_quiz FOREIGN KEY (quiz_id)
    REFERENCES quizzes (id) ON DELETE CASCADE,
  CONSTRAINT fk_quiz_attempts_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE quiz_answers (
  id CHAR(36) NOT NULL,
  attempt_id CHAR(36) NOT NULL,
  question_id CHAR(36) NOT NULL,
  selected_answer VARCHAR(500) NULL,
  is_correct BOOLEAN NOT NULL,
  answered_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_quiz_answers_attempt_question (attempt_id, question_id),
  CONSTRAINT fk_quiz_answers_attempt FOREIGN KEY (attempt_id)
    REFERENCES quiz_attempts (id) ON DELETE CASCADE,
  CONSTRAINT fk_quiz_answers_question FOREIGN KEY (question_id)
    REFERENCES quiz_questions (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE chat_sessions (
  id CHAR(36) NOT NULL,
  material_id CHAR(36) NOT NULL,
  user_id CHAR(36) NOT NULL,
  title VARCHAR(255) NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_chat_sessions_user (user_id, updated_at),
  CONSTRAINT fk_chat_sessions_material FOREIGN KEY (material_id)
    REFERENCES materials (id) ON DELETE CASCADE,
  CONSTRAINT fk_chat_sessions_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE chat_messages (
  id CHAR(36) NOT NULL,
  session_id CHAR(36) NOT NULL,
  role ENUM('USER', 'ASSISTANT') NOT NULL,
  content MEDIUMTEXT NOT NULL,
  citations JSON NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_chat_messages_session_created (session_id, created_at),
  CONSTRAINT fk_chat_messages_session FOREIGN KEY (session_id)
    REFERENCES chat_sessions (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE recommendations (
  id CHAR(36) NOT NULL,
  user_id CHAR(36) NOT NULL,
  material_id CHAR(36) NULL,
  recommendation_type ENUM('WEAK_TOPIC', 'FLASHCARDS_DUE', 'STUDY_REMINDER')
    NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  metadata JSON NULL,
  is_dismissed BOOLEAN NOT NULL DEFAULT FALSE,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_recommendations_user_active (user_id, is_dismissed, created_at),
  CONSTRAINT fk_recommendations_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT fk_recommendations_material FOREIGN KEY (material_id)
    REFERENCES materials (id) ON DELETE SET NULL
) ENGINE=InnoDB;
