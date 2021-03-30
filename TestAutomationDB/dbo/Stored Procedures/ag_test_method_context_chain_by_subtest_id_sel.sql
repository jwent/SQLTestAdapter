﻿/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_method_context_chain_by_subtest_id_sel
?|
?|	Description:	Selects data from table test_method_context_chain
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_method_context_chain_by_subtest_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_method_context_chain_by_subtest_id_sel]
(
	@subtest_id int

)
As
	Begin
		Select		test_method_context_chain.test_method_context_chain_id,
				test_method_context_chain.test_method_context_id,
				test_method_context_chain.subtest_id,
				test_method_context_chain.test_order
		From		test_method_context_chain
		Where		test_method_context_chain.subtest_id = @subtest_id

;
	END
