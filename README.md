# Student Database Insertion Script

This project is part of the FreeCodeCamp - Relational Database Certification.  

## Task
Create a Bash script designed to automate the insertion of data from two CSV files (`courses.csv` and `students.csv`) into a PostgreSQL database named `students`.  
The script performs various checks and inserts to ensure that the data is correctly populated in the database.

## Prerequisites

Before running the script, ensure that you have the following:

- PostgreSQL installed and running.
- The `students` database created with the necessary tables (`students`, `majors`, `courses`, `majors_courses`).
- The `courses.csv` and `students.csv` files containing the data to be inserted.
- The `freecodecamp` PostgreSQL user has the necessary permissions to perform inserts into the database.

## Database Schema

The script assumes the following database schema:

### Tables

1. **majors**
    - `major_id`: Serial primary key.
    - `major`: Text, unique.

2. **courses**
    - `course_id`: Serial primary key.
    - `course`: Text, unique.

3. **students**
    - `student_id`: Serial primary key.
    - `first_name`: Text.
    - `last_name`: Text.
    - `major_id`: Integer, foreign key referencing `majors(major_id)`.
    - `gpa`: Numeric.

4. **majors_courses**
    - `major_id`: Integer, foreign key referencing `majors(major_id)`.
    - `course_id`: Integer, foreign key referencing `courses(course_id)`.


## CSV File Formats

### `courses.csv`

```csv
major,course
Computer Science,Algorithms
Mathematics,Calculus
```
### `students.csv`
```csv
first_name,last_name,major,gpa
John,Doe,Computer Science,3.5
Jane,Smith,Mathematics,3.8
```


## Script Overview

The script performs the following tasks:

1. **Truncate existing data**: Clears the `students`, `majors`, `courses`, and `majors_courses` tables to prevent duplicate entries.

2. **Insert data from `courses.csv`**:
    - Reads each line from the `courses.csv` file.
    - Inserts new majors and courses into the `majors` and `courses` tables if they do not already exist.
    - Inserts the corresponding `major_id` and `course_id` into the `majors_courses` table.

3. **Insert data from `students.csv`**:
    - Reads each line from the `students.csv` file.
    - Retrieves the `major_id` for each student.
    - Inserts the student data into the `students` table.

## Usage

1. Ensure the PostgreSQL server is running.
2. Place the `courses.csv` and `students.csv` files in the same directory as the script.
3. Run the script using the following command:
    ```bash
    ./script_name.sh
    ```


