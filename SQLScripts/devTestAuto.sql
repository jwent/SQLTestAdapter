USE [TestAutomation]
GO

/****** Object:  Table [dbo].[application_method]    Script Date: 2/5/2019 1:03:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[application_method](
	[application_method_id] [int] IDENTITY(1,1) NOT NULL,
    [application_method_parameters_id] [int] NULL,
	[application_id] [int] NOT NULL,
	[application_version_id] [int] NOT NULL,
	[method_name] [varchar](50) NOT NULL,
	[return_type] [varchar](50) NULL
 CONSTRAINT [application_method_PK_ApplicationMethodId] PRIMARY KEY CLUSTERED 
(
	[application_method_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[application_method_parameters]    Script Date: 2/5/2019 10:45:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_method_parameters](
	[application_method_parameter_id] [int] IDENTITY(1,1) NOT NULL,
    [application_method_id] [int] NOT NULL,
	[application_method_parameter_name] [nvarchar](50) NOT NULL,
	[position] [int] NOT NULL,
	[value] [nvarchar](max) NULL,
 CONSTRAINT [application_method_parameters_PK_ApplicationMethodParameterId] PRIMARY KEY CLUSTERED 
(
	[application_method_parameter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ag_application_method_ins]
(
	@application_id int,
	@application_version_id int,
	@method_name varchar(50),
	@return_type varchar(50)
)
AS
	BEGIN
			INSERT	INTO	application_method
			(
				[application_id] , 
				[application_version_id] , 
				[method_name] , 
				[return_type] 
				)
                OUTPUT Inserted.application_method_id AS 'application_method_id'
				Values
				(
				@application_id , 
				@application_version_id , 
				@method_name , 
				@return_type
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_parameters_ins]    Script Date: 2/5/2019 10:45:22 AM ******/
CREATE PROCEDURE [dbo].[ag_application_method_parameters_ins]
(
	@application_method_id int,
    @application_method_parameter_name varchar(50),
	@position int
)
AS
	BEGIN
			INSERT	INTO	application_method_parameters
			(
				[application_method_id] , 
                [application_method_parameter_name],
				[position]
				)
				Values
				(
				@application_method_id , 
                @application_method_parameter_name,
				@position
			);
			select @@identity;

	END

GO
