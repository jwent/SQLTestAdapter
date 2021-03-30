﻿/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_method_context_chain_del
?|
?|	Description:	Logically deletes records from the table test_method_context_chain
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_method_context_chain_id	int		=	TestMethodContextChainId
?|			@test_method_context_id	int		=	TestMethodContextId
?|			@subtest_id		int		=	SubtestId
?|			@test_order		int		=	TestOrder
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_method_context_chain_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_method_context_chain_del]
(
				@test_method_context_chain_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test_method_context_chain
			Where	test_method_context_chain_id = @test_method_context_chain_id;

			select @@rowcount;

	End
