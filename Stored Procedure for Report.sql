create procedure TakeExam
@Ex_No INT
as
begin
select q.Qus_Text, c.Choice_Text
from Exam_Question e
inner join Choices c
on e.Qus_No=c.Qus_No
inner join question q
on c.Qus_No=q.Qus_No
where e.Ex_No=@Ex_No
END

EXEC TakeExam @Ex_No=109024


ALTER  procedure [dbo].[TakeExam] @Ex_No INT
as 
begin
DECLARE @myCursor CURSOR;
DECLARE @myField INT;		
CREATE TABLE #Exam (
Quest_Answer VARCHAR(Max)
);

set @myCursor = CURSOR for
select Qus_No from Exam_Question where Ex_No=@Ex_No
OPEN @myCursor
FETCH NEXT FROM @myCursor INTO @myField;
WHILE @@FETCH_STATUS = 0
BEGIN
insert into #Exam  select Qus_Text from question  where Qus_No=@myField
insert into #Exam  select CONCAT(char(96+ ROW_NUMBER() over ( partition by Qus_No order by Choice_Text )) , ' )  ',Choice_Text) from Choices  where Qus_No=@myField
insert into #Exam   values ('')

    FETCH NEXT FROM @myCursor INTO @myField;
END;


CLOSE @myCursor;
DEALLOCATE @myCursor;

select * from #Exam
end
EXEC TakeExam 109024