CREATE TABLE [dbo].[test_plan_test] (
    [test_plan_test_id] INT IDENTITY (1, 1) NOT NULL,
    [test_plan_id]      INT NOT NULL,
    [test_id]           INT NOT NULL,
    CONSTRAINT [test_plan_test_PK_TestPlanTestId] PRIMARY KEY CLUSTERED ([test_plan_test_id] ASC),
    CONSTRAINT [test_plan_test_FK_TestId] FOREIGN KEY ([test_id]) REFERENCES [dbo].[test] ([test_id]),
    CONSTRAINT [test_plan_test_FK_TestPlanId] FOREIGN KEY ([test_plan_id]) REFERENCES [dbo].[test_plan] ([test_plan_id])
);

