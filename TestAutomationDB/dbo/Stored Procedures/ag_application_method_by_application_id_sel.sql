﻿/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_by_application_id_sel
?|
?|	Description:	Selects data from table application_method
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_method_by_application_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_method_by_application_id_sel]
(
	@application_id int

)
As
	Begin
		Select		application_method.application_method_id,
				application_method.application_id,
				application_method.application_version_id,
				application_method.method_name,
				application_method.input_schema,
				application_method.output_schema
		From		application_method
		Where		application_method.application_id = @application_id

;
	END
