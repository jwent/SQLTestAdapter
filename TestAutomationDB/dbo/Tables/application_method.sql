CREATE TABLE [dbo].[application_method] (
    [application_method_id]  INT          IDENTITY (1, 1) NOT NULL,
    [application_id]         INT          NOT NULL,
    [application_version_id] INT          NOT NULL,
    [method_name]            VARCHAR (50) NOT NULL,
    [input_schema]           XML          NULL,
    [output_schema]          XML          NULL,
    CONSTRAINT [application_method_PK_ApplicationMethodId] PRIMARY KEY CLUSTERED ([application_method_id] ASC),
    CONSTRAINT [application_method_FK_ApplicationId] FOREIGN KEY ([application_id]) REFERENCES [dbo].[application] ([application_id]),
    CONSTRAINT [application_method_FK_ApplicationVersionId] FOREIGN KEY ([application_version_id]) REFERENCES [dbo].[application_version] ([application_version_id])
);


GO
CREATE NONCLUSTERED INDEX [application_method_IX_ApplicationId]
    ON [dbo].[application_method]([application_id] ASC);


GO
CREATE NONCLUSTERED INDEX [application_method_IX_ApplicationVersionId]
    ON [dbo].[application_method]([application_version_id] ASC);

