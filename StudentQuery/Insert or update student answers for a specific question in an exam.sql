CREATE OR ALTER PROC InsertStudentAnswers 
    @e_id INT,
    @s_id INT,
    @Q_id INT,
    @answer NVARCHAR(MAX)
AS
BEGIN
    IF EXISTS (
        SELECT * 
        FROM     Student_Exam_Questions   
        WHERE   Std_Id   = @s_id
        AND   Exam_Id   = @e_id 
        AND   Question_Id   = @Q_id
    )
    BEGIN
        MERGE INTO Student_Exam_Questions AS target
        USING (SELECT @s_id AS   Std_Id  , @e_id AS   Exam_Id  , @Q_id AS   Question_Id  ) AS source
        ON (target.Std_Id = source.Std_Id AND target.Exam_Id = source.Exam_Id AND target.Question_Id = source.Question_Id)
        WHEN MATCHED THEN
            UPDATE SET target.Answers = @answer
        WHEN NOT MATCHED THEN
            INSERT (Std_Id, Exam_Id, Question_Id, Answers)
            VALUES (@s_id, @e_id, @Q_id, @answer);
    END
    ELSE 
    BEGIN
        RAISERROR('Exam or question does not exist, please enter correct data', 10, 1)	
    END
END




exec InsertStudentAnswers 1,61,1,'c'
