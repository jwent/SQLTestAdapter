/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_environment_del
?|
?|	Description:	Logically deletes records from the table application_environment
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_environment_id	int		=	ApplicationEnvironmentId
?|			@application_id		int		=	ApplicationId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@environment_id		int		=	EnvironmentId
?|			@endpoint_address	varchar(255)	=	EndpointAddress
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_environment_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_environment_del]
(
				@application_environment_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From application_environment
			Where	application_environment_id = @application_environment_id;

			select @@rowcount;

	End
