-- Show Questions In Course
go
CREATE OR ALTER PROCEDURE ShowQuestionsInCourse
    @Crs_name NVARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course WHERE Crs_Name = @Crs_name)
    BEGIN
        SELECT Q.Question_Id, Q_Type, Question_Text, Correct_Answer
        FROM Questions Q 
        inner JOIN Course C ON Q.Crs_Id = C.Crs_Id
        WHERE C.Crs_Name = @Crs_name;
    END
    ELSE 
    BEGIN
		RAISERROR ('Course name does not exist' ,10,1)
    END
END
go

exec ShowQuestionsInCourse 'Html'

