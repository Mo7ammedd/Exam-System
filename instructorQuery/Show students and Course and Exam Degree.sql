--Show students and Course and Exam Degree in last Intake

create or alter proc ShowDegreeStudentsInCourse @ins_id int,@Course_Name nvarchar(50)
as
begin
	IF EXISTS(SELECT * FROM     Course   
	   WHERE   Crs_Name   = @Course_Name
	   and  Ins_Id  =@ins_id )
	BEGIN
		begin
		declare @Intake_Id int
		select @Intake_Id=max(  Intake_Id  ) from     Intake  
			
			
			-- select Instructor and Course in last Intake
			select 
				  Ins_Name   as  InstructorName,
				C.Crs_Name as   CourseName  ,
				CONCAT(S.Std_Fname , ' ' , S.Std_Lname) as   StudentName  ,
				  Degree  ,
				IT.  Intake_Name  
			from     student   S
			join  Student_Course   SC on SC.Student_Id = S.Std_Id
			join  Course   C on C.Crs_Id = SC.Course_Id
			join  Instructor   I on I.Ins_Id = C.Ins_Id
			join  Intake   IT on IT.Intake_Id = S.Intake_Id

			where I.Ins_Id = @ins_id and S.Intake_Id = @Intake_Id  and C.Crs_Name = @Course_Name

		end
	end
	else 
	begin


		RAISERROR ('Instructor Id and Course Name or does not exist' ,10,1)
	end
end



exec ShowDegreeStudentsInCourse 44,'Data Analysis using Power BI'

