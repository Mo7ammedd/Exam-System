--Show Instructor and Course in All Intake

create or alter proc ShowInstructorAllIntake @id int
as 
begin
	if exists(select 1 from Instructor where Ins_Id= @id)
		begin 
			if exists(select 1 from Course where Ins_Id = @id)
				 begin 	
					select Ins_Name ,Crs_Name ,intake_name as Year 
					from Instructor i
					inner join Course c on i.Ins_Id=c.Ins_Id 
			        inner join Intake_Instructor ii on i.Ins_Id = ii.Ins_Id 
				 	inner join Intake n on ii.Intake_Id = n.Intake_Id
				 	where  @id =i.Ins_Id 
				 end
	        else
				select 'No Courses Found For This Instructor' as Sys_Message
		end
	else
		select 'Instructor Not Found' as Sys_Message
end	
		

exec  ShowInstructorAllIntake 1 -- normal case 
exec  ShowInstructorALLIntake 47 -- ins has no courses
exec  ShowInstructorALLIntake 447 -- invalid id 