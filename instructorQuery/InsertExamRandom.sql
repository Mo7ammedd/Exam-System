CREATE OR ALTER PROCEDURE CreateRandomExam
    @Crs_Id INT,
    @Ins_Id INT,
    @Exam_Id INT,
    @Start_Time DATETIME,
    @End_Time DATETIME
AS
BEGIN
    -- Declare variables
    DECLARE @QuestionCount INT = 51 -- Set QuestionCount to always be 50
    DECLARE @TotalDegree INT
    DECLARE @TotalQuestions INT
    DECLARE @Question_Id INT
    DECLARE @QuestionType VARCHAR(10)
    DECLARE @Degree INT

    -- Calculate total available degree for the course
    SELECT @TotalDegree = MaxDegree
    FROM Course
    WHERE Crs_Id = @Crs_Id

    -- Get total number of questions in the question pool for the course
    SELECT @TotalQuestions = COUNT(Question_Id)
    FROM Questions
    WHERE Crs_Id = @Crs_Id

    -- Create a temporary table to store randomly selected questions
    CREATE TABLE #RandomQuestions (
        Question_Id INT,
        Q_Type VARCHAR(10),
        Correct_Answer VARCHAR(MAX),
        Question_Text VARCHAR(MAX),
        Degree INT
    )

    -- Insert randomly selected questions into the temporary table
    INSERT INTO #RandomQuestions (Question_Id, Q_Type, Correct_Answer, Question_Text, Degree)
    SELECT Question_Id, Q_Type, Correct_Answer, Question_Text, 0
    FROM (
        SELECT Question_Id, Q_Type, Correct_Answer, Question_Text,
               ROW_NUMBER() OVER (ORDER BY NEWID()) AS RowNum
        FROM Questions
        WHERE Crs_Id = @Crs_Id
    ) AS RandomizedQuestions
    WHERE RowNum <= @QuestionCount;

    -- Update degrees for each question based on total available degree
    DECLARE @RemainingDegree INT = @TotalDegree
    UPDATE #RandomQuestions
    SET Degree = 
        CASE 
            WHEN @RemainingDegree >= 5 THEN 5
            ELSE @RemainingDegree
        END,
        @RemainingDegree = 
        CASE 
            WHEN @RemainingDegree >= 5 THEN @RemainingDegree - 5
            ELSE 0
        END

    -- Delete existing data from Student_Exam_Questions
    DELETE FROM Student_Exam_Questions
    WHERE Exam_Id = @Exam_Id

    -- Insert exam details into the Exam table
    INSERT INTO Exam (Exam_Id, E_Type, Start_Time, End_Time, Intake_Id, Crs_Id, Ins_Id)
    VALUES (@Exam_Id, 'Regular', @Start_Time, @End_Time, (SELECT Intake_Id FROM Intake_Instructor WHERE Ins_Id = @Ins_Id), @Crs_Id, @Ins_Id)

    -- Insert questions into the Student_Exam_Questions table for each student
    DECLARE @Std_Id INT

    -- Loop through each student enrolled in the course
    DECLARE student_cursor CURSOR FOR
    SELECT Student_Id
    FROM Student_Course
    WHERE Course_Id = @Crs_Id

    OPEN student_cursor
    FETCH NEXT FROM student_cursor INTO @Std_Id

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Insert each question for the student with default answers and result as 0
        INSERT INTO Student_Exam_Questions (Exam_Id, Question_Id, Std_Id, Answers, Result)
        SELECT @Exam_Id, Question_Id, @Std_Id, '', 0
        FROM #RandomQuestions

        -- Increment to the next student
        FETCH NEXT FROM student_cursor INTO @Std_Id
    END

    CLOSE student_cursor
    DEALLOCATE student_cursor

    -- Drop the temporary table
    DROP TABLE #RandomQuestions
END


exec CreateRandomExam 1,1,1,'2024-01-11 13:00:00.000','2024-01-11 13:30:00.000'
		
		