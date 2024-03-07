create or alter proc ShowExamCourseForStudent @crs_id int , @std_id int
as
begin 
	select CONCAT(S.Std_Fname , ' ' , S.Std_Lname) as   StudentNamee , Exam_Id, Crs_Id , Question_Text ,Answers 
	from Questions q inner join Student_Exam_Questions seq on q.Question_Id=seq.Question_Id
					 inner join student s on seq.Std_Id=s.Std_Id
	where Crs_Id = @crs_id and s.Std_Id=@std_id

end
exec ShowExamCourseForStudent 1 , 61
