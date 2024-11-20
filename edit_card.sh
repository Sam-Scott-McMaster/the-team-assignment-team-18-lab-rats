#!/bin/bash

edit_question() {
    echo "Type the original question, then hit enter:"
    read OG_QUESTION
    question=$(grep -c "${OG_QUESTION}" flashcards.txt)
    if [[ $question -eq 0 ]]; then
        echo "ERROR: QUESTION NOT FOUND"
        return 1
    else
        echo "Type the new question, then hit enter:"
        read NEW_QUESTION
        sed -i "s/${OG_QUESTION}/${NEW_QUESTION}/1" flashcards.txt && echo "Question updated successfully."
    fi
}

edit_answer() {
    echo "Type the original answer, then hit enter:"
    read OG_ANSWER
    answer=$(grep -c "${OG_ANSWER}" flashcards.txt)
    if [[ $answer -eq 0 ]]; then
        echo "ERROR: ANSWER NOT FOUND"
        return 1
    else
        echo "Type the new answer, then hit enter:"
        read NEW_ANSWER
        sed -i "s/${OG_ANSWER}/${NEW_ANSWER}/1" flashcards.txt && echo "Answer updated successfully."
    fi
}

echo "What would you like to edit, a question or an answer?"
read Q_or_A
if [[ $Q_or_A == "question" ]]; then
    edit_question
elif [[ $Q_or_A == "answer" ]]; then
    edit_answer
elif [[ $Q_or_A == "both" ]]; then
    edit_question
    edit_answer
else
    echo "Invalid option. Please type 'question', 'answer', or 'both'."
fi