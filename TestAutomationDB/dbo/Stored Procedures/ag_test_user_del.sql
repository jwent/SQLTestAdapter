﻿/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_user_del
?|
?|	Description:	Logically deletes records from the table test_user
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_user_id		int		=	TestUserId
?|			@application_environment_id	int		=	ApplicationEnvironmentId
?|			@user_name		varchar(100)	=	UserName
?|			@password		varchar(100)	=	Password
?|			@site_id		int		=	SiteId
?|			@loc_unit		char(6)		=	LocUnit
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_user_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_user_del]
(
				@test_user_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test_user
			Where	test_user_id = @test_user_id;

			select @@rowcount;

	End
