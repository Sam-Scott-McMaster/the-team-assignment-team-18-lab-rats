#!/bin/bash

# Create base directory if doesn't exist already
BASE_DIR="$HOME/WANKI"
mkdir -p "$HOME/WANKI"

main_menu(){
    echo
    echo "Welcome to WANKI!"
    echo "Select a course or add a new one:"

    local i=1
    courses=()

    # List current courses
    for course_dir in "$BASE_DIR"/*/; do
        course_name=$(basename "$course_dir")
        echo "($i) $course_name"
        courses[$i]=$course_name
        ((i++))
    done

    # Option to add new course
    echo "($i) Add new course"
    echo "($((i+1))) Remove a course"
    echo "($((i+2))) Exit"

    ((i--))
    read -p "Enter choice: " choice


    # Call appropriate function based on user's selection
    # if (( choice == i )); then
    #     selected_course="${courses[$choice]}"
    #     navigate_courses "$selected_course"
    
    if (( choice == i + 1 )); then
        create_course
    elif (( choice == i+2)); then
        remove_course
    elif (( choice == i+3)); then
        exit 0
    elif (( choice >= 1 && choice <= i )); then
        selected_course="${courses[$choice]}"
        
        #navigate_courses "$selected_course"
        course_menu "$selected_course"
    else
        echo "Invalid option. Returning to main menu."
    fi
}

course_menu() {
    echo ""
    echo "You are in course: $1. What would you like to do?"
    echo "(1) Add cards"
    echo "(2) Remove cards"
    echo "(3) Start deck"
    echo "(4) Exit"
    read -p "Enter choice: " choice
    if (( choice == 1 )); then
        add $1
    elif (( choice == 2)); then
        remove $1
    elif (( choice == 3)); then
        navigate_courses $1
    elif (( choice == 4)); then
        echo "Returning to main menu."
    else
        echo "Invalid option. Returning to main menu."
    fi
}

navigate_courses() {
    ls $BASE_DIR
    ./showcards $1
}

# Function to create a new course
create_course() {
    read -p "Enter the new course name: " course_name
    course_dir="$BASE_DIR/$course_name"
    
    if [ -d "$course_dir" ]; then
        echo "Course '$course_name' already exists."
    else
        mkdir -p "$course_dir"
        touch $course_dir/flashcards.txt $course_dir/easy_flashcards.txt $course_dir/good_flashcards.txt $course_dir/hard_flashcards.txt $course_dir/again_flashcards.txt
        echo "Course '$course_name' created."
    fi
}

# Function to remove course
remove_course() {
    echo "Select a course to remove:"

    local i=1
    courses=()

    for course_dir in "$BASE_DIR"/*/; do
        if [ -d "$course_dir" ]; then
            course_name=$(basename "$course_dir")
            echo "($i) $course_name"
            courses[$i]="$course_name"
            ((i++))
        fi
    done

    if (( i == 1 )); then
        echo "No courses available to remove."
        return
    fi

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

while true; do
    main_menu
done