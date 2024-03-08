-- Stored Procedure to See Exam Schedule of All Courses for a Student

CREATE OR ALTER PROCEDURE SeeExamesScheduleOfAllCourses 
    @St_Id INT
AS
BEGIN
    IF EXISTS (SELECT * FROM student WHERE Std_Id = @St_Id) 
    BEGIN
        DECLARE @Intake_Id INT
        SELECT @Intake_Id =   Intake_Id FROM student WHERE Std_Id = @St_Id

        IF @Intake_Id = 3
        BEGIN
            SELECT
                CONCAT(S.Std_Fname, ' ', S.Std_Lname) AS   StudentName  ,
                I.Intake_Name AS IntakeYear  ,
                C.Crs_Name AS CourseName  ,
                E.Exam_Id AS ExamID  ,
                E.E_Type AS ExamType  ,
                E.Start_Time AS StartTime  ,
                E.End_Time AS EndTime  ,
                E.Total_time AS TotalTime  
            FROM 
                    student   S 
                JOIN Intake I ON I.Intake_Id = S.Intake_Id  
                JOIN Exam E ON E.  Intake_Id = I.Intake_Id  
                JOIN course C ON C.Crs_Id = E.Crs_Id 
            WHERE 
                S.Std_Id = @St_Id;
        END
        ELSE
        BEGIN
            RAISERROR('Sdudent doesnot take any exam yet', 10, 1)
        END
    END
    ELSE 
    BEGIN
        RAISERROR('Student Id does not exist', 10, 1)
    END
END



EXEC SeeExamesScheduleOfAllCourses 421
EXEC SeeExamesScheduleOfAllCourses 600

