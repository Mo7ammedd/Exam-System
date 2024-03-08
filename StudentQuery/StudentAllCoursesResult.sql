create or alter proc Student_AllCoursesResult @std int 
as 
begin
select  concat(Std_Fname,' ', Std_Lname ),Crs_Name,degree 
from course c inner join Student_Course sc on c.Crs_Id = sc.Course_Id 
			  inner join student s on sc.Student_Id= s.Std_Id
where Std_Id=@std
end

exec Student_AllCoursesResult 61