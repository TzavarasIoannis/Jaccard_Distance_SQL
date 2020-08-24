 

/****** Object:  UserDefinedFunction [dbo].[jaccard]    Script Date: 7/6/2020 3:30:32 ?? ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create function  [dbo].[jaccard]
(@word1 varchar(50), @word2  varchar(50)) returns float(5)
as
 
begin

 

DECLARE  @word1table 
TABLE(word1 varchar (50 ))

DECLARE  @word2table  
TABLE(word2 varchar (50))




insert into  @word1table 
select substring(a.b, v.number+1, 1)  word1 
from (select @word1 b) a
join master..spt_values v on v.number < len(a.b)
where v.type = 'P' 

insert into  @word2table 
select substring(a.b, v.number+1, 1)  word2
from (select @word2 b) a
join master..spt_values v on v.number < len(a.b)
where v.type = 'P' 

 

update  @word1table set word1= '0' where word1= ''
update  @word2table set word2= '0' where word2= ''



declare @the_concat  float(5) ;
set @the_concat =(select count (len ( word1) ) from ( 
select    distinct   word1   from @word1table  y ,@word2table  x
where word1 = word2)  y)


declare @the_union float(5) ; 
set @the_union =(
select count(len(word1)) from ( 
select   distinct  word1  from @word1table  
union 
select   distinct word2     from @word2table  )x ) 


declare @jacc float(5) ; 
set @jacc =( @the_concat / @the_union)

return  @jacc
end
GO


