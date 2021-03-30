CREATE TABLE [dbo].[test_method_context] (
    [test_method_context_id] INT IDENTITY (1, 1) NOT NULL,
    [test_id]                INT NOT NULL,
    CONSTRAINT [test_method_context_PK_TestMethodContextId] PRIMARY KEY CLUSTERED ([test_method_context_id] ASC),
    CONSTRAINT [test_method_context_FK_TestId] FOREIGN KEY ([test_id]) REFERENCES [dbo].[test] ([test_id])
);

