﻿/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_version_ins
?|
?|	Description:	Inserts new rows into the table application_version
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_id		int		=	ApplicationId
?|			@version		varchar(30)	=	Version
?|			@description		varchar(100)	=	Description
?|			@creation_date		datetime		=	CreationDate
?|			@release_date		datetime		=	ReleaseDate
?|			@deprecation_date	datetime		=	DeprecationDate
?|			@deletion_date		datetime		=	DeletionDate
?|			@is_current		bit		=	IsCurrent
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_application_version_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_application_version_ins]
(
	@application_id int,
	@version varchar(30),
	@description varchar(100),
	@creation_date datetime,
	@release_date datetime,
	@deprecation_date datetime,
	@deletion_date datetime,
	@is_current bit,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	application_version
			(
				[application_id] , 
				[version] , 
				[description] , 
				[creation_date] , 
				[release_date] , 
				[deprecation_date] , 
				[deletion_date] , 
				[is_current] 
				)
				Values
				(
				@application_id , 
				@version , 
				@description , 
				@creation_date , 
				@release_date , 
				@deprecation_date , 
				@deletion_date , 
				@is_current 
			);
			select @@identity;

	END
