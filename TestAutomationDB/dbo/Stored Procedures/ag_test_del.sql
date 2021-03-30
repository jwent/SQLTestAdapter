﻿/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_del
?|
?|	Description:	Logically deletes records from the table test
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_id		int		=	TestId
?|			@application_id		int		=	ApplicationId
?|			@application_method_id	int		=	ApplicationMethodId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@default_method_input	xml		=	DefaultMethodInput
?|			@default_method_output	xml		=	DefaultMethodOutput
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_del]
(
				@test_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test
			Where	test_id = @test_id;

			select @@rowcount;

	End
