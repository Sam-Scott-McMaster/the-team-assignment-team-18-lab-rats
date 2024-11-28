#!/bin/bash

# Define the files for each difficulty level
FILES=("flashcards.txt" "again_flashcards.txt" "hard_flashcards.txt" "good_flashcards.txt" "easy_flashcards.txt")
DIFFICULTIES=("easy" "hard" "again" "good")

# Function to display all cards with global line numbers
display_cards() {
    echo '-=-=-=-=- CARD LIST -=-=-=-=-'
    local global_line=1  # Start global numbering

    # Loop through each file and display the cards with global line numbers
    for file in "${FILES[@]}"; do
        if [[ -f "$file" ]]; then
            echo "Deck: $file"
            while IFS= read -r line; do
                echo "$global_line: $line"
                global_line=$((global_line + 1))  # Increment global line count
            done < "$file"
        fi
        echo ""
    done
    echo ""
}

# Function to get the file and local line for a global line number
get_file_and_local_line() {
    local target_global_line=$1
    local global_line=1

    # Check each file
    for file in "${FILES[@]}"; do
        if [[ -f "$file" ]]; then
            local line_count=$(wc -l < "$file")  # Count total lines in this file

            # Check if the global line is in this file
            if (( target_global_line >= global_line && target_global_line < global_line + line_count )); then
                local local_line=$((target_global_line - global_line + 1))  # Calculate local line number
                echo "$file:$local_line"
                return
            fi

            # Update global line for the next file
            global_line=$((global_line + line_count))
        fi
    done

    # If no matching line is found
    echo "ERROR: Line $target_global_line not found."
}

# Function to edit a specific flashcard
edit_flashcard() {
    local global_line=$1

    # Find the file and local line for the global line number
    local file_and_local_line
    file_and_local_line=$(get_file_and_local_line "$global_line")
    if [[ "$file_and_local_line" == ERROR* ]]; then
        echo "$file_and_local_line"
        return
    fi

    # Extract file name and local line number
    local file=${file_and_local_line%%:*}
    local local_line=${file_and_local_line##*:}

    # Get the current content of the line
    local current_line=$(sed -n "${local_line}p" "$file")
    echo "Deck: $file"
    echo "Current Line: $current_line"

    # Prompt user for what to edit
    echo "What would you like to edit? (question/answer/both)"
    read -r edit_choice

    # Edit the question
    if [[ "$edit_choice" == "question" ]]; then
        echo "Type the new question:"
        read -r new_question
        local new_line="${new_question} | ${current_line#*| }"
        sed -i "${local_line}s/.*/${new_line}/" "$file"
        echo "Question updated successfully in $file."

    # Edit the answer
    elif [[ "$edit_choice" == "answer" ]]; then
        echo "Type the new answer:"
        read -r new_answer
        local new_line="${current_line%| *} | ${new_answer}"
        sed -i "${local_line}s/.*/${new_line}/" "$file"
        echo "Answer updated successfully in $file."

    # Edit both the question and answer
    elif [[ "$edit_choice" == "both" ]]; then
        echo "Type the new question:"
        read -r new_question
        echo "Type the new answer:"
        read -r new_answer
        local new_line="${new_question} | ${new_answer}"
        sed -i "${local_line}s/.*/${new_line}/" "$file"
        echo "Card updated successfully in $file."

    # Handle invalid input
    else
        echo "Invalid choice. No changes made."
        return
    fi

    # Prompt to change the difficulty of the card
    echo "Select the new difficulty for this card: (easy/hard/again/good)"
    read -r new_difficulty

    # Check if the input is valid
    if [[ ! " ${DIFFICULTIES[@]} " =~ " ${new_difficulty} " ]]; then
        echo "Invalid difficulty selected. No changes made."
        return
    fi

    # Remove the card from the current file
    sed -i "${local_line}d" "$file"

    # Append the card to the appropriate difficulty file
    local new_file="${new_difficulty}_flashcards.txt"
    echo "$new_line" >> "$new_file"
    echo "Card moved to $new_difficulty deck."
}

# Main loop
while true; do
    display_cards  # Show all cards with global numbering

    # Prompt the user to select a card or quit
    echo "Enter the global line number to edit (or 'q' to quit):"
    read -r line_number

    if [[ "$line_number" == "q" ]]; then
        echo "Exiting..."
        break
    elif [[ "$line_number" =~ ^[0-9]+$ ]]; then
        edit_flashcard "$line_number"
    else
        echo "Invalid input. Please enter a valid global line number."
    fi
done
