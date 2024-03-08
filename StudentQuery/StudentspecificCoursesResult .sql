CREATE OR ALTER PROCEDURE StudentspecificCoursesResult 
    @std INT,
    @course_name VARCHAR(50) 
AS 
BEGIN
    SELECT CONCAT(Std_Fname, ' ', Std_Lname) AS StudentFullName,
           Crs_Name AS CourseName,
           degree
    FROM course c 
    INNER JOIN Student_Course sc ON c.Crs_Id = sc.Course_Id 
    INNER JOIN student s ON sc.Student_Id = s.Std_Id
    WHERE Std_Id = @std
      AND Crs_Name = @course_name;

END

EXEC StudentspecificCoursesResult  @std = 61, @course_name = 'OOP using C#';
