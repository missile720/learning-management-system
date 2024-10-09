-- Create the database
CREATE DATABASE learning_model_service_db;

-- Connect to the newly created database
\c learning_model_service_db;

-- Users table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    user_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Courses table
CREATE TABLE Courses (
    course_id SERIAL PRIMARY KEY,
    course_name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    average_completion_rate REAL
);

-- Lessons table
CREATE TABLE Lessons (
    lesson_id SERIAL PRIMARY KEY,
    course_id INTEGER,
    lesson_name TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

CREATE TABLE Sections (
    section_id SERIAL PRIMARY KEY,
    lesson_id INTEGER,
    section_type TEXT NOT NULL, -- e.g., "quiz", "project", "coding_challenge", "text", "video"
    title TEXT NOT NULL,
    content TEXT, -- This could hold text content or links to videos, etc.
    position INTEGER, -- To define the order in which sections appear under the lesson
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lesson_id) REFERENCES Lessons(lesson_id) ON DELETE CASCADE
);

-- Coding_Challenges table (optional addition)
CREATE TABLE Coding_Challenges (
    challenge_id SERIAL PRIMARY KEY,
    section_id INTEGER, -- Links to the section
    problem_name TEXT NOT NULL,
    problem_description TEXT,
    starter_code TEXT,
    expected_output TEXT,
    test_cases TEXT, -- This could hold test cases for the coding problem
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (section_id) REFERENCES Sections(section_id) ON DELETE CASCADE
);

-- Videos table (optional addition)
CREATE TABLE Videos (
    video_id SERIAL PRIMARY KEY,
    section_id INTEGER, -- Links to the section
    video_url TEXT NOT NULL, -- Holds the URL to the video
    title TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (section_id) REFERENCES Sections(section_id) ON DELETE CASCADE
);

-- Quizzes table
CREATE TABLE Quizzes (
    quiz_id SERIAL PRIMARY KEY,
    section_id INTEGER,
    quiz_name TEXT NOT NULL,
    total_score REAL NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (section_id) REFERENCES Sections(section_id) ON DELETE CASCADE
);

-- Quiz_Questions table
CREATE TABLE Quiz_Questions (
    question_id SERIAL PRIMARY KEY,
    quiz_id INTEGER,
    question_text TEXT NOT NULL,
    question_type TEXT NOT NULL,
    expected_output TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (quiz_id) REFERENCES Quizzes(quiz_id) ON DELETE CASCADE
);

-- Quiz_Results table
CREATE TABLE Quiz_Results (
    result_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    quiz_id INTEGER,
    score REAL NOT NULL,
    total_score REAL NOT NULL,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    feedback TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (quiz_id) REFERENCES Quizzes(quiz_id) ON DELETE CASCADE
);

-- Quiz_Answers table
CREATE TABLE Quiz_Answers (
    answer_id SERIAL PRIMARY KEY,
    result_id INTEGER,
    question_id INTEGER,
    answer_text TEXT,
    is_correct BOOLEAN NOT NULL,
    FOREIGN KEY (result_id) REFERENCES Quiz_Results(result_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES Quiz_Questions(question_id) ON DELETE CASCADE
);

-- Lesson_Progress table
CREATE TABLE Lesson_Progress (
    progress_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    course_id INTEGER,
    lesson_id INTEGER,
    time_spent INTEGER,
    status TEXT,
    last_accessed TIMESTAMP,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES Lessons(lesson_id) ON DELETE CASCADE
);

-- Lesson_Analytics table
CREATE TABLE Lesson_Analytics (
    analytics_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    lesson_id INTEGER,
    time_spent INTEGER,
    number_of_visits INTEGER,
    completed BOOLEAN,
    started_at TIMESTAMP,
    last_accessed TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (lesson_id) REFERENCES Lessons(lesson_id)
);

-- Course_Analytics table
CREATE TABLE Course_Analytics (
    analytics_id SERIAL PRIMARY KEY,
    course_id INTEGER,
    user_id INTEGER,
    lessons_completed INTEGER,
    total_time_spent INTEGER,
    average_quiz_score REAL,
    progress REAL,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Course_Instructors table
CREATE TABLE Course_Instructors (
    course_instructor_id SERIAL PRIMARY KEY,
    course_id INTEGER,
    instructor_id INTEGER,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (instructor_id) REFERENCES Users(user_id)
);

-- Course_TAs table
CREATE TABLE Course_TAs (
    course_ta_id SERIAL PRIMARY KEY,
    course_id INTEGER,
    ta_id INTEGER,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (ta_id) REFERENCES Users(user_id)
);

-- Projects table
CREATE TABLE Projects (
    project_id SERIAL PRIMARY KEY,
    section_id INTEGER,
    title TEXT NOT NULL,
    description TEXT,
    due_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    instructor_id INTEGER,
    status TEXT,
    FOREIGN KEY (section_id) REFERENCES Sections(section_id) ON DELETE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES Users(user_id)
);

-- Project_Results table
CREATE TABLE Project_Results (
    result_id SERIAL PRIMARY KEY,
    project_id INTEGER,
    user_id INTEGER,
    score REAL,
    total_score REAL,
    completed_at TIMESTAMP,
    feedback TEXT,
    FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Uncomment to drop the database (use with caution)
--  DROP DATABASE eats_in_reach_db;