CREATE TABLE [dbo].[application] (
    [application_id] INT           IDENTITY (1, 1) NOT NULL,
    [name]           VARCHAR (50)  NOT NULL,
    [description]    VARCHAR (100) NOT NULL,
    CONSTRAINT [application_PK_ApplicationId] PRIMARY KEY CLUSTERED ([application_id] ASC)
);

