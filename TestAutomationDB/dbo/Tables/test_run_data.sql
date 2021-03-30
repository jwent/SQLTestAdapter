CREATE TABLE [dbo].[test_run_data] (
    [test_run_data_id] INT            IDENTITY (1, 1) NOT NULL,
    [test_run_id]      INT            NOT NULL,
    [test_id]          INT            NOT NULL,
    [input]            XML            NULL,
    [output]           XML            NULL,
    [result]           NVARCHAR (MAX) NOT NULL,
    [run_date]         DATETIME       CONSTRAINT [test_run_data_DF_RunDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [test_run_data_PK_TestRunDataId] PRIMARY KEY CLUSTERED ([test_run_data_id] ASC),
    CONSTRAINT [test_run_data_FK_TestId] FOREIGN KEY ([test_id]) REFERENCES [dbo].[test] ([test_id]),
    CONSTRAINT [test_run_data_FK_TestRunId] FOREIGN KEY ([test_run_id]) REFERENCES [dbo].[test_run] ([test_run_id])
);

