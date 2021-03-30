CREATE TABLE [dbo].[application_environment] (
    [application_environment_id] INT           IDENTITY (1, 1) NOT NULL,
    [application_id]             INT           NOT NULL,
    [application_version_id]     INT           NOT NULL,
    [environment_id]             INT           NOT NULL,
    [endpoint_address]           VARCHAR (255) NOT NULL,
    CONSTRAINT [application_environment_PK_ApplicationEnvironmentId] PRIMARY KEY CLUSTERED ([application_environment_id] ASC),
    CONSTRAINT [application_environment_FK_ApplicationId] FOREIGN KEY ([application_id]) REFERENCES [dbo].[application] ([application_id]),
    CONSTRAINT [application_environment_FK_ApplicationVersionId] FOREIGN KEY ([application_version_id]) REFERENCES [dbo].[application_version] ([application_version_id]),
    CONSTRAINT [application_environment_FK_EnvironmentId] FOREIGN KEY ([environment_id]) REFERENCES [dbo].[environment] ([environment_id])
);


GO
CREATE NONCLUSTERED INDEX [application_environment_IX_ApplicationId]
    ON [dbo].[application_environment]([application_id] ASC);


GO
CREATE NONCLUSTERED INDEX [application_environment_IX_EnvironmentId]
    ON [dbo].[application_environment]([environment_id] ASC);

