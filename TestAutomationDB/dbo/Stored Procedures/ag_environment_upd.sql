﻿/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_environment_upd
?|
?|	Description:	Updates the table environment
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@environment_id		int		=	EnvironmentId
?|			@name			varchar(50)	=	Name
?|			@is_cloud		bit		=	IsCloud
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_environment_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_environment_upd]
(
	@environment_id int,
	@name varchar(50),
	@is_cloud bit,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	environment
			SET	[name] = @name,
				[is_cloud] = @is_cloud
			Where	environment_id = @environment_id;

			select @@rowcount;

	End