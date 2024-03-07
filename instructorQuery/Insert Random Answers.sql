-- Update MCQ questions
UPDATE Student_exam_questions
SET Answers = 
    CASE
        WHEN (SELECT Q_Type FROM Questions WHERE Question_Id = Student_exam_questions.question_id) = 'MCQ'
        THEN 
            CASE
                WHEN RAND() < 0.25 THEN 'a'
                WHEN RAND() < 0.5 THEN 'b'
                WHEN RAND() < 0.75 THEN 'c'
                ELSE 'd'
            END
    END
WHERE question_id IN (SELECT Question_Id FROM Questions WHERE Q_Type = 'MCQ');

-- Update True/False questions
UPDATE Student_exam_questions
SET Answers = 
    CASE
        WHEN (SELECT Q_Type FROM Questions WHERE Question_Id = Student_exam_questions.question_id) = 'T/F'
        THEN 
            CASE
                WHEN RAND() < 0.5 THEN 'T'
                ELSE 'F'
            END
    END
WHERE question_id IN (SELECT Question_Id FROM Questions WHERE Q_Type = 'T/F');



select * from Student_Exam_Questions