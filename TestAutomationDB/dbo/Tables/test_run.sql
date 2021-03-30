CREATE TABLE [dbo].[test_run] (
    [test_run_id]  INT          IDENTITY (1, 1) NOT NULL,
    [test_plan_id] INT          NOT NULL,
    [run_date]     DATETIME     CONSTRAINT [test_run_DF_RunDate] DEFAULT (getdate()) NOT NULL,
    [run_build]    VARCHAR (50) NULL,
    [run_version]  VARCHAR (50) NULL,
    [run_status]   VARCHAR (10) CONSTRAINT [DF_test_run_run_status] DEFAULT ('New') NOT NULL,
    CONSTRAINT [test_run_PK_TestRunId] PRIMARY KEY CLUSTERED ([test_run_id] ASC),
    CONSTRAINT [test_run_FK_TestPlanId] FOREIGN KEY ([test_plan_id]) REFERENCES [dbo].[test_plan] ([test_plan_id])
);

