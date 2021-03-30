CREATE TABLE [dbo].[application_method_compatability] (
    [application_method_compatability_id] INT IDENTITY (1, 1) NOT NULL,
    [application_method_id]               INT NOT NULL,
    [earliest_application_version_id]     INT NOT NULL,
    [latest_application_version_id]       INT NOT NULL,
    CONSTRAINT [application_method_compatability_PK_ApplicationMethodCompatabilityId] PRIMARY KEY CLUSTERED ([application_method_compatability_id] ASC),
    CONSTRAINT [application_method_compatability_FK_ApplicationMethodId] FOREIGN KEY ([application_method_id]) REFERENCES [dbo].[application_method] ([application_method_id]),
    CONSTRAINT [application_method_compatability_FK_EarliestApplicationVersionId] FOREIGN KEY ([earliest_application_version_id]) REFERENCES [dbo].[application_version] ([application_version_id]),
    CONSTRAINT [application_method_compatability_FK_LatestApplicationVersionId] FOREIGN KEY ([latest_application_version_id]) REFERENCES [dbo].[application_version] ([application_version_id])
);


GO
CREATE NONCLUSTERED INDEX [application_method_compatability_IX_ApplicationMethodId]
    ON [dbo].[application_method_compatability]([application_method_id] ASC);

