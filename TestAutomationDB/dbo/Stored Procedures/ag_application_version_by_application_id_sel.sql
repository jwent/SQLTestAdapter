/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_version_by_application_id_sel
?|
?|	Description:	Selects data from table application_version
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_version_by_application_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_version_by_application_id_sel]
(
	@application_id int

)
As
	Begin
		Select		application_version.application_version_id,
				application_version.application_id,
				application_version.version,
				application_version.description,
				application_version.creation_date,
				application_version.release_date,
				application_version.deprecation_date,
				application_version.deletion_date,
				application_version.is_current
		From		application_version
		Where		application_version.application_id = @application_id

;
	END
