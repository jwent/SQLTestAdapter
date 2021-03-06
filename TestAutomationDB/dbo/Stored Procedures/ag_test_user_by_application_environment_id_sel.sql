/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_user_by_application_environment_id_sel
?|
?|	Description:	Selects data from table test_user
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_user_by_application_environment_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_user_by_application_environment_id_sel]
(
	@application_environment_id int

)
As
	Begin
		Select		test_user.test_user_id,
				test_user.application_environment_id,
				test_user.user_name,
				test_user.password,
				test_user.site_id,
				test_user.loc_unit
		From		test_user
		Where		test_user.application_environment_id = @application_environment_id

;
	END
