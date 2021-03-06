/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_del
?|
?|	Description:	Logically deletes records from the table application_method
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_method_id	int		=	ApplicationMethodId
?|			@application_id		int		=	ApplicationId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@method_name		varchar(50)	=	MethodName
?|			@input_schema		xml		=	InputSchema
?|			@output_schema		xml		=	OutputSchema
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_method_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_method_del]
(
				@application_method_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From application_method
			Where	application_method_id = @application_method_id;

			select @@rowcount;

	End
