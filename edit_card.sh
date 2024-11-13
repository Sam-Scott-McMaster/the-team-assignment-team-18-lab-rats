#!/bin/bash

echo "What would you like to edit, a question or an answer? "
read Q_or_A
if [[ $Q_or_A == "question" ]]
then
    edit_question()
elif [[ $Q_or_A == "answer" ]]
then
    edit_answer()
elif [[ $Q_or_A == "both" ]]
then
    edit_question()
    edit_answer()
fi    

edit_question()
{
    echo "Type the original question, then hit enter"
    read OG_QUESTION
    question = ${cat "flashcards.txt" | grep "${OG_QUESTION}? |"  | wc -l}
    if(question -eq 0)
    then
        echo "ERROR: QUESTION NOT FOUND"
        echo $question
        return EXIT_FAILURE
    else
        echo "Type the new question, then hit enter"
        read NEW_QUESTION
        #remove term
        #add term back with new question
    fi
}

edit_answer()
{
    echo "Type the original answer, then hit enter"
    read OG_ANSWER
    answer = ${cat "flashcards.txt" | grep "| $OG_ANSWER" | wc -l}
    if(answer -eq 0)
    then
        echo "ERROR: ANSWER NOT FOUND"
        echo $answer
        return EXIT_FAILURE
    else
        echo "Type the new answer, then hit enter"
        read NEW_ANSWER
        #remove term
        #add term back with new answer 
    fi
}