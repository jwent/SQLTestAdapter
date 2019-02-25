﻿/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_test_upd
?|
?|	Description:	Updates the table test_plan_test
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_plan_test_id	int		=	TestPlanTestId
?|			@test_plan_id		int		=	TestPlanId
?|			@test_id		int		=	TestId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_plan_test_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_test_upd]
(
	@test_plan_test_id int,
	@test_plan_id int,
	@test_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	test_plan_test
			SET	[test_plan_id] = @test_plan_id,
				[test_id] = @test_id
			Where	test_plan_test_id = @test_plan_test_id;

			select @@rowcount;

	End
