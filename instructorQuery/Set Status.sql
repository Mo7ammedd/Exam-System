create or alter proc Set_Status 
as 
begin 
	update Student_Course
	set Status =case
					when Student_Course.degree between Course.MinDegree and Course.MaxDegree then 'Success' 
					when Student_Course.degree is null then 'Not Set Yet'
					else 'failure'
					end
	from Course 
	where Student_Course.Course_Id=Course.Crs_Id
end
	
	exec Set_Status
	
	select * from Student_Course