CREATE TABLE [dbo].[test_plan] (
    [test_plan_id]   INT           IDENTITY (1, 1) NOT NULL,
    [application_id] INT           NOT NULL,
    [name]           VARCHAR (50)  NOT NULL,
    [description]    VARCHAR (100) NOT NULL,
    CONSTRAINT [test_plan_PK_TestPlanId] PRIMARY KEY CLUSTERED ([test_plan_id] ASC),
    CONSTRAINT [test_plan_FK_ApplicationId] FOREIGN KEY ([application_id]) REFERENCES [dbo].[application] ([application_id])
);

