CREATE TABLE [dbo].[test_user] (
    [test_user_id]               INT           IDENTITY (1, 1) NOT NULL,
    [application_environment_id] INT           NOT NULL,
    [user_name]                  VARCHAR (100) NOT NULL,
    [password]                   VARCHAR (100) NOT NULL,
    [site_id]                    INT           NULL,
    [loc_unit]                   CHAR (6)      NULL,
    CONSTRAINT [test_user_PK_TestUserId] PRIMARY KEY CLUSTERED ([test_user_id] ASC),
    CONSTRAINT [test_user_FK_ApplicationEnvironmentId] FOREIGN KEY ([application_environment_id]) REFERENCES [dbo].[application_environment] ([application_environment_id])
);


GO
CREATE NONCLUSTERED INDEX [test_user_IX_ApplicationEnvironmentId]
    ON [dbo].[test_user]([application_environment_id] ASC);

