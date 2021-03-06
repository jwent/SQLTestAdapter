/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_del
?|
?|	Description:	Logically deletes records from the table application
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_id		int		=	ApplicationId
?|			@name			varchar(50)	=	Name
?|			@description		varchar(100)	=	Description
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_del]
(
				@application_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From application
			Where	application_id = @application_id;

			select @@rowcount;

	End
