create or alter proc ShowQuestionExam @exam_id int
as
begin 
	
	select distinct(Question_Text) from Questions q inner join Student_Exam_Questions seq on q.Question_Id =seq.Question_Id
	where seq.Exam_Id=@exam_id

end

exec ShowQuestionExam 2