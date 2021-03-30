/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_version_upd
?|
?|	Description:	Updates the table application_version
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_version_id	int		=	ApplicationVersionId
?|			@application_id		int		=	ApplicationId
?|			@version		varchar(30)	=	Version
?|			@description		varchar(100)	=	Description
?|			@creation_date		datetime		=	CreationDate
?|			@release_date		datetime		=	ReleaseDate
?|			@deprecation_date	datetime		=	DeprecationDate
?|			@deletion_date		datetime		=	DeletionDate
?|			@is_current		bit		=	IsCurrent
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_version_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_version_upd]
(
	@application_version_id int,
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
As
	Begin
			UPDATE	application_version
			SET	[application_id] = @application_id,
				[version] = @version,
				[description] = @description,
				[creation_date] = @creation_date,
				[release_date] = @release_date,
				[deprecation_date] = @deprecation_date,
				[deletion_date] = @deletion_date,
				[is_current] = @is_current
			Where	application_version_id = @application_version_id;

			select @@rowcount;

	End
