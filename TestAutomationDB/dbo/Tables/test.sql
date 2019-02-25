CREATE TABLE [dbo].[test] (
    [test_id]                INT IDENTITY (1, 1) NOT NULL,
    [application_id]         INT NOT NULL,
    [application_method_id]  INT NOT NULL,
    [application_version_id] INT NOT NULL,
    [default_method_input]   XML NULL,
    [default_method_output]  XML NULL,
    CONSTRAINT [test_PK_TestId] PRIMARY KEY CLUSTERED ([test_id] ASC),
    CONSTRAINT [test_FK_ApplicationId] FOREIGN KEY ([application_id]) REFERENCES [dbo].[application] ([application_id]),
    CONSTRAINT [test_FK_ApplicationMethodId] FOREIGN KEY ([application_method_id]) REFERENCES [dbo].[application_method] ([application_method_id]),
    CONSTRAINT [test_FK_ApplicationVersionId] FOREIGN KEY ([application_version_id]) REFERENCES [dbo].[application_version] ([application_version_id])
);


GO
CREATE NONCLUSTERED INDEX [test_IX_ApplicationId]
    ON [dbo].[test]([application_id] ASC);

