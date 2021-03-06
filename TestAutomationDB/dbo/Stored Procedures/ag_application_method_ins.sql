/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_ins
?|
?|	Description:	Inserts new rows into the table application_method
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_id		int		=	ApplicationId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@method_name		varchar(50)	=	MethodName
?|			@input_schema		xml		=	InputSchema
?|			@output_schema		xml		=	OutputSchema
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_application_method_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_application_method_ins]
(
	@application_id int,
	@application_version_id int,
	@method_name varchar(50),
	@input_schema xml,
	@output_schema xml,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	application_method
			(
				[application_id] , 
				[application_version_id] , 
				[method_name] , 
				[input_schema] , 
				[output_schema] 
				)
				Values
				(
				@application_id , 
				@application_version_id , 
				@method_name , 
				@input_schema , 
				@output_schema 
			);
			select @@identity;

	END

