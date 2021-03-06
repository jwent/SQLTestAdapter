/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_context_upd
?|
?|	Description:	Updates the table test_plan_data_context
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_plan_data_context_id	int		=	TestPlanDataContextId
?|			@test_id		int		=	TestId
?|			@test_method_context_id	int		=	TestMethodContextId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_plan_data_context_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_data_context_upd]
(
	@test_plan_data_context_id int,
	@test_id int,
	@test_method_context_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	test_plan_data_context
			SET	[test_id] = @test_id,
				[test_method_context_id] = @test_method_context_id
			Where	test_plan_data_context_id = @test_plan_data_context_id;

			select @@rowcount;

	End
