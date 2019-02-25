CREATE TABLE [dbo].[test_plan_data] (
    [test_plan_data_id] INT      IDENTITY (1, 1) NOT NULL,
    [test_plan_id]      INT      NOT NULL,
    [test_id]           INT      NOT NULL,
    [test_user_id]      INT      NOT NULL,
    [input]             XML      NULL,
    [output]            XML      NULL,
    [creation_date]     DATETIME CONSTRAINT [test_plan_data_DF_CreationDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [test_plan_data_PK_TestPlanDataId] PRIMARY KEY CLUSTERED ([test_plan_data_id] ASC),
    CONSTRAINT [test_plan_data_FK_TestId] FOREIGN KEY ([test_id]) REFERENCES [dbo].[test] ([test_id]),
    CONSTRAINT [test_plan_data_FK_TestPlanId] FOREIGN KEY ([test_plan_id]) REFERENCES [dbo].[test_plan] ([test_plan_id]),
    CONSTRAINT [test_plan_data_FK_TestUserId] FOREIGN KEY ([test_user_id]) REFERENCES [dbo].[test_user] ([test_user_id])
);

