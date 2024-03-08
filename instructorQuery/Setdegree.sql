CREATE OR ALTER PROCEDURE Set_Degree
    @exam_id INT,
    @course_id INT
AS 
BEGIN
    -- check answers and set results
    UPDATE seq
    SET seq.result = 
        CASE 
            WHEN seq.Answers = q.correct_answer THEN 1 
            ELSE 0 
        END
    FROM 
        Student_Exam_Questions seq
    INNER JOIN 
        Questions q ON seq.Question_Id = q.Question_Id 
    WHERE 
        seq.Exam_Id = @exam_id;

    -- set degree in student course table for students in the specific course
    UPDATE sc
    SET sc.degree = ISNULL((
        SELECT SUM(seq.result)
        FROM Student_Exam_Questions seq
        WHERE seq.Exam_Id = @exam_id AND seq.Std_Id = sc.Student_Id
        ), 0)
    FROM 
        Student_Course sc
    WHERE 
        sc.Course_Id = @course_id;

    -- show updated table 
    SELECT 
        seq.Std_Id,
        seq.Exam_Id,
        q.Question_Text,
        seq.Answers,
        seq.result
    FROM 
        Student_Exam_Questions seq
    INNER JOIN 
        Questions q ON seq.Question_Id = q.Question_Id 
    WHERE 
        seq.Exam_Id = @exam_id;
END

EXEC Set_Degree @exam_id = 1, @course_id = 1;
