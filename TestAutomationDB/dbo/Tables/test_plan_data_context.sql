CREATE TABLE [dbo].[test_plan_data_context] (
    [test_plan_data_context_id] INT IDENTITY (1, 1) NOT NULL,
    [test_id]                   INT NOT NULL,
    [test_method_context_id]    INT NOT NULL,
    CONSTRAINT [test_plan_data_context_PK_TestPlanDataContextId] PRIMARY KEY CLUSTERED ([test_plan_data_context_id] ASC),
    CONSTRAINT [test_plan_data_context_FK_TestId] FOREIGN KEY ([test_id]) REFERENCES [dbo].[test] ([test_id]),
    CONSTRAINT [test_plan_data_context_FK_TestMethodContextId] FOREIGN KEY ([test_method_context_id]) REFERENCES [dbo].[test_method_context] ([test_method_context_id])
);

