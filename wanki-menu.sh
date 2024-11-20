#!/bin/bash

# Create base directory 
BASE_DIR="$HOME/WANKI"
mkdir -p "$HOME/WANKI"

main_menu(){
    echo "Welcome to WANKI!"
    echo "Select a course or add a new one:"

    ## List current courses
    local i=1
    courses=()

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
    read -p "Enter choice: " choice

    if (( choice == i )); then
        create_course
    elif (( choice == i+1)); then
        remove_course
    elif (( choice == i+2)); then
        exit 0
    elif (( choice >= 1 && choice < i )); then
        selected_course="${courses[$choice]}"
        course_menu "$selected_course"
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
