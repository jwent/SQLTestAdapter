CREATE TABLE [dbo].[application_version] (
    [application_version_id] INT           IDENTITY (1, 1) NOT NULL,
    [application_id]         INT           NOT NULL,
    [version]                VARCHAR (30)  NOT NULL,
    [description]            VARCHAR (100) NOT NULL,
    [creation_date]          DATETIME      CONSTRAINT [application_version_DF_CreationDate] DEFAULT (getdate()) NOT NULL,
    [release_date]           DATETIME      NULL,
    [deprecation_date]       DATETIME      NULL,
    [deletion_date]          DATETIME      NULL,
    [is_current]             BIT           NOT NULL,
    CONSTRAINT [application_version_PK_ApplicationVersionId] PRIMARY KEY CLUSTERED ([application_version_id] ASC),
    CONSTRAINT [application_version_FK_ApplicationId] FOREIGN KEY ([application_id]) REFERENCES [dbo].[application] ([application_id])
);


GO
CREATE NONCLUSTERED INDEX [application_version_IX_ApplicationId]
    ON [dbo].[application_version]([application_id] ASC);

