CREATE TABLE [dbo].[test_method_context_chain] (
    [test_method_context_chain_id] INT IDENTITY (1, 1) NOT NULL,
    [test_method_context_id]       INT NOT NULL,
    [subtest_id]                   INT NOT NULL,
    [test_order]                   INT NOT NULL,
    CONSTRAINT [test_method_context_chain_PK_TestMethodContextChainId] PRIMARY KEY CLUSTERED ([test_method_context_chain_id] ASC),
    CONSTRAINT [test_method_context_chain_FK_SubtestId] FOREIGN KEY ([subtest_id]) REFERENCES [dbo].[test] ([test_id]),
    CONSTRAINT [test_method_context_chain_FK_TestMethodContextId] FOREIGN KEY ([test_method_context_id]) REFERENCES [dbo].[test_method_context] ([test_method_context_id])
);

