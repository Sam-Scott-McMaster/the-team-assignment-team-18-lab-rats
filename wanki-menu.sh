#!/bin/bash

# Create base directory in user's home if it doesn't exist already
BASE_DIR="$HOME/WANKI"
mkdir -p "$BASE_DIR"

main_menu(){
    echo "-----------------"
    echo "Welcome to WANKI!"
    echo "-----------------"
    echo "Select an option:"

    # General options
    echo "(1) Add new course"
    echo "(2) Remove a course"

    # List all courses in WANKI directory
    local i=3
    courses=()

    for course_dir in "$BASE_DIR"/*/; do
        if [ -d "$course_dir" ]; then
            course_name=$(basename "$course_dir")
            echo "($i) $course_name"
            courses[$i]="$course_name"
            ((i++))
        fi
    done

    # Exit option
    echo "($i) Exit"

    # Prompt user for choice
    read -p "Enter your choice: " choice

    # Call appropriate function based on user's selection
    if (( choice == 1 )); then
        create_course
    elif (( choice == 2 )); then
        remove_course
    elif (( choice == i )); then
        echo "Exiting..."
        exit 0
    elif (( choice >= 3 && choice < i )); then
        selected_course="${courses[$choice]}"
    else
        echo "Invalid option. Returning to main menu."
    fi
}

# Function to create a new course
create_course() {
    read -p "Enter the new course name: " course_name
    course_dir="$BASE_DIR/$course_name"
    
    if [ -d "$course_dir" ]; then
        echo "Course '$course_name' already exists."
    else
        mkdir -p "$course_dir"
        echo "Course '$course_name' created."
    fi
}

# Function to remove a course
remove_course() {
    echo "Select a course to remove:"

    local i=1
    courses=()

    # List courses
    for course_dir in "$BASE_DIR"/*/; do
        if [ -d "$course_dir" ]; then
            course_name=$(basename "$course_dir")
            echo "($i) $course_name"
            courses[$i]="$course_name"
            ((i++))
        fi
    done

    # Check if no courses exist
    if (( i == 1 )); then
        echo "No courses available to remove."
        return
    fi

    # Prompt for removal
    read -p "Enter the number of the course to remove: " choice
    if (( choice >= 1 && choice < i )); then
        selected_course="${courses[$choice]}"
        course_dir="$BASE_DIR/$selected_course"
        
        read -p "Are you sure you want to remove '$selected_course'? (y/n): " confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            rm -rf "$course_dir"
            echo "Course '$selected_course' has been removed."
        else
            echo "Removal canceled."
        fi
    else
        echo "Invalid choice. Returning to main menu."
    fi
}

# Run the main menu in a loop
while true; do
    main_menu
done


