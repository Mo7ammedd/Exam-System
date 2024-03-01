CREATE DATABASE Exam_System
use Exam_System

CREATE TABLE student(
	Std_Id int,
	Std_Fname nvarchar(20) ,
	Std_Lname nvarchar(20) ,
	Std_Age int ,
	Std_Address varchar(50),
	Std_Phone char(11) ,
	 Intake_Id int,
	CONSTRAINT StudentPK PRIMARY KEY (Std_Id),
	CONSTRAINT StdPhoneCheck CHECK(len(Std_Phone) = 11),
	CONSTRAINT IntakeStudentFK FOREIGN KEY (Intake_Id) REFERENCES Intake (Intake_Id)

)

 
CREATE TABLE Track(
	Track_Id int,
	Track_Name varchar(100) ,
	CONSTRAINT TrackPK PRIMARY KEY (Track_Id )
)

CREATE TABLE Intake(
	Intake_Id int,
	Intake_Name varchar(20) ,
	CONSTRAINT IntakePK PRIMARY KEY (Intake_Id )
)


CREATE TABLE Department(
	Dept_ID int,
	Dept_Name varchar(50),
	Dept_Location nvarchar(50),
	CONSTRAINT DepartmentPK PRIMARY KEY (Dept_ID )
)

CREATE TABLE Branch(
	Branch_Id int,
	Branch_Name varchar(50),
	Branch_Address nvarchar(50),
	Branch_Phone char(11)UNIQUE,
	Dept_ID int,
	CONSTRAINT BranchPK PRIMARY KEY (Branch_Id),
	CONSTRAINT BranchPhoneCheck CHECK(len(Branch_Phone) = 11),
	CONSTRAINT BranchDepartmentFK FOREIGN KEY (Dept_ID) REFERENCES Department (Dept_ID)
)

CREATE TABLE Instructor(
	Ins_Id int,
	Ins_Name nvarchar(50) ,
	Ins_Age int,
	Ins_Address nvarchar(50) default 'Tal el kabir',
	Ins_Phone char(11) ,
	CONSTRAINT InstructorPK PRIMARY KEY (Ins_Id),
	CONSTRAINT InsPhoneCheck CHECK(len(Ins_Phone) = 11)
)


CREATE TABLE Course(
	Crs_Id int,
	Crs_Name nvarchar(50),
	Crs_Description nvarchar(max),
	MinDegree int,
	MaxDegree int,
	Ins_Id int,
	CONSTRAINT CoursePK PRIMARY KEY (Crs_Id),
	CONSTRAINT CourseInstructorFK FOREIGN KEY (Ins_Id) REFERENCES Instructor (Ins_Id)
)
GO
CREATE TABLE Track_Course(
	Crs_Id int,
	Track_Id int,
	CONSTRAINT Track_CoursePK PRIMARY KEY (Crs_Id,Track_Id),
	CONSTRAINT Course_Track_CourseFK FOREIGN KEY (Crs_Id) REFERENCES Course (Crs_Id),
	CONSTRAINT Track_Track_CourseFK FOREIGN KEY (Track_Id) REFERENCES Track (Track_Id)
	
)

Go
CREATE TABLE Questions(
	Question_Id int,
	Q_Type varchar(10) ,
	Correct_Answer varchar(max),
	Question_Text varchar(max),
	Text_Keywords varchar(max),
	Crs_Id int ,
	CONSTRAINT QuestionsPK PRIMARY KEY (Question_Id),
	CONSTRAINT QuestionType CHECK (Q_Type in ('T/F','MCQ','Text')),
	CONSTRAINT QuestionsCourseFK FOREIGN KEY (Crs_Id) REFERENCES Course (Crs_Id)
)

Go
CREATE TABLE Exam(
	Exam_Id int,
	E_Type varchar(10) ,
	Start_Time DATETIME ,
	End_Time DATETIME ,
    Total_Time AS (datediff(Second , Start_time,End_time)/3600.0 ),
	Intake_Id int ,
	Crs_Id int ,
	Ins_Id int ,
	CONSTRAINT ExamPK PRIMARY KEY (Exam_Id),
	CONSTRAINT ExamIntakeFK FOREIGN KEY (Intake_Id) REFERENCES Intake (Intake_Id),
	CONSTRAINT ExamCourseFK FOREIGN KEY (Crs_Id) REFERENCES Course (Crs_Id),
	CONSTRAINT ExamInstructorFK FOREIGN KEY (Ins_Id) REFERENCES Instructor (Ins_Id),
	CONSTRAINT ExamType CHECK (E_Type in ('Regular','Corrective'))
)

CREATE TABLE Student_Course(
	Course_Id int,
	Student_Id int,
	degree int ,
    Status varchar(50),
	CONSTRAINT StudentCoursePK PRIMARY KEY (Course_Id,Student_Id),
	CONSTRAINT Std_StudentCourseFK FOREIGN KEY (Student_Id) REFERENCES Student (Std_Id),
	CONSTRAINT Crs_StudentCourseFK FOREIGN KEY (Course_Id) REFERENCES Course (Crs_Id)
)


CREATE TABLE Branch_Track_Intake(
	Branch_Id int,
	Track_Id int,
	Intake_Id int,
    CONSTRAINT BranchTrackIntakePK PRIMARY KEY (Branch_Id,Track_Id,Intake_Id),
	CONSTRAINT Branch_BranchTrackIntakeFK FOREIGN KEY (Branch_Id) REFERENCES Branch (Branch_Id),
	CONSTRAINT Track_BranchTrackIntakeFK FOREIGN KEY (Track_Id) REFERENCES Track (Track_Id),
	CONSTRAINT Intake_BranchTrackIntakeFK FOREIGN KEY (Intake_Id) REFERENCES Intake (Intake_Id)
)

CREATE TABLE Student_Exam_Questions(
	Exam_Id int,
	Question_Id int,
	Std_Id int ,
	Answers nvarchar(max),
	Result int,
	CONSTRAINT StudentExamQuestionsPK PRIMARY KEY (Exam_Id,Question_Id,Std_Id),
	CONSTRAINT Exam_StudentExamQuestionsFK FOREIGN KEY (Exam_Id) REFERENCES Exam (Exam_Id),
	CONSTRAINT Question_StudentExamQuestionsFK FOREIGN KEY (Question_Id) REFERENCES Questions (Question_Id),
	CONSTRAINT Std_StudentExamQuestionsFK FOREIGN KEY (Std_Id) REFERENCES Student (Std_Id),
)


CREATE TABLE Intake_Instructor(
	Intake_Id int,
	Ins_Id int,
	CONSTRAINT IntakeInstructorPK PRIMARY KEY (Intake_Id,Ins_Id),
	CONSTRAINT Intake_IntakeInstructorFK FOREIGN KEY (Intake_Id) REFERENCES Intake (Intake_Id),
	CONSTRAINT Ins_IntakeInstructorFK FOREIGN KEY (Ins_Id) REFERENCES Instructor (Ins_Id)
)

