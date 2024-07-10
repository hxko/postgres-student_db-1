#!/bin/bash

# Script to insert data from courses.csv and students.csv into students database

# Define the PSQL variable to simplify the psql command usage
PSQL="psql -X --username=freecodecamp --dbname=students --no-align --tuples-only -c"

# Truncate existing data in all tables to start fresh
echo $($PSQL "TRUNCATE students, majors, courses, majors_courses")

# Read through the courses.csv file line by line
cat courses.csv | while IFS="," read MAJOR COURSE
do
  # Skip the header line
  if [[ $MAJOR != "major" ]]
  then
    # Get the major_id from the majors table
    MAJOR_ID=$($PSQL "SELECT major_id FROM majors WHERE major='$MAJOR'")

    # If the major is not found in the majors table
    if [[ -z $MAJOR_ID ]]
    then
      # Insert the new major into the majors table
      INSERT_MAJOR_RESULT=$($PSQL "INSERT INTO majors(major) VALUES('$MAJOR')")
      if [[ $INSERT_MAJOR_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into majors: $MAJOR"
      fi

      # Retrieve the new major_id after insertion
      MAJOR_ID=$($PSQL "SELECT major_id FROM majors WHERE major='$MAJOR'")
    fi

    # Get the course_id from the courses table
    COURSE_ID=$($PSQL "SELECT course_id FROM courses WHERE course='$COURSE'")

    # If the course is not found in the courses table
    if [[ -z $COURSE_ID ]]
    then
      # Insert the new course into the courses table
      INSERT_COURSE_RESULT=$($PSQL "INSERT INTO courses(course) VALUES('$COURSE')")
      if [[ $INSERT_COURSE_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into courses: $COURSE"
      fi

      # Retrieve the new course_id after insertion
      COURSE_ID=$($PSQL "SELECT course_id FROM courses WHERE course='$COURSE'")
    fi

    # Insert the major_id and course_id into the majors_courses table
    INSERT_MAJORS_COURSES_RESULT=$($PSQL "INSERT INTO majors_courses(major_id, course_id) VALUES($MAJOR_ID, $COURSE_ID)")
    if [[ $INSERT_MAJORS_COURSES_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted into majors_courses: $MAJOR : $COURSE"
    fi
  fi
done

# Read through the students.csv file line by line
cat students.csv | while IFS="," read FIRST LAST MAJOR GPA
do
  # Skip the header line
  if [[ $FIRST != first_name ]]
  then
    # Get the major_id from the majors table
    MAJOR_ID=$($PSQL "SELECT major_id FROM majors WHERE major='$MAJOR'")

    # If the major is not found, set MAJOR_ID to null
    if [[ -z $MAJOR_ID ]]
    then
      MAJOR_ID=null
    fi

    # Insert the student data into the students table
    INSERT_STUDENT_RESULT=$($PSQL "INSERT INTO students(first_name, last_name, major_id, gpa) VALUES('$FIRST','$LAST', $MAJOR_ID, $GPA)")
    if [[ $INSERT_STUDENT_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted into students: $FIRST $LAST"
    fi
  fi
done
