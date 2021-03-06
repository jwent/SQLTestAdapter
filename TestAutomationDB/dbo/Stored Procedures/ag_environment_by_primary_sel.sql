/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_environment_by_primary_sel
?|
?|	Description:	Selects data from table ag_environment_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_environment_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_environment_by_primary_sel]
(
	@environment_id int
)
As
	Begin
		Select		environment.environment_id,
				environment.name,
				environment.is_cloud
		From		environment
		Where		environment.environment_id = @environment_id

;
	END
