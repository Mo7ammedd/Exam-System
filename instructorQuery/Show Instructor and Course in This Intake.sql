--INS CRS IN THIS INTAKE
CREATE PROC  ShowInstructorThisIntake @id int, @year varchar(20) 
as
begin
	if exists(select 1 from Instructor where Ins_Id= @id)
		begin 
			if exists(select 1 from Course where Ins_Id = @id)
				 begin 	
					if exists(select 1 from Intake where Intake_Name=@year)
						begin
							select Ins_Name ,Crs_Name ,intake_name as Year 
							from Instructor i
							inner join Course c on i.Ins_Id=c.Ins_Id 
							inner join Intake_Instructor ii on i.Ins_Id = ii.Ins_Id 
							inner join Intake n on ii.Intake_Id = n.Intake_Id
							where  @id =i.Ins_Id and @year = n.Intake_Name
						end
					else
						select 'Invalid Instructor OR Year' as Sys_Message
				 end
			 else
				select 'No Courses Found For This Instructor' as Sys_Message
		end
	else
		select 'Invalid Instructor OR Year' as Sys_Message
end	
		
	exec	 ShowInstructorThisIntake 4 , 2022 -- default 
	exec	 ShowInstructorThisIntake 4 , 2025 -- correct instructor / wrong year
	exec	 ShowInstructorThisIntake 111,2022 -- wrong instructor / correct year
	exec	 ShowInstructorThisIntake 47 ,2022 -- instructor has no courses