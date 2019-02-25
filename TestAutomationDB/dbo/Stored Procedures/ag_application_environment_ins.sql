﻿/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_environment_ins
?|
?|	Description:	Inserts new rows into the table application_environment
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_id		int		=	ApplicationId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@environment_id		int		=	EnvironmentId
?|			@endpoint_address	varchar(255)	=	EndpointAddress
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_application_environment_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_application_environment_ins]
(
	@application_id int,
	@application_version_id int,
	@environment_id int,
	@endpoint_address varchar(255),
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	application_environment
			(
				[application_id] , 
				[application_version_id] , 
				[environment_id] , 
				[endpoint_address] 
				)
				Values
				(
				@application_id , 
				@application_version_id , 
				@environment_id , 
				@endpoint_address 
			);
			select @@identity;

	END
