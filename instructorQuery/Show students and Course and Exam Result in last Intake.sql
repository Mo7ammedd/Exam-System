--Show students and Course and Exam Result in last Intake
CREATE OR ALTER PROCEDURE ShowStudentsCourse
    @ins_id INT,
    @Course_Name NVARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT *
               FROM Course
               WHERE Crs_Name = @Course_Name
                 AND Ins_Id = @ins_id)
    BEGIN
        DECLARE @Intake_Id INT
        SELECT @Intake_Id = MAX(Intake_Id)
        FROM Intake

    SELECT
    Ins_Name AS InstructorName,
    C.Crs_Name AS CourseName,
    COALESCE(S.Std_Fname + ' ' + S.Std_Lname, 'Student not found') AS StudentName,
    CASE
        WHEN Status IS NULL THEN 'Not taken yet.'
        ELSE Status
    END AS Status,
    IT.Intake_Name
FROM Student S
    JOIN Student_Course SC ON SC.Student_Id = S.Std_Id
    JOIN Course C ON C.Crs_Id = SC.Course_Id
    JOIN Instructor I ON I.Ins_Id = C.Ins_Id
    JOIN Intake IT ON IT.Intake_Id = S.Intake_Id
WHERE I.Ins_Id = @ins_id
    AND S.Intake_Id = @Intake_Id
    AND C.Crs_Name = @Course_Name
ORDER BY StudentName; -- Add a suitable column for ordering


    END
    ELSE
    BEGIN
		RAISERROR ('Instructor Id and Course Name or does not exist' ,10,1)
    END
END




exec ShowStudentsCourse 2,'CSS'