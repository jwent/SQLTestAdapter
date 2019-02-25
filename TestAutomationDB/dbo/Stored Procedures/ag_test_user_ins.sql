﻿/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_user_ins
?|
?|	Description:	Inserts new rows into the table test_user
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_environment_id	int		=	ApplicationEnvironmentId
?|			@user_name		varchar(100)	=	UserName
?|			@password		varchar(100)	=	Password
?|			@site_id		int		=	SiteId
?|			@loc_unit		char(6)		=	LocUnit
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_test_user_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_test_user_ins]
(
	@application_environment_id int,
	@user_name varchar(100),
	@password varchar(100),
	@site_id int,
	@loc_unit char(6),
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	test_user
			(
				[application_environment_id] , 
				[user_name] , 
				[password] , 
				[site_id] , 
				[loc_unit] 
				)
				Values
				(
				@application_environment_id , 
				@user_name , 
				@password , 
				@site_id , 
				@loc_unit 
			);
			select @@identity;

	END

