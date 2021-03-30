CREATE TABLE [dbo].[environment] (
    [environment_id] INT          IDENTITY (1, 1) NOT NULL,
    [name]           VARCHAR (50) NOT NULL,
    [is_cloud]       BIT          NOT NULL,
    CONSTRAINT [environment_PK_EnvironmentId] PRIMARY KEY CLUSTERED ([environment_id] ASC)
);

