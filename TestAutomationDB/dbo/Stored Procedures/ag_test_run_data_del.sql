/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_run_data_del
?|
?|	Description:	Logically deletes records from the table test_run_data
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_run_data_id	int		=	TestRunDataId
?|			@test_run_id		int		=	TestRunId
?|			@test_id		int		=	TestId
?|			@input			xml		=	Input
?|			@output			xml		=	Output
?|			@result			nvarchar		=	Result
?|			@run_date		datetime		=	RunDate
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_run_data_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_run_data_del]
(
				@test_run_data_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test_run_data
			Where	test_run_data_id = @test_run_data_id;

			select @@rowcount;

	End
