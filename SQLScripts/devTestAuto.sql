USE [master]
GO
/****** Object:  Database [TestAutomation]    Script Date: 3/12/2019 12:39:39 PM ******/
CREATE DATABASE [TestAutomation]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TestAutomation', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\TestAutomation.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TestAutomation_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\TestAutomation_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [TestAutomation] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TestAutomation].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TestAutomation] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TestAutomation] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TestAutomation] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TestAutomation] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TestAutomation] SET ARITHABORT OFF 
GO
ALTER DATABASE [TestAutomation] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TestAutomation] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TestAutomation] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TestAutomation] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TestAutomation] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TestAutomation] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TestAutomation] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TestAutomation] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TestAutomation] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TestAutomation] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TestAutomation] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TestAutomation] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TestAutomation] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TestAutomation] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TestAutomation] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TestAutomation] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TestAutomation] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TestAutomation] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TestAutomation] SET  MULTI_USER 
GO
ALTER DATABASE [TestAutomation] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TestAutomation] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TestAutomation] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TestAutomation] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TestAutomation] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [TestAutomation] SET QUERY_STORE = OFF
GO
USE [TestAutomation]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [TestAutomation]
GO
/****** Object:  Table [dbo].[application_credentials]    Script Date: 3/12/2019 12:39:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_credentials](
	[credentials_functions_id] [int] NOT NULL,
	[credentials_functions_1] [nvarchar](50) NULL,
	[credentials_functions_2] [nvarchar](50) NULL,
	[credentials_functions_3] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[application_method]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_method](
	[application_method_id] [int] IDENTITY(1,1) NOT NULL,
	[application_id] [int] NOT NULL,
	[application_version_id] [int] NOT NULL,
	[method_name] [varchar](50) NOT NULL,
	[return_type] [varchar](50) NULL,
 CONSTRAINT [application_method_PK_ApplicationMethodId] PRIMARY KEY CLUSTERED 
(
	[application_method_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[application_method_parameters]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_method_parameters](
	[application_method_parameter_id] [int] IDENTITY(1,1) NOT NULL,
	[application_method_id] [int] NOT NULL,
	[application_method_name] [nvarchar](50) NOT NULL,
	[application_method_parameter_name] [nvarchar](50) NOT NULL,
	[application_method_parameter_type] [nvarchar](255) NOT NULL,
	[position] [int] NOT NULL,
	[value] [nvarchar](max) NULL,
 CONSTRAINT [application_method_parameters_PK_ApplicationMethodParameterId] PRIMARY KEY CLUSTERED 
(
	[application_method_parameter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[application_method_response_data]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_method_response_data](
	[application_method_response_data_id] [int] IDENTITY(1,1) NOT NULL,
	[application_method_response_id] [int] NOT NULL,
	[response_data_parameter_name] [nvarchar](50) NOT NULL,
	[value] [nvarchar](max) NULL,
	[expected_value] [nvarchar](max) NULL,
 CONSTRAINT [PK_application_method_response_data] PRIMARY KEY CLUSTERED 
(
	[application_method_response_data_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[application_method_response_parameters]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_method_response_parameters](
	[application_method_response_id] [int] IDENTITY(1,1) NOT NULL,
	[application_method_id] [int] NOT NULL,
	[application_method_response_parameter_name] [nvarchar](50) NULL,
	[is_container] [int] NULL,
	[position] [int] NULL,
	[value] [nvarchar](max) NULL,
 CONSTRAINT [PK_application_method_response_parameters] PRIMARY KEY CLUSTERED 
(
	[application_method_response_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reflection_type_filter]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reflection_type_filter](
	[filter_id] [int] NOT NULL,
	[application_id] [int] NOT NULL,
	[type_filter_name] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[service_description_files]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[service_description_files](
	[service_description_file_id] [int] IDENTITY(1,1) NOT NULL,
	[file] [nvarchar](max) NULL,
	[api_name] [nvarchar](50) NULL,
	[api_version] [nvarchar](50) NULL,
	[test_context] [nvarchar](50) NULL,
 CONSTRAINT [PK_service_description_files] PRIMARY KEY CLUSTERED 
(
	[service_description_file_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_ins]    Script Date: 3/12/2019 12:39:40 PM ******/
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
			/*select @@identity as application_method_id*/
			SELECT SCOPE_IDENTITY()
	END

GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_parameters_ins]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/****** Object:  StoredProcedure [dbo].[ag_application_method_parameters_ins]    Script Date: 2/5/2019 10:45:22 AM ******/
CREATE PROCEDURE [dbo].[ag_application_method_parameters_ins]
(
	@application_method_id int,
	@application_method_name varchar(50),
    @application_method_parameter_name varchar(50),
	@application_method_parameter_type varchar(255),
	@position int,
	@value nvarchar(MAX)
)
AS
	BEGIN
			INSERT	INTO	application_method_parameters
			(
				[application_method_id] , 
				[application_method_name],
                [application_method_parameter_name],
				[application_method_parameter_type],
				[position],
				[value]
				)
				Values
				(
				@application_method_id , 
				@application_method_name,
                @application_method_parameter_name,
				@application_method_parameter_type,
				@position,
				@value
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_parameters_sel]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[ag_application_method_parameters_ins]    Script Date: 2/5/2019 10:45:22 AM ******/
CREATE PROCEDURE [dbo].[ag_application_method_parameters_sel]
(
	@application_method_id int
)
AS
	BEGIN
			select application_method_parameter_id,
				application_method_id,
				application_method_parameter_name,
				position,
				value
			From application_method_parameters
			Where application_method_id = @application_method_id

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_parameters_upd]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Object:  StoredProcedure [dbo].[ag_application_method_parameters_ins]    Script Date: 2/5/2019 10:45:22 AM ******/
CREATE PROCEDURE [dbo].[ag_application_method_parameters_upd]

	@application_method_parameter_id int,
	@value nvarchar(50)
AS
BEGIN
		UPDATE application_method_parameters SET value = @value
		WHERE application_method_parameter_id = @application_method_parameter_id;
END


GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_response_data_ins]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[ag_application_method_parameters_ins]    Script Date: 2/5/2019 10:45:22 AM ******/
CREATE PROCEDURE [dbo].[ag_application_method_response_data_ins]
(
	@application_method_response_id int,
    @response_data_parameter_name varchar(50)
)
AS
	BEGIN
			INSERT	INTO application_method_response_data
			(
				[application_method_response_id],
                [response_data_parameter_name]
				)
				Values
				(
				@application_method_response_id,
                @response_data_parameter_name
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_response_parameters_ins]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/****** Object:  StoredProcedure [dbo].[ag_application_method_parameters_ins]    Script Date: 2/5/2019 10:45:22 AM ******/
CREATE PROCEDURE [dbo].[ag_application_method_response_parameters_ins]
(
	@application_method_id int,
    @application_method_response_parameter_name varchar(50),
	@position int,
	@is_container int NULL
)
AS
	BEGIN
			INSERT INTO application_method_response_parameters
			(
				[application_method_id] , 
                [application_method_response_parameter_name],
				[position],
				[is_container]
				)
				OUTPUT Inserted.application_method_response_id AS 'application_method_responses_id'
				Values
				(
				@application_method_id , 
                @application_method_response_parameter_name,
				@position,
				@is_container
			);
			SELECT SCOPE_IDENTITY()

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_sel]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Object:  StoredProcedure [dbo].[ag_application_method_parameters_ins]    Script Date: 2/5/2019 10:45:22 AM ******/
CREATE PROCEDURE [dbo].[ag_application_method_sel]
(
	@application_method_name varchar(50)
)
AS
	BEGIN
			select application_method_id,
				application_id,
				application_version_id,
				method_name,
				return_type
			From application_method
			Where method_name = @application_method_name

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_test_response_data_upd]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/****** Object:  StoredProcedure [dbo].[ag_application_method_parameters_ins]    Script Date: 2/5/2019 10:45:22 AM ******/
CREATE PROCEDURE [dbo].[ag_test_response_data_upd]
(
	@application_method_response_id int,
	@response_data_parameter_name nvarchar(50),
	@value nvarchar(max) NULL
)
AS
	BEGIN
			UPDATE application_method_response_data
				SET value = @value
				WHERE (application_method_response_id = @application_method_response_id) AND 
					(response_data_parameter_name = @response_data_parameter_name)
	END

GO
/****** Object:  StoredProcedure [dbo].[ag_test_response_parameter_upd]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/****** Object:  StoredProcedure [dbo].[ag_application_method_parameters_ins]    Script Date: 2/5/2019 10:45:22 AM ******/
CREATE PROCEDURE [dbo].[ag_test_response_parameter_upd]
(
	@application_method_id int,
	@application_method_response_parameter_name nvarchar(50),
	@value nvarchar(max) NULL
)
AS
	BEGIN
			UPDATE application_method_response_parameters
				SET value = @value
				WHERE (application_method_id = @application_method_id) AND 
					(application_method_response_parameter_name = @application_method_response_parameter_name)
	END

GO
/****** Object:  StoredProcedure [dbo].[test_method_parameter_values_sel]    Script Date: 3/12/2019 12:39:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[test_method_parameter_values_sel]
AS
	SET NOCOUNT ON;
SELECT application_method_parameters.application_method_parameter_name, application_method_parameters.value, application_method_parameters.application_method_parameter_id FROM application_method_parameters INNER JOIN application_method ON application_method_parameters.application_method_id = application_method.application_method_id WHERE (application_method.application_method_id = 1750)
GO
USE [master]
GO
ALTER DATABASE [TestAutomation] SET  READ_WRITE 
GO
