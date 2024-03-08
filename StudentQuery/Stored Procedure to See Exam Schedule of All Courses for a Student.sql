-- Stored Procedure to See Exam Schedule of All Courses for a Student
GO
CREATE OR ALTER PROCEDURE SeeExamesScheduleOfAllCourses 
    @St_Id INT
AS
BEGIN
    IF EXISTS (SELECT * FROM [dbo].[student] WHERE Std_Id = @St_Id) 
    BEGIN
        DECLARE @Intake_Id INT
        SELECT @Intake_Id = [Intake_Id] FROM [dbo].[student] WHERE Std_Id = @St_Id

        IF @Intake_Id = 3
        BEGIN
            -- Fetch exam details for all courses
            SELECT
                CONCAT(S.Std_Fname, ' ', S.Std_Lname) AS [Student Name],
                I.Intake_Name AS [Intake Year],
                C.Crs_Name AS [Course Name],
                E.Exam_Id AS [Exam ID],
                E.E_Type AS [Exam Type],
                E.Start_Time AS [Start Time],
                E.End_Time AS [End Time],
                E.Total_time AS [Total Time]
            FROM 
                [dbo].[student] S 
                JOIN [dbo].[Intake] I ON I.Intake_Id = S.[Intake_Id]
                JOIN [dbo].[Exam] E ON E.[Intake_Id] = I.[Intake_Id]
                JOIN [dbo].[Course] C ON C.Crs_Id = E.Crs_Id 
            WHERE 
                S.Std_Id = @St_Id;
        END
        ELSE
        BEGIN
            RAISERROR('Access denied, you do not have permission', 10, 1)
        END
    END
    ELSE 
    BEGIN
        RAISERROR('Student Id does not exist', 10, 1)
    END
END



EXEC SeeExamesScheduleOfAllCourses 451
---nvalid Student - Student Does Not Exist
EXEC SeeExamesScheduleOfAllCourses 600

