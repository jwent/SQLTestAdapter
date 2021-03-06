USE [master]
GO
/****** Object:  Database [TestAutomation]    Script Date: 2/22/2019 2:48:56 PM ******/
CREATE DATABASE [TestAutomation]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TestAutomation_data', FILENAME = N'H:\SQLData\TestAutomation\TestAutomation_data.mdf' , SIZE = 20480KB , MAXSIZE = UNLIMITED, FILEGROWTH = 20480KB )
 LOG ON 
( NAME = N'TestAutomation_log', FILENAME = N'I:\SQLData\TestAutomation\TestAutomation_log.ldf' , SIZE = 10240KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
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
ALTER DATABASE [TestAutomation] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [TestAutomation] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'TestAutomation', N'ON'
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
/****** Object:  User [TestAutomation]    Script Date: 2/22/2019 2:48:57 PM ******/
CREATE USER [TestAutomation] FOR LOGIN [TestAutomation] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [db_execsps]    Script Date: 2/22/2019 2:48:57 PM ******/
CREATE ROLE [db_execsps]
GO
ALTER ROLE [db_execsps] ADD MEMBER [TestAutomation]
GO
/****** Object:  UserDefinedFunction [dbo].[CamelCase]    Script Date: 2/22/2019 2:48:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CamelCase] ( @InputString varchar(4000) ) 
RETURNS VARCHAR(4000)
AS
BEGIN

DECLARE @Index          INT
DECLARE @Char           CHAR(1)
DECLARE @PrevChar       CHAR(1)
DECLARE @OutputString   VARCHAR(255)

SET @OutputString = LOWER(@InputString)
SET @Index = 1

WHILE @Index <= LEN(@InputString)
BEGIN
    SET @Char     = SUBSTRING(@InputString, @Index, 1)
    SET @PrevChar = CASE WHEN @Index = 1 THEN ' '
                         ELSE SUBSTRING(@InputString, @Index - 1, 1)
                    END

    IF @PrevChar IN (' ', ';', ':', '!', '?', ',', '.', '_', '-', '/', '&', '''', '(')
    BEGIN
        IF @PrevChar != '''' OR UPPER(@Char) != 'S'
            SET @OutputString = STUFF(@OutputString, @Index, 1, UPPER(@Char))
    END

    SET @Index = @Index + 1
END

RETURN @OutputString

END

GO
/****** Object:  Table [dbo].[application]    Script Date: 2/22/2019 2:48:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application](
	[application_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[description] [varchar](100) NOT NULL,
 CONSTRAINT [application_PK_ApplicationId] PRIMARY KEY CLUSTERED 
(
	[application_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[application_environment]    Script Date: 2/22/2019 2:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_environment](
	[application_environment_id] [int] IDENTITY(1,1) NOT NULL,
	[application_id] [int] NOT NULL,
	[application_version_id] [int] NOT NULL,
	[environment_id] [int] NOT NULL,
	[endpoint_address] [varchar](255) NOT NULL,
 CONSTRAINT [application_environment_PK_ApplicationEnvironmentId] PRIMARY KEY CLUSTERED 
(
	[application_environment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[application_method]    Script Date: 2/22/2019 2:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_method](
	[application_method_id] [int] IDENTITY(1,1) NOT NULL,
	[application_id] [int] NOT NULL,
	[application_version_id] [int] NOT NULL,
	[method_name] [varchar](50) NOT NULL,
	[input_schema] [xml] NULL,
	[output_schema] [xml] NULL,
 CONSTRAINT [application_method_PK_ApplicationMethodId] PRIMARY KEY CLUSTERED 
(
	[application_method_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[application_method_compatability]    Script Date: 2/22/2019 2:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_method_compatability](
	[application_method_compatability_id] [int] IDENTITY(1,1) NOT NULL,
	[application_method_id] [int] NOT NULL,
	[earliest_application_version_id] [int] NOT NULL,
	[latest_application_version_id] [int] NOT NULL,
 CONSTRAINT [application_method_compatability_PK_ApplicationMethodCompatabilityId] PRIMARY KEY CLUSTERED 
(
	[application_method_compatability_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[application_version]    Script Date: 2/22/2019 2:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_version](
	[application_version_id] [int] IDENTITY(1,1) NOT NULL,
	[application_id] [int] NOT NULL,
	[version] [varchar](30) NOT NULL,
	[description] [varchar](100) NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[release_date] [datetime] NULL,
	[deprecation_date] [datetime] NULL,
	[deletion_date] [datetime] NULL,
	[is_current] [bit] NOT NULL,
 CONSTRAINT [application_version_PK_ApplicationVersionId] PRIMARY KEY CLUSTERED 
(
	[application_version_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[environment]    Script Date: 2/22/2019 2:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[environment](
	[environment_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[is_cloud] [bit] NOT NULL,
 CONSTRAINT [environment_PK_EnvironmentId] PRIMARY KEY CLUSTERED 
(
	[environment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[test]    Script Date: 2/22/2019 2:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test](
	[test_id] [int] IDENTITY(1,1) NOT NULL,
	[application_id] [int] NOT NULL,
	[application_method_id] [int] NOT NULL,
	[application_version_id] [int] NOT NULL,
	[default_method_input] [xml] NULL,
	[default_method_output] [xml] NULL,
 CONSTRAINT [test_PK_TestId] PRIMARY KEY CLUSTERED 
(
	[test_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[test_method_context]    Script Date: 2/22/2019 2:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test_method_context](
	[test_method_context_id] [int] IDENTITY(1,1) NOT NULL,
	[test_id] [int] NOT NULL,
 CONSTRAINT [test_method_context_PK_TestMethodContextId] PRIMARY KEY CLUSTERED 
(
	[test_method_context_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[test_method_context_chain]    Script Date: 2/22/2019 2:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test_method_context_chain](
	[test_method_context_chain_id] [int] IDENTITY(1,1) NOT NULL,
	[test_method_context_id] [int] NOT NULL,
	[subtest_id] [int] NOT NULL,
	[test_order] [int] NOT NULL,
 CONSTRAINT [test_method_context_chain_PK_TestMethodContextChainId] PRIMARY KEY CLUSTERED 
(
	[test_method_context_chain_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[test_plan]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test_plan](
	[test_plan_id] [int] IDENTITY(1,1) NOT NULL,
	[application_id] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[description] [varchar](100) NOT NULL,
 CONSTRAINT [test_plan_PK_TestPlanId] PRIMARY KEY CLUSTERED 
(
	[test_plan_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[test_plan_data]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test_plan_data](
	[test_plan_data_id] [int] IDENTITY(1,1) NOT NULL,
	[test_plan_id] [int] NOT NULL,
	[test_id] [int] NOT NULL,
	[test_user_id] [int] NOT NULL,
	[input] [xml] NULL,
	[output] [xml] NULL,
	[creation_date] [datetime] NOT NULL,
 CONSTRAINT [test_plan_data_PK_TestPlanDataId] PRIMARY KEY CLUSTERED 
(
	[test_plan_data_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[test_plan_data_context]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test_plan_data_context](
	[test_plan_data_context_id] [int] IDENTITY(1,1) NOT NULL,
	[test_id] [int] NOT NULL,
	[test_method_context_id] [int] NOT NULL,
 CONSTRAINT [test_plan_data_context_PK_TestPlanDataContextId] PRIMARY KEY CLUSTERED 
(
	[test_plan_data_context_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[test_plan_test]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test_plan_test](
	[test_plan_test_id] [int] IDENTITY(1,1) NOT NULL,
	[test_plan_id] [int] NOT NULL,
	[test_id] [int] NOT NULL,
 CONSTRAINT [test_plan_test_PK_TestPlanTestId] PRIMARY KEY CLUSTERED 
(
	[test_plan_test_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[test_run]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test_run](
	[test_run_id] [int] IDENTITY(1,1) NOT NULL,
	[test_plan_id] [int] NOT NULL,
	[run_date] [datetime] NOT NULL,
	[run_build] [varchar](50) NULL,
	[run_version] [varchar](50) NULL,
	[run_status] [varchar](10) NOT NULL,
 CONSTRAINT [test_run_PK_TestRunId] PRIMARY KEY CLUSTERED 
(
	[test_run_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[test_run_data]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test_run_data](
	[test_run_data_id] [int] IDENTITY(1,1) NOT NULL,
	[test_run_id] [int] NOT NULL,
	[test_id] [int] NOT NULL,
	[input] [xml] NULL,
	[output] [xml] NULL,
	[result] [nvarchar](max) NOT NULL,
	[run_date] [datetime] NOT NULL,
 CONSTRAINT [test_run_data_PK_TestRunDataId] PRIMARY KEY CLUSTERED 
(
	[test_run_data_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[test_user]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test_user](
	[test_user_id] [int] IDENTITY(1,1) NOT NULL,
	[application_environment_id] [int] NOT NULL,
	[user_name] [varchar](100) NOT NULL,
	[password] [varchar](100) NOT NULL,
	[site_id] [int] NULL,
	[loc_unit] [char](6) NULL,
 CONSTRAINT [test_user_PK_TestUserId] PRIMARY KEY CLUSTERED 
(
	[test_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [application_environment_IX_ApplicationId]    Script Date: 2/22/2019 2:48:59 PM ******/
CREATE NONCLUSTERED INDEX [application_environment_IX_ApplicationId] ON [dbo].[application_environment]
(
	[application_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [application_environment_IX_EnvironmentId]    Script Date: 2/22/2019 2:48:59 PM ******/
CREATE NONCLUSTERED INDEX [application_environment_IX_EnvironmentId] ON [dbo].[application_environment]
(
	[environment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [application_method_IX_ApplicationId]    Script Date: 2/22/2019 2:48:59 PM ******/
CREATE NONCLUSTERED INDEX [application_method_IX_ApplicationId] ON [dbo].[application_method]
(
	[application_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [application_method_IX_ApplicationVersionId]    Script Date: 2/22/2019 2:48:59 PM ******/
CREATE NONCLUSTERED INDEX [application_method_IX_ApplicationVersionId] ON [dbo].[application_method]
(
	[application_version_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [application_method_compatability_IX_ApplicationMethodId]    Script Date: 2/22/2019 2:48:59 PM ******/
CREATE NONCLUSTERED INDEX [application_method_compatability_IX_ApplicationMethodId] ON [dbo].[application_method_compatability]
(
	[application_method_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [application_version_IX_ApplicationId]    Script Date: 2/22/2019 2:48:59 PM ******/
CREATE NONCLUSTERED INDEX [application_version_IX_ApplicationId] ON [dbo].[application_version]
(
	[application_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [test_IX_ApplicationId]    Script Date: 2/22/2019 2:48:59 PM ******/
CREATE NONCLUSTERED INDEX [test_IX_ApplicationId] ON [dbo].[test]
(
	[application_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [test_user_IX_ApplicationEnvironmentId]    Script Date: 2/22/2019 2:48:59 PM ******/
CREATE NONCLUSTERED INDEX [test_user_IX_ApplicationEnvironmentId] ON [dbo].[test_user]
(
	[application_environment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[application_version] ADD  CONSTRAINT [application_version_DF_CreationDate]  DEFAULT (getdate()) FOR [creation_date]
GO
ALTER TABLE [dbo].[test_plan_data] ADD  CONSTRAINT [test_plan_data_DF_CreationDate]  DEFAULT (getdate()) FOR [creation_date]
GO
ALTER TABLE [dbo].[test_run] ADD  CONSTRAINT [test_run_DF_RunDate]  DEFAULT (getdate()) FOR [run_date]
GO
ALTER TABLE [dbo].[test_run] ADD  CONSTRAINT [DF_test_run_run_status]  DEFAULT ('New') FOR [run_status]
GO
ALTER TABLE [dbo].[test_run_data] ADD  CONSTRAINT [test_run_data_DF_RunDate]  DEFAULT (getdate()) FOR [run_date]
GO
ALTER TABLE [dbo].[application_environment]  WITH CHECK ADD  CONSTRAINT [application_environment_FK_ApplicationId] FOREIGN KEY([application_id])
REFERENCES [dbo].[application] ([application_id])
GO
ALTER TABLE [dbo].[application_environment] CHECK CONSTRAINT [application_environment_FK_ApplicationId]
GO
ALTER TABLE [dbo].[application_environment]  WITH CHECK ADD  CONSTRAINT [application_environment_FK_ApplicationVersionId] FOREIGN KEY([application_version_id])
REFERENCES [dbo].[application_version] ([application_version_id])
GO
ALTER TABLE [dbo].[application_environment] CHECK CONSTRAINT [application_environment_FK_ApplicationVersionId]
GO
ALTER TABLE [dbo].[application_environment]  WITH CHECK ADD  CONSTRAINT [application_environment_FK_EnvironmentId] FOREIGN KEY([environment_id])
REFERENCES [dbo].[environment] ([environment_id])
GO
ALTER TABLE [dbo].[application_environment] CHECK CONSTRAINT [application_environment_FK_EnvironmentId]
GO
ALTER TABLE [dbo].[application_method]  WITH CHECK ADD  CONSTRAINT [application_method_FK_ApplicationId] FOREIGN KEY([application_id])
REFERENCES [dbo].[application] ([application_id])
GO
ALTER TABLE [dbo].[application_method] CHECK CONSTRAINT [application_method_FK_ApplicationId]
GO
ALTER TABLE [dbo].[application_method]  WITH CHECK ADD  CONSTRAINT [application_method_FK_ApplicationVersionId] FOREIGN KEY([application_version_id])
REFERENCES [dbo].[application_version] ([application_version_id])
GO
ALTER TABLE [dbo].[application_method] CHECK CONSTRAINT [application_method_FK_ApplicationVersionId]
GO
ALTER TABLE [dbo].[application_method_compatability]  WITH CHECK ADD  CONSTRAINT [application_method_compatability_FK_ApplicationMethodId] FOREIGN KEY([application_method_id])
REFERENCES [dbo].[application_method] ([application_method_id])
GO
ALTER TABLE [dbo].[application_method_compatability] CHECK CONSTRAINT [application_method_compatability_FK_ApplicationMethodId]
GO
ALTER TABLE [dbo].[application_method_compatability]  WITH CHECK ADD  CONSTRAINT [application_method_compatability_FK_EarliestApplicationVersionId] FOREIGN KEY([earliest_application_version_id])
REFERENCES [dbo].[application_version] ([application_version_id])
GO
ALTER TABLE [dbo].[application_method_compatability] CHECK CONSTRAINT [application_method_compatability_FK_EarliestApplicationVersionId]
GO
ALTER TABLE [dbo].[application_method_compatability]  WITH CHECK ADD  CONSTRAINT [application_method_compatability_FK_LatestApplicationVersionId] FOREIGN KEY([latest_application_version_id])
REFERENCES [dbo].[application_version] ([application_version_id])
GO
ALTER TABLE [dbo].[application_method_compatability] CHECK CONSTRAINT [application_method_compatability_FK_LatestApplicationVersionId]
GO
ALTER TABLE [dbo].[application_version]  WITH CHECK ADD  CONSTRAINT [application_version_FK_ApplicationId] FOREIGN KEY([application_id])
REFERENCES [dbo].[application] ([application_id])
GO
ALTER TABLE [dbo].[application_version] CHECK CONSTRAINT [application_version_FK_ApplicationId]
GO
ALTER TABLE [dbo].[test]  WITH CHECK ADD  CONSTRAINT [test_FK_ApplicationId] FOREIGN KEY([application_id])
REFERENCES [dbo].[application] ([application_id])
GO
ALTER TABLE [dbo].[test] CHECK CONSTRAINT [test_FK_ApplicationId]
GO
ALTER TABLE [dbo].[test]  WITH CHECK ADD  CONSTRAINT [test_FK_ApplicationMethodId] FOREIGN KEY([application_method_id])
REFERENCES [dbo].[application_method] ([application_method_id])
GO
ALTER TABLE [dbo].[test] CHECK CONSTRAINT [test_FK_ApplicationMethodId]
GO
ALTER TABLE [dbo].[test]  WITH CHECK ADD  CONSTRAINT [test_FK_ApplicationVersionId] FOREIGN KEY([application_version_id])
REFERENCES [dbo].[application_version] ([application_version_id])
GO
ALTER TABLE [dbo].[test] CHECK CONSTRAINT [test_FK_ApplicationVersionId]
GO
ALTER TABLE [dbo].[test_method_context]  WITH CHECK ADD  CONSTRAINT [test_method_context_FK_TestId] FOREIGN KEY([test_id])
REFERENCES [dbo].[test] ([test_id])
GO
ALTER TABLE [dbo].[test_method_context] CHECK CONSTRAINT [test_method_context_FK_TestId]
GO
ALTER TABLE [dbo].[test_method_context_chain]  WITH CHECK ADD  CONSTRAINT [test_method_context_chain_FK_SubtestId] FOREIGN KEY([subtest_id])
REFERENCES [dbo].[test] ([test_id])
GO
ALTER TABLE [dbo].[test_method_context_chain] CHECK CONSTRAINT [test_method_context_chain_FK_SubtestId]
GO
ALTER TABLE [dbo].[test_method_context_chain]  WITH CHECK ADD  CONSTRAINT [test_method_context_chain_FK_TestMethodContextId] FOREIGN KEY([test_method_context_id])
REFERENCES [dbo].[test_method_context] ([test_method_context_id])
GO
ALTER TABLE [dbo].[test_method_context_chain] CHECK CONSTRAINT [test_method_context_chain_FK_TestMethodContextId]
GO
ALTER TABLE [dbo].[test_plan]  WITH CHECK ADD  CONSTRAINT [test_plan_FK_ApplicationId] FOREIGN KEY([application_id])
REFERENCES [dbo].[application] ([application_id])
GO
ALTER TABLE [dbo].[test_plan] CHECK CONSTRAINT [test_plan_FK_ApplicationId]
GO
ALTER TABLE [dbo].[test_plan_data]  WITH CHECK ADD  CONSTRAINT [test_plan_data_FK_TestId] FOREIGN KEY([test_id])
REFERENCES [dbo].[test] ([test_id])
GO
ALTER TABLE [dbo].[test_plan_data] CHECK CONSTRAINT [test_plan_data_FK_TestId]
GO
ALTER TABLE [dbo].[test_plan_data]  WITH CHECK ADD  CONSTRAINT [test_plan_data_FK_TestPlanId] FOREIGN KEY([test_plan_id])
REFERENCES [dbo].[test_plan] ([test_plan_id])
GO
ALTER TABLE [dbo].[test_plan_data] CHECK CONSTRAINT [test_plan_data_FK_TestPlanId]
GO
ALTER TABLE [dbo].[test_plan_data]  WITH CHECK ADD  CONSTRAINT [test_plan_data_FK_TestUserId] FOREIGN KEY([test_user_id])
REFERENCES [dbo].[test_user] ([test_user_id])
GO
ALTER TABLE [dbo].[test_plan_data] CHECK CONSTRAINT [test_plan_data_FK_TestUserId]
GO
ALTER TABLE [dbo].[test_plan_data_context]  WITH CHECK ADD  CONSTRAINT [test_plan_data_context_FK_TestId] FOREIGN KEY([test_id])
REFERENCES [dbo].[test] ([test_id])
GO
ALTER TABLE [dbo].[test_plan_data_context] CHECK CONSTRAINT [test_plan_data_context_FK_TestId]
GO
ALTER TABLE [dbo].[test_plan_data_context]  WITH CHECK ADD  CONSTRAINT [test_plan_data_context_FK_TestMethodContextId] FOREIGN KEY([test_method_context_id])
REFERENCES [dbo].[test_method_context] ([test_method_context_id])
GO
ALTER TABLE [dbo].[test_plan_data_context] CHECK CONSTRAINT [test_plan_data_context_FK_TestMethodContextId]
GO
ALTER TABLE [dbo].[test_plan_test]  WITH CHECK ADD  CONSTRAINT [test_plan_test_FK_TestId] FOREIGN KEY([test_id])
REFERENCES [dbo].[test] ([test_id])
GO
ALTER TABLE [dbo].[test_plan_test] CHECK CONSTRAINT [test_plan_test_FK_TestId]
GO
ALTER TABLE [dbo].[test_plan_test]  WITH CHECK ADD  CONSTRAINT [test_plan_test_FK_TestPlanId] FOREIGN KEY([test_plan_id])
REFERENCES [dbo].[test_plan] ([test_plan_id])
GO
ALTER TABLE [dbo].[test_plan_test] CHECK CONSTRAINT [test_plan_test_FK_TestPlanId]
GO
ALTER TABLE [dbo].[test_run]  WITH CHECK ADD  CONSTRAINT [test_run_FK_TestPlanId] FOREIGN KEY([test_plan_id])
REFERENCES [dbo].[test_plan] ([test_plan_id])
GO
ALTER TABLE [dbo].[test_run] CHECK CONSTRAINT [test_run_FK_TestPlanId]
GO
ALTER TABLE [dbo].[test_run_data]  WITH CHECK ADD  CONSTRAINT [test_run_data_FK_TestId] FOREIGN KEY([test_id])
REFERENCES [dbo].[test] ([test_id])
GO
ALTER TABLE [dbo].[test_run_data] CHECK CONSTRAINT [test_run_data_FK_TestId]
GO
ALTER TABLE [dbo].[test_run_data]  WITH CHECK ADD  CONSTRAINT [test_run_data_FK_TestRunId] FOREIGN KEY([test_run_id])
REFERENCES [dbo].[test_run] ([test_run_id])
GO
ALTER TABLE [dbo].[test_run_data] CHECK CONSTRAINT [test_run_data_FK_TestRunId]
GO
ALTER TABLE [dbo].[test_user]  WITH CHECK ADD  CONSTRAINT [test_user_FK_ApplicationEnvironmentId] FOREIGN KEY([application_environment_id])
REFERENCES [dbo].[application_environment] ([application_environment_id])
GO
ALTER TABLE [dbo].[test_user] CHECK CONSTRAINT [test_user_FK_ApplicationEnvironmentId]
GO
/****** Object:  StoredProcedure [dbo].[ag_application_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_by_primary_sel
?|
?|	Description:	Selects data from table ag_application_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_by_primary_sel]
(
	@application_id int
)
As
	Begin
		Select		application.application_id,
				application.name,
				application.description
		From		application
		Where		application.application_id = @application_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_del
?|
?|	Description:	Logically deletes records from the table application
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_id		int		=	ApplicationId
?|			@name			varchar(50)	=	Name
?|			@description		varchar(100)	=	Description
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_del]
(
				@application_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From application
			Where	application_id = @application_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_application_environment_by_application_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_environment_by_application_id_sel
?|
?|	Description:	Selects data from table application_environment
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_environment_by_application_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_environment_by_application_id_sel]
(
	@application_id int

)
As
	Begin
		Select		application_environment.application_environment_id,
				application_environment.application_id,
				application_environment.application_version_id,
				application_environment.environment_id,
				application_environment.endpoint_address
		From		application_environment
		Where		application_environment.application_id = @application_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_environment_by_application_version_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_environment_by_application_version_id_sel
?|
?|	Description:	Selects data from table application_environment
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_environment_by_application_version_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_environment_by_application_version_id_sel]
(
	@application_version_id int

)
As
	Begin
		Select		application_environment.application_environment_id,
				application_environment.application_id,
				application_environment.application_version_id,
				application_environment.environment_id,
				application_environment.endpoint_address
		From		application_environment
		Where		application_environment.application_version_id = @application_version_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_environment_by_environment_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_environment_by_environment_id_sel
?|
?|	Description:	Selects data from table application_environment
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_environment_by_environment_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_environment_by_environment_id_sel]
(
	@environment_id int

)
As
	Begin
		Select		application_environment.application_environment_id,
				application_environment.application_id,
				application_environment.application_version_id,
				application_environment.environment_id,
				application_environment.endpoint_address
		From		application_environment
		Where		application_environment.environment_id = @environment_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_environment_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_environment_by_primary_sel
?|
?|	Description:	Selects data from table ag_application_environment_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_environment_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_environment_by_primary_sel]
(
	@application_environment_id int
)
As
	Begin
		Select		application_environment.application_environment_id,
				application_environment.application_id,
				application_environment.application_version_id,
				application_environment.environment_id,
				application_environment.endpoint_address
		From		application_environment
		Where		application_environment.application_environment_id = @application_environment_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_environment_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_environment_del
?|
?|	Description:	Logically deletes records from the table application_environment
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_environment_id	int		=	ApplicationEnvironmentId
?|			@application_id		int		=	ApplicationId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@environment_id		int		=	EnvironmentId
?|			@endpoint_address	varchar(255)	=	EndpointAddress
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_environment_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_environment_del]
(
				@application_environment_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From application_environment
			Where	application_environment_id = @application_environment_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_application_environment_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_environment_ins
?|
?|	Description:	Inserts new rows into the table application_environment
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_id		int		=	ApplicationId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@environment_id		int		=	EnvironmentId
?|			@endpoint_address	varchar(255)	=	EndpointAddress
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_application_environment_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_application_environment_ins]
(
	@application_id int,
	@application_version_id int,
	@environment_id int,
	@endpoint_address varchar(255),
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	application_environment
			(
				[application_id] , 
				[application_version_id] , 
				[environment_id] , 
				[endpoint_address] 
				)
				Values
				(
				@application_id , 
				@application_version_id , 
				@environment_id , 
				@endpoint_address 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_application_environment_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_environment_upd
?|
?|	Description:	Updates the table application_environment
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_environment_id	int		=	ApplicationEnvironmentId
?|			@application_id		int		=	ApplicationId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@environment_id		int		=	EnvironmentId
?|			@endpoint_address	varchar(255)	=	EndpointAddress
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_environment_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_environment_upd]
(
	@application_environment_id int,
	@application_id int,
	@application_version_id int,
	@environment_id int,
	@endpoint_address varchar(255),
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	application_environment
			SET	[application_id] = @application_id,
				[application_version_id] = @application_version_id,
				[environment_id] = @environment_id,
				[endpoint_address] = @endpoint_address
			Where	application_environment_id = @application_environment_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_application_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_ins
?|
?|	Description:	Inserts new rows into the table application
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@name			varchar(50)	=	Name
?|			@description		varchar(100)	=	Description
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_application_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_application_ins]
(
	@name varchar(50),
	@description varchar(100),
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	application
			(
				[name] , 
				[description] 
				)
				Values
				(
				@name , 
				@description 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_by_application_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_by_application_id_sel
?|
?|	Description:	Selects data from table application_method
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_method_by_application_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_method_by_application_id_sel]
(
	@application_id int

)
As
	Begin
		Select		application_method.application_method_id,
				application_method.application_id,
				application_method.application_version_id,
				application_method.method_name,
				application_method.input_schema,
				application_method.output_schema
		From		application_method
		Where		application_method.application_id = @application_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_by_application_version_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_by_application_version_id_sel
?|
?|	Description:	Selects data from table application_method
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_method_by_application_version_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_method_by_application_version_id_sel]
(
	@application_version_id int

)
As
	Begin
		Select		application_method.application_method_id,
				application_method.application_id,
				application_method.application_version_id,
				application_method.method_name,
				application_method.input_schema,
				application_method.output_schema
		From		application_method
		Where		application_method.application_version_id = @application_version_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_by_primary_sel
?|
?|	Description:	Selects data from table ag_application_method_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_method_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_method_by_primary_sel]
(
	@application_method_id int
)
As
	Begin
		Select		application_method.application_method_id,
				application_method.application_id,
				application_method.application_version_id,
				application_method.method_name,
				application_method.input_schema,
				application_method.output_schema
		From		application_method
		Where		application_method.application_method_id = @application_method_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_compatability_by_application_method_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_compatability_by_application_method_id_sel
?|
?|	Description:	Selects data from table application_method_compatability
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_method_compatability_by_application_method_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_method_compatability_by_application_method_id_sel]
(
	@application_method_id int

)
As
	Begin
		Select		application_method_compatability.application_method_compatability_id,
				application_method_compatability.application_method_id,
				application_method_compatability.earliest_application_version_id,
				application_method_compatability.latest_application_version_id
		From		application_method_compatability
		Where		application_method_compatability.application_method_id = @application_method_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_compatability_by_earliest_application_version_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_compatability_by_earliest_application_version_id_sel
?|
?|	Description:	Selects data from table application_method_compatability
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_method_compatability_by_earliest_application_version_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_method_compatability_by_earliest_application_version_id_sel]
(
	@earliest_application_version_id int

)
As
	Begin
		Select		application_method_compatability.application_method_compatability_id,
				application_method_compatability.application_method_id,
				application_method_compatability.earliest_application_version_id,
				application_method_compatability.latest_application_version_id
		From		application_method_compatability
		Where		application_method_compatability.earliest_application_version_id = @earliest_application_version_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_compatability_by_latest_application_version_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_compatability_by_latest_application_version_id_sel
?|
?|	Description:	Selects data from table application_method_compatability
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_method_compatability_by_latest_application_version_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_method_compatability_by_latest_application_version_id_sel]
(
	@latest_application_version_id int

)
As
	Begin
		Select		application_method_compatability.application_method_compatability_id,
				application_method_compatability.application_method_id,
				application_method_compatability.earliest_application_version_id,
				application_method_compatability.latest_application_version_id
		From		application_method_compatability
		Where		application_method_compatability.latest_application_version_id = @latest_application_version_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_compatability_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_compatability_by_primary_sel
?|
?|	Description:	Selects data from table ag_application_method_compatability_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_method_compatability_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_method_compatability_by_primary_sel]
(
	@application_method_compatability_id int
)
As
	Begin
		Select		application_method_compatability.application_method_compatability_id,
				application_method_compatability.application_method_id,
				application_method_compatability.earliest_application_version_id,
				application_method_compatability.latest_application_version_id
		From		application_method_compatability
		Where		application_method_compatability.application_method_compatability_id = @application_method_compatability_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_compatability_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_compatability_del
?|
?|	Description:	Logically deletes records from the table application_method_compatability
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_method_compatability_id	int		=	ApplicationMethodCompatabilityId
?|			@application_method_id	int		=	ApplicationMethodId
?|			@earliest_application_version_id	int		=	EarliestApplicationVersionId
?|			@latest_application_version_id	int		=	LatestApplicationVersionId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_method_compatability_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_method_compatability_del]
(
				@application_method_compatability_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From application_method_compatability
			Where	application_method_compatability_id = @application_method_compatability_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_compatability_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_compatability_ins
?|
?|	Description:	Inserts new rows into the table application_method_compatability
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_method_id	int		=	ApplicationMethodId
?|			@earliest_application_version_id	int		=	EarliestApplicationVersionId
?|			@latest_application_version_id	int		=	LatestApplicationVersionId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_application_method_compatability_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_application_method_compatability_ins]
(
	@application_method_id int,
	@earliest_application_version_id int,
	@latest_application_version_id int,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	application_method_compatability
			(
				[application_method_id] , 
				[earliest_application_version_id] , 
				[latest_application_version_id] 
				)
				Values
				(
				@application_method_id , 
				@earliest_application_version_id , 
				@latest_application_version_id 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_compatability_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_compatability_upd
?|
?|	Description:	Updates the table application_method_compatability
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_method_compatability_id	int		=	ApplicationMethodCompatabilityId
?|			@application_method_id	int		=	ApplicationMethodId
?|			@earliest_application_version_id	int		=	EarliestApplicationVersionId
?|			@latest_application_version_id	int		=	LatestApplicationVersionId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_method_compatability_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_method_compatability_upd]
(
	@application_method_compatability_id int,
	@application_method_id int,
	@earliest_application_version_id int,
	@latest_application_version_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	application_method_compatability
			SET	[application_method_id] = @application_method_id,
				[earliest_application_version_id] = @earliest_application_version_id,
				[latest_application_version_id] = @latest_application_version_id
			Where	application_method_compatability_id = @application_method_compatability_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_del
?|
?|	Description:	Logically deletes records from the table application_method
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_method_id	int		=	ApplicationMethodId
?|			@application_id		int		=	ApplicationId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@method_name		varchar(50)	=	MethodName
?|			@input_schema		xml		=	InputSchema
?|			@output_schema		xml		=	OutputSchema
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_method_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_method_del]
(
				@application_method_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From application_method
			Where	application_method_id = @application_method_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_ins
?|
?|	Description:	Inserts new rows into the table application_method
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_id		int		=	ApplicationId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@method_name		varchar(50)	=	MethodName
?|			@input_schema		xml		=	InputSchema
?|			@output_schema		xml		=	OutputSchema
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_application_method_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_application_method_ins]
(
	@application_id int,
	@application_version_id int,
	@method_name varchar(50),
	@input_schema xml,
	@output_schema xml,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	application_method
			(
				[application_id] , 
				[application_version_id] , 
				[method_name] , 
				[input_schema] , 
				[output_schema] 
				)
				Values
				(
				@application_id , 
				@application_version_id , 
				@method_name , 
				@input_schema , 
				@output_schema 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_application_method_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_method_upd
?|
?|	Description:	Updates the table application_method
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_method_id	int		=	ApplicationMethodId
?|			@application_id		int		=	ApplicationId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@method_name		varchar(50)	=	MethodName
?|			@input_schema		xml		=	InputSchema
?|			@output_schema		xml		=	OutputSchema
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_method_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_method_upd]
(
	@application_method_id int,
	@application_id int,
	@application_version_id int,
	@method_name varchar(50),
	@input_schema xml,
	@output_schema xml,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	application_method
			SET	[application_id] = @application_id,
				[application_version_id] = @application_version_id,
				[method_name] = @method_name,
				[input_schema] = @input_schema,
				[output_schema] = @output_schema
			Where	application_method_id = @application_method_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_application_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_upd
?|
?|	Description:	Updates the table application
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_id		int		=	ApplicationId
?|			@name			varchar(50)	=	Name
?|			@description		varchar(100)	=	Description
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_upd]
(
	@application_id int,
	@name varchar(50),
	@description varchar(100),
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	application
			SET	[name] = @name,
				[description] = @description
			Where	application_id = @application_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_application_version_by_application_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_version_by_application_id_sel
?|
?|	Description:	Selects data from table application_version
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_version_by_application_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_version_by_application_id_sel]
(
	@application_id int

)
As
	Begin
		Select		application_version.application_version_id,
				application_version.application_id,
				application_version.version,
				application_version.description,
				application_version.creation_date,
				application_version.release_date,
				application_version.deprecation_date,
				application_version.deletion_date,
				application_version.is_current
		From		application_version
		Where		application_version.application_id = @application_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_version_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_version_by_primary_sel
?|
?|	Description:	Selects data from table ag_application_version_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_application_version_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_version_by_primary_sel]
(
	@application_version_id int
)
As
	Begin
		Select		application_version.application_version_id,
				application_version.application_id,
				application_version.version,
				application_version.description,
				application_version.creation_date,
				application_version.release_date,
				application_version.deprecation_date,
				application_version.deletion_date,
				application_version.is_current
		From		application_version
		Where		application_version.application_version_id = @application_version_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_application_version_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_version_del
?|
?|	Description:	Logically deletes records from the table application_version
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_version_id	int		=	ApplicationVersionId
?|			@application_id		int		=	ApplicationId
?|			@version		varchar(30)	=	Version
?|			@description		varchar(100)	=	Description
?|			@creation_date		datetime		=	CreationDate
?|			@release_date		datetime		=	ReleaseDate
?|			@deprecation_date	datetime		=	DeprecationDate
?|			@deletion_date		datetime		=	DeletionDate
?|			@is_current		bit		=	IsCurrent
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_version_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_version_del]
(
				@application_version_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From application_version
			Where	application_version_id = @application_version_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_application_version_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_version_ins
?|
?|	Description:	Inserts new rows into the table application_version
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_id		int		=	ApplicationId
?|			@version		varchar(30)	=	Version
?|			@description		varchar(100)	=	Description
?|			@creation_date		datetime		=	CreationDate
?|			@release_date		datetime		=	ReleaseDate
?|			@deprecation_date	datetime		=	DeprecationDate
?|			@deletion_date		datetime		=	DeletionDate
?|			@is_current		bit		=	IsCurrent
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_application_version_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_application_version_ins]
(
	@application_id int,
	@version varchar(30),
	@description varchar(100),
	@creation_date datetime,
	@release_date datetime,
	@deprecation_date datetime,
	@deletion_date datetime,
	@is_current bit,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	application_version
			(
				[application_id] , 
				[version] , 
				[description] , 
				[creation_date] , 
				[release_date] , 
				[deprecation_date] , 
				[deletion_date] , 
				[is_current] 
				)
				Values
				(
				@application_id , 
				@version , 
				@description , 
				@creation_date , 
				@release_date , 
				@deprecation_date , 
				@deletion_date , 
				@is_current 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_application_version_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_application_version_upd
?|
?|	Description:	Updates the table application_version
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_version_id	int		=	ApplicationVersionId
?|			@application_id		int		=	ApplicationId
?|			@version		varchar(30)	=	Version
?|			@description		varchar(100)	=	Description
?|			@creation_date		datetime		=	CreationDate
?|			@release_date		datetime		=	ReleaseDate
?|			@deprecation_date	datetime		=	DeprecationDate
?|			@deletion_date		datetime		=	DeletionDate
?|			@is_current		bit		=	IsCurrent
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_application_version_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_application_version_upd]
(
	@application_version_id int,
	@application_id int,
	@version varchar(30),
	@description varchar(100),
	@creation_date datetime,
	@release_date datetime,
	@deprecation_date datetime,
	@deletion_date datetime,
	@is_current bit,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	application_version
			SET	[application_id] = @application_id,
				[version] = @version,
				[description] = @description,
				[creation_date] = @creation_date,
				[release_date] = @release_date,
				[deprecation_date] = @deprecation_date,
				[deletion_date] = @deletion_date,
				[is_current] = @is_current
			Where	application_version_id = @application_version_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_environment_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_environment_by_primary_sel
?|
?|	Description:	Selects data from table ag_environment_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_environment_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_environment_by_primary_sel]
(
	@environment_id int
)
As
	Begin
		Select		environment.environment_id,
				environment.name,
				environment.is_cloud
		From		environment
		Where		environment.environment_id = @environment_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_environment_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_environment_del
?|
?|	Description:	Logically deletes records from the table environment
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@environment_id		int		=	EnvironmentId
?|			@name			varchar(50)	=	Name
?|			@is_cloud		bit		=	IsCloud
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_environment_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_environment_del]
(
				@environment_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From environment
			Where	environment_id = @environment_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_environment_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_environment_ins
?|
?|	Description:	Inserts new rows into the table environment
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@name			varchar(50)	=	Name
?|			@is_cloud		bit		=	IsCloud
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_environment_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_environment_ins]
(
	@name varchar(50),
	@is_cloud bit,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	environment
			(
				[name] , 
				[is_cloud] 
				)
				Values
				(
				@name , 
				@is_cloud 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_environment_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_environment_upd
?|
?|	Description:	Updates the table environment
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@environment_id		int		=	EnvironmentId
?|			@name			varchar(50)	=	Name
?|			@is_cloud		bit		=	IsCloud
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_environment_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_environment_upd]
(
	@environment_id int,
	@name varchar(50),
	@is_cloud bit,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	environment
			SET	[name] = @name,
				[is_cloud] = @is_cloud
			Where	environment_id = @environment_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_by_application_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_by_application_id_sel
?|
?|	Description:	Selects data from table test
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_by_application_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_by_application_id_sel]
(
	@application_id int

)
As
	Begin
		Select		test.test_id,
				test.application_id,
				test.application_method_id,
				test.application_version_id,
				test.default_method_input,
				test.default_method_output
		From		test
		Where		test.application_id = @application_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_by_application_method_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_by_application_method_id_sel
?|
?|	Description:	Selects data from table test
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_by_application_method_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_by_application_method_id_sel]
(
	@application_method_id int

)
As
	Begin
		Select		test.test_id,
				test.application_id,
				test.application_method_id,
				test.application_version_id,
				test.default_method_input,
				test.default_method_output
		From		test
		Where		test.application_method_id = @application_method_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_by_application_version_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_by_application_version_id_sel
?|
?|	Description:	Selects data from table test
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_by_application_version_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_by_application_version_id_sel]
(
	@application_version_id int

)
As
	Begin
		Select		test.test_id,
				test.application_id,
				test.application_method_id,
				test.application_version_id,
				test.default_method_input,
				test.default_method_output
		From		test
		Where		test.application_version_id = @application_version_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_by_primary_sel
?|
?|	Description:	Selects data from table ag_test_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_by_primary_sel]
(
	@test_id int
)
As
	Begin
		Select		test.test_id,
				test.application_id,
				test.application_method_id,
				test.application_version_id,
				test.default_method_input,
				test.default_method_output
		From		test
		Where		test.test_id = @test_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_del
?|
?|	Description:	Logically deletes records from the table test
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_id		int		=	TestId
?|			@application_id		int		=	ApplicationId
?|			@application_method_id	int		=	ApplicationMethodId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@default_method_input	xml		=	DefaultMethodInput
?|			@default_method_output	xml		=	DefaultMethodOutput
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_del]
(
				@test_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test
			Where	test_id = @test_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_ins
?|
?|	Description:	Inserts new rows into the table test
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_id		int		=	ApplicationId
?|			@application_method_id	int		=	ApplicationMethodId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@default_method_input	xml		=	DefaultMethodInput
?|			@default_method_output	xml		=	DefaultMethodOutput
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_test_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_test_ins]
(
	@application_id int,
	@application_method_id int,
	@application_version_id int,
	@default_method_input xml,
	@default_method_output xml,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	test
			(
				[application_id] , 
				[application_method_id] , 
				[application_version_id] , 
				[default_method_input] , 
				[default_method_output] 
				)
				Values
				(
				@application_id , 
				@application_method_id , 
				@application_version_id , 
				@default_method_input , 
				@default_method_output 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_test_method_context_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_method_context_by_primary_sel
?|
?|	Description:	Selects data from table ag_test_method_context_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_method_context_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_method_context_by_primary_sel]
(
	@test_method_context_id int
)
As
	Begin
		Select		test_method_context.test_method_context_id,
				test_method_context.test_id
		From		test_method_context
		Where		test_method_context.test_method_context_id = @test_method_context_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_method_context_by_test_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_method_context_by_test_id_sel
?|
?|	Description:	Selects data from table test_method_context
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_method_context_by_test_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_method_context_by_test_id_sel]
(
	@test_id int

)
As
	Begin
		Select		test_method_context.test_method_context_id,
				test_method_context.test_id
		From		test_method_context
		Where		test_method_context.test_id = @test_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_method_context_chain_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_method_context_chain_by_primary_sel
?|
?|	Description:	Selects data from table ag_test_method_context_chain_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_method_context_chain_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_method_context_chain_by_primary_sel]
(
	@test_method_context_chain_id int
)
As
	Begin
		Select		test_method_context_chain.test_method_context_chain_id,
				test_method_context_chain.test_method_context_id,
				test_method_context_chain.subtest_id,
				test_method_context_chain.test_order
		From		test_method_context_chain
		Where		test_method_context_chain.test_method_context_chain_id = @test_method_context_chain_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_method_context_chain_by_subtest_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_method_context_chain_by_subtest_id_sel
?|
?|	Description:	Selects data from table test_method_context_chain
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_method_context_chain_by_subtest_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_method_context_chain_by_subtest_id_sel]
(
	@subtest_id int

)
As
	Begin
		Select		test_method_context_chain.test_method_context_chain_id,
				test_method_context_chain.test_method_context_id,
				test_method_context_chain.subtest_id,
				test_method_context_chain.test_order
		From		test_method_context_chain
		Where		test_method_context_chain.subtest_id = @subtest_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_method_context_chain_by_test_method_context_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_method_context_chain_by_test_method_context_id_sel
?|
?|	Description:	Selects data from table test_method_context_chain
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_method_context_chain_by_test_method_context_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_method_context_chain_by_test_method_context_id_sel]
(
	@test_method_context_id int

)
As
	Begin
		Select		test_method_context_chain.test_method_context_chain_id,
				test_method_context_chain.test_method_context_id,
				test_method_context_chain.subtest_id,
				test_method_context_chain.test_order
		From		test_method_context_chain
		Where		test_method_context_chain.test_method_context_id = @test_method_context_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_method_context_chain_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_method_context_chain_del
?|
?|	Description:	Logically deletes records from the table test_method_context_chain
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_method_context_chain_id	int		=	TestMethodContextChainId
?|			@test_method_context_id	int		=	TestMethodContextId
?|			@subtest_id		int		=	SubtestId
?|			@test_order		int		=	TestOrder
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_method_context_chain_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_method_context_chain_del]
(
				@test_method_context_chain_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test_method_context_chain
			Where	test_method_context_chain_id = @test_method_context_chain_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_method_context_chain_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_method_context_chain_ins
?|
?|	Description:	Inserts new rows into the table test_method_context_chain
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_method_context_id	int		=	TestMethodContextId
?|			@subtest_id		int		=	SubtestId
?|			@test_order		int		=	TestOrder
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_test_method_context_chain_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_test_method_context_chain_ins]
(
	@test_method_context_id int,
	@subtest_id int,
	@test_order int,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	test_method_context_chain
			(
				[test_method_context_id] , 
				[subtest_id] , 
				[test_order] 
				)
				Values
				(
				@test_method_context_id , 
				@subtest_id , 
				@test_order 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_test_method_context_chain_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_method_context_chain_upd
?|
?|	Description:	Updates the table test_method_context_chain
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_method_context_chain_id	int		=	TestMethodContextChainId
?|			@test_method_context_id	int		=	TestMethodContextId
?|			@subtest_id		int		=	SubtestId
?|			@test_order		int		=	TestOrder
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_method_context_chain_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_method_context_chain_upd]
(
	@test_method_context_chain_id int,
	@test_method_context_id int,
	@subtest_id int,
	@test_order int,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	test_method_context_chain
			SET	[test_method_context_id] = @test_method_context_id,
				[subtest_id] = @subtest_id,
				[test_order] = @test_order
			Where	test_method_context_chain_id = @test_method_context_chain_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_method_context_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_method_context_del
?|
?|	Description:	Logically deletes records from the table test_method_context
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_method_context_id	int		=	TestMethodContextId
?|			@test_id		int		=	TestId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_method_context_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_method_context_del]
(
				@test_method_context_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test_method_context
			Where	test_method_context_id = @test_method_context_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_method_context_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_method_context_ins
?|
?|	Description:	Inserts new rows into the table test_method_context
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_id		int		=	TestId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_test_method_context_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_test_method_context_ins]
(
	@test_id int,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	test_method_context
			(
				[test_id] 
				)
				Values
				(
				@test_id 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_test_method_context_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_method_context_upd
?|
?|	Description:	Updates the table test_method_context
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_method_context_id	int		=	TestMethodContextId
?|			@test_id		int		=	TestId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_method_context_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_method_context_upd]
(
	@test_method_context_id int,
	@test_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	test_method_context
			SET	[test_id] = @test_id
			Where	test_method_context_id = @test_method_context_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_by_application_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_by_application_id_sel
?|
?|	Description:	Selects data from table test_plan
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_plan_by_application_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_by_application_id_sel]
(
	@application_id int

)
As
	Begin
		Select		test_plan.test_plan_id,
				test_plan.application_id,
				test_plan.name,
				test_plan.description
		From		test_plan
		Where		test_plan.application_id = @application_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_by_primary_sel
?|
?|	Description:	Selects data from table ag_test_plan_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_plan_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_by_primary_sel]
(
	@test_plan_id int
)
As
	Begin
		Select		test_plan.test_plan_id,
				test_plan.application_id,
				test_plan.name,
				test_plan.description
		From		test_plan
		Where		test_plan.test_plan_id = @test_plan_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_data_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_by_primary_sel
?|
?|	Description:	Selects data from table ag_test_plan_data_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_plan_data_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_data_by_primary_sel]
(
	@test_plan_data_id int
)
As
	Begin
		Select		test_plan_data.test_plan_data_id,
				test_plan_data.test_plan_id,
				test_plan_data.test_id,
				test_plan_data.test_user_id,
				test_plan_data.input,
				test_plan_data.output,
				test_plan_data.creation_date
		From		test_plan_data
		Where		test_plan_data.test_plan_data_id = @test_plan_data_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_data_by_test_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_by_test_id_sel
?|
?|	Description:	Selects data from table test_plan_data
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_plan_data_by_test_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_data_by_test_id_sel]
(
	@test_id int

)
As
	Begin
		Select		test_plan_data.test_plan_data_id,
				test_plan_data.test_plan_id,
				test_plan_data.test_id,
				test_plan_data.test_user_id,
				test_plan_data.input,
				test_plan_data.output,
				test_plan_data.creation_date
		From		test_plan_data
		Where		test_plan_data.test_id = @test_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_data_by_test_plan_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_by_test_plan_id_sel
?|
?|	Description:	Selects data from table test_plan_data
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_plan_data_by_test_plan_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_data_by_test_plan_id_sel]
(
	@test_plan_id int

)
As
	Begin
		Select		test_plan_data.test_plan_data_id,
				test_plan_data.test_plan_id,
				test_plan_data.test_id,
				test_plan_data.test_user_id,
				test_plan_data.input,
				test_plan_data.output,
				test_plan_data.creation_date
		From		test_plan_data
		Where		test_plan_data.test_plan_id = @test_plan_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_data_by_test_user_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_by_test_user_id_sel
?|
?|	Description:	Selects data from table test_plan_data
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_plan_data_by_test_user_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_data_by_test_user_id_sel]
(
	@test_user_id int

)
As
	Begin
		Select		test_plan_data.test_plan_data_id,
				test_plan_data.test_plan_id,
				test_plan_data.test_id,
				test_plan_data.test_user_id,
				test_plan_data.input,
				test_plan_data.output,
				test_plan_data.creation_date
		From		test_plan_data
		Where		test_plan_data.test_user_id = @test_user_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_data_context_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_context_by_primary_sel
?|
?|	Description:	Selects data from table ag_test_plan_data_context_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_plan_data_context_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_data_context_by_primary_sel]
(
	@test_plan_data_context_id int
)
As
	Begin
		Select		test_plan_data_context.test_plan_data_context_id,
				test_plan_data_context.test_id,
				test_plan_data_context.test_method_context_id
		From		test_plan_data_context
		Where		test_plan_data_context.test_plan_data_context_id = @test_plan_data_context_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_data_context_by_test_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_context_by_test_id_sel
?|
?|	Description:	Selects data from table test_plan_data_context
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_plan_data_context_by_test_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_data_context_by_test_id_sel]
(
	@test_id int

)
As
	Begin
		Select		test_plan_data_context.test_plan_data_context_id,
				test_plan_data_context.test_id,
				test_plan_data_context.test_method_context_id
		From		test_plan_data_context
		Where		test_plan_data_context.test_id = @test_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_data_context_by_test_method_context_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_context_by_test_method_context_id_sel
?|
?|	Description:	Selects data from table test_plan_data_context
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_plan_data_context_by_test_method_context_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_data_context_by_test_method_context_id_sel]
(
	@test_method_context_id int

)
As
	Begin
		Select		test_plan_data_context.test_plan_data_context_id,
				test_plan_data_context.test_id,
				test_plan_data_context.test_method_context_id
		From		test_plan_data_context
		Where		test_plan_data_context.test_method_context_id = @test_method_context_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_data_context_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_context_del
?|
?|	Description:	Logically deletes records from the table test_plan_data_context
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_plan_data_context_id	int		=	TestPlanDataContextId
?|			@test_id		int		=	TestId
?|			@test_method_context_id	int		=	TestMethodContextId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_plan_data_context_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_data_context_del]
(
				@test_plan_data_context_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test_plan_data_context
			Where	test_plan_data_context_id = @test_plan_data_context_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_data_context_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_context_ins
?|
?|	Description:	Inserts new rows into the table test_plan_data_context
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_id		int		=	TestId
?|			@test_method_context_id	int		=	TestMethodContextId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_test_plan_data_context_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_test_plan_data_context_ins]
(
	@test_id int,
	@test_method_context_id int,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	test_plan_data_context
			(
				[test_id] , 
				[test_method_context_id] 
				)
				Values
				(
				@test_id , 
				@test_method_context_id 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_data_context_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_context_upd
?|
?|	Description:	Updates the table test_plan_data_context
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_plan_data_context_id	int		=	TestPlanDataContextId
?|			@test_id		int		=	TestId
?|			@test_method_context_id	int		=	TestMethodContextId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_plan_data_context_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_data_context_upd]
(
	@test_plan_data_context_id int,
	@test_id int,
	@test_method_context_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	test_plan_data_context
			SET	[test_id] = @test_id,
				[test_method_context_id] = @test_method_context_id
			Where	test_plan_data_context_id = @test_plan_data_context_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_data_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_del
?|
?|	Description:	Logically deletes records from the table test_plan_data
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_plan_data_id	int		=	TestPlanDataId
?|			@test_plan_id		int		=	TestPlanId
?|			@test_id		int		=	TestId
?|			@test_user_id		int		=	TestUserId
?|			@input			xml		=	Input
?|			@output			xml		=	Output
?|			@creation_date		datetime		=	CreationDate
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_plan_data_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_data_del]
(
				@test_plan_data_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test_plan_data
			Where	test_plan_data_id = @test_plan_data_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_data_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_ins
?|
?|	Description:	Inserts new rows into the table test_plan_data
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_plan_id		int		=	TestPlanId
?|			@test_id		int		=	TestId
?|			@test_user_id		int		=	TestUserId
?|			@input			xml		=	Input
?|			@output			xml		=	Output
?|			@creation_date		datetime		=	CreationDate
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_test_plan_data_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_test_plan_data_ins]
(
	@test_plan_id int,
	@test_id int,
	@test_user_id int,
	@input xml,
	@output xml,
	@creation_date datetime,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	test_plan_data
			(
				[test_plan_id] , 
				[test_id] , 
				[test_user_id] , 
				[input] , 
				[output] , 
				[creation_date] 
				)
				Values
				(
				@test_plan_id , 
				@test_id , 
				@test_user_id , 
				@input , 
				@output , 
				@creation_date 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_data_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_data_upd
?|
?|	Description:	Updates the table test_plan_data
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_plan_data_id	int		=	TestPlanDataId
?|			@test_plan_id		int		=	TestPlanId
?|			@test_id		int		=	TestId
?|			@test_user_id		int		=	TestUserId
?|			@input			xml		=	Input
?|			@output			xml		=	Output
?|			@creation_date		datetime		=	CreationDate
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_plan_data_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_data_upd]
(
	@test_plan_data_id int,
	@test_plan_id int,
	@test_id int,
	@test_user_id int,
	@input xml,
	@output xml,
	@creation_date datetime,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	test_plan_data
			SET	[test_plan_id] = @test_plan_id,
				[test_id] = @test_id,
				[test_user_id] = @test_user_id,
				[input] = @input,
				[output] = @output,
				[creation_date] = @creation_date
			Where	test_plan_data_id = @test_plan_data_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_del
?|
?|	Description:	Logically deletes records from the table test_plan
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_plan_id		int		=	TestPlanId
?|			@application_id		int		=	ApplicationId
?|			@name			varchar(50)	=	Name
?|			@description		varchar(100)	=	Description
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_plan_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_del]
(
				@test_plan_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test_plan
			Where	test_plan_id = @test_plan_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_ins
?|
?|	Description:	Inserts new rows into the table test_plan
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_id		int		=	ApplicationId
?|			@name			varchar(50)	=	Name
?|			@description		varchar(100)	=	Description
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_test_plan_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_test_plan_ins]
(
	@application_id int,
	@name varchar(50),
	@description varchar(100),
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	test_plan
			(
				[application_id] , 
				[name] , 
				[description] 
				)
				Values
				(
				@application_id , 
				@name , 
				@description 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_test_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_test_by_primary_sel
?|
?|	Description:	Selects data from table ag_test_plan_test_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_plan_test_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_test_by_primary_sel]
(
	@test_plan_test_id int
)
As
	Begin
		Select		test_plan_test.test_plan_test_id,
				test_plan_test.test_plan_id,
				test_plan_test.test_id
		From		test_plan_test
		Where		test_plan_test.test_plan_test_id = @test_plan_test_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_test_by_test_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_test_by_test_id_sel
?|
?|	Description:	Selects data from table test_plan_test
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_plan_test_by_test_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_test_by_test_id_sel]
(
	@test_id int

)
As
	Begin
		Select		test_plan_test.test_plan_test_id,
				test_plan_test.test_plan_id,
				test_plan_test.test_id
		From		test_plan_test
		Where		test_plan_test.test_id = @test_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_test_by_test_plan_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_test_by_test_plan_id_sel
?|
?|	Description:	Selects data from table test_plan_test
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_plan_test_by_test_plan_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_test_by_test_plan_id_sel]
(
	@test_plan_id int

)
As
	Begin
		Select		test_plan_test.test_plan_test_id,
				test_plan_test.test_plan_id,
				test_plan_test.test_id
		From		test_plan_test
		Where		test_plan_test.test_plan_id = @test_plan_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_test_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_test_del
?|
?|	Description:	Logically deletes records from the table test_plan_test
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_plan_test_id	int		=	TestPlanTestId
?|			@test_plan_id		int		=	TestPlanId
?|			@test_id		int		=	TestId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_plan_test_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_test_del]
(
				@test_plan_test_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test_plan_test
			Where	test_plan_test_id = @test_plan_test_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_test_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_test_ins
?|
?|	Description:	Inserts new rows into the table test_plan_test
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_plan_id		int		=	TestPlanId
?|			@test_id		int		=	TestId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_test_plan_test_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_test_plan_test_ins]
(
	@test_plan_id int,
	@test_id int,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	test_plan_test
			(
				[test_plan_id] , 
				[test_id] 
				)
				Values
				(
				@test_plan_id , 
				@test_id 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_test_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_test_upd
?|
?|	Description:	Updates the table test_plan_test
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_plan_test_id	int		=	TestPlanTestId
?|			@test_plan_id		int		=	TestPlanId
?|			@test_id		int		=	TestId
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_plan_test_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_test_upd]
(
	@test_plan_test_id int,
	@test_plan_id int,
	@test_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	test_plan_test
			SET	[test_plan_id] = @test_plan_id,
				[test_id] = @test_id
			Where	test_plan_test_id = @test_plan_test_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_plan_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_plan_upd
?|
?|	Description:	Updates the table test_plan
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_plan_id		int		=	TestPlanId
?|			@application_id		int		=	ApplicationId
?|			@name			varchar(50)	=	Name
?|			@description		varchar(100)	=	Description
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_plan_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_plan_upd]
(
	@test_plan_id int,
	@application_id int,
	@name varchar(50),
	@description varchar(100),
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	test_plan
			SET	[application_id] = @application_id,
				[name] = @name,
				[description] = @description
			Where	test_plan_id = @test_plan_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_run_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_run_by_primary_sel
?|
?|	Description:	Selects data from table ag_test_run_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_run_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_run_by_primary_sel]
(
	@test_run_id int
)
As
	Begin
		Select		test_run.test_run_id,
				test_run.test_plan_id,
				test_run.run_date
		From		test_run
		Where		test_run.test_run_id = @test_run_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_run_by_test_plan_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_run_by_test_plan_id_sel
?|
?|	Description:	Selects data from table test_run
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_run_by_test_plan_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_run_by_test_plan_id_sel]
(
	@test_plan_id int

)
As
	Begin
		Select		test_run.test_run_id,
				test_run.test_plan_id,
				test_run.run_date
		From		test_run
		Where		test_run.test_plan_id = @test_plan_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_run_data_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_run_data_by_primary_sel
?|
?|	Description:	Selects data from table ag_test_run_data_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_run_data_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_run_data_by_primary_sel]
(
	@test_run_data_id int
)
As
	Begin
		Select		test_run_data.test_run_data_id,
				test_run_data.test_run_id,
				test_run_data.test_id,
				test_run_data.input,
				test_run_data.output,
				test_run_data.result,
				test_run_data.run_date
		From		test_run_data
		Where		test_run_data.test_run_data_id = @test_run_data_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_run_data_by_test_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_run_data_by_test_id_sel
?|
?|	Description:	Selects data from table test_run_data
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_run_data_by_test_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_run_data_by_test_id_sel]
(
	@test_id int

)
As
	Begin
		Select		test_run_data.test_run_data_id,
				test_run_data.test_run_id,
				test_run_data.test_id,
				test_run_data.input,
				test_run_data.output,
				test_run_data.result,
				test_run_data.run_date
		From		test_run_data
		Where		test_run_data.test_id = @test_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_run_data_by_test_run_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_run_data_by_test_run_id_sel
?|
?|	Description:	Selects data from table test_run_data
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_run_data_by_test_run_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_run_data_by_test_run_id_sel]
(
	@test_run_id int

)
As
	Begin
		Select		test_run_data.test_run_data_id,
				test_run_data.test_run_id,
				test_run_data.test_id,
				test_run_data.input,
				test_run_data.output,
				test_run_data.result,
				test_run_data.run_date
		From		test_run_data
		Where		test_run_data.test_run_id = @test_run_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_run_data_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_run_data_del
?|
?|	Description:	Logically deletes records from the table test_run_data
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_run_data_id	int		=	TestRunDataId
?|			@test_run_id		int		=	TestRunId
?|			@test_id		int		=	TestId
?|			@input			xml		=	Input
?|			@output			xml		=	Output
?|			@result			nvarchar		=	Result
?|			@run_date		datetime		=	RunDate
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_run_data_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_run_data_del]
(
				@test_run_data_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test_run_data
			Where	test_run_data_id = @test_run_data_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_run_data_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_run_data_ins
?|
?|	Description:	Inserts new rows into the table test_run_data
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_run_id		int		=	TestRunId
?|			@test_id		int		=	TestId
?|			@input			xml		=	Input
?|			@output			xml		=	Output
?|			@result			nvarchar		=	Result
?|			@run_date		datetime		=	RunDate
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_test_run_data_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_test_run_data_ins]
(
	@test_run_id int,
	@test_id int,
	@input xml,
	@output xml,
	@result nvarchar,
	@run_date datetime,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	test_run_data
			(
				[test_run_id] , 
				[test_id] , 
				[input] , 
				[output] , 
				[result] , 
				[run_date] 
				)
				Values
				(
				@test_run_id , 
				@test_id , 
				@input , 
				@output , 
				@result , 
				@run_date 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_test_run_data_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_run_data_upd
?|
?|	Description:	Updates the table test_run_data
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_run_data_id	int		=	TestRunDataId
?|			@test_run_id		int		=	TestRunId
?|			@test_id		int		=	TestId
?|			@input			xml		=	Input
?|			@output			xml		=	Output
?|			@result			nvarchar		=	Result
?|			@run_date		datetime		=	RunDate
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_run_data_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_run_data_upd]
(
	@test_run_data_id int,
	@test_run_id int,
	@test_id int,
	@input xml,
	@output xml,
	@result nvarchar,
	@run_date datetime,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	test_run_data
			SET	[test_run_id] = @test_run_id,
				[test_id] = @test_id,
				[input] = @input,
				[output] = @output,
				[result] = @result,
				[run_date] = @run_date
			Where	test_run_data_id = @test_run_data_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_run_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_run_del
?|
?|	Description:	Logically deletes records from the table test_run
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_run_id		int		=	TestRunId
?|			@test_plan_id		int		=	TestPlanId
?|			@run_date		datetime		=	RunDate
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_run_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_run_del]
(
				@test_run_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test_run
			Where	test_run_id = @test_run_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_run_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_run_ins
?|
?|	Description:	Inserts new rows into the table test_run
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_plan_id		int		=	TestPlanId
?|			@run_date		datetime		=	RunDate
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_test_run_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_test_run_ins]
(
	@test_plan_id int,
	@run_date datetime,
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	test_run
			(
				[test_plan_id] , 
				[run_date] 
				)
				Values
				(
				@test_plan_id , 
				@run_date 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_test_run_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_run_upd
?|
?|	Description:	Updates the table test_run
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_run_id		int		=	TestRunId
?|			@test_plan_id		int		=	TestPlanId
?|			@run_date		datetime		=	RunDate
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_run_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_run_upd]
(
	@test_run_id int,
	@test_plan_id int,
	@run_date datetime,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	test_run
			SET	[test_plan_id] = @test_plan_id,
				[run_date] = @run_date
			Where	test_run_id = @test_run_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_upd
?|
?|	Description:	Updates the table test
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_id		int		=	TestId
?|			@application_id		int		=	ApplicationId
?|			@application_method_id	int		=	ApplicationMethodId
?|			@application_version_id	int		=	ApplicationVersionId
?|			@default_method_input	xml		=	DefaultMethodInput
?|			@default_method_output	xml		=	DefaultMethodOutput
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_upd]
(
	@test_id int,
	@application_id int,
	@application_method_id int,
	@application_version_id int,
	@default_method_input xml,
	@default_method_output xml,
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	test
			SET	[application_id] = @application_id,
				[application_method_id] = @application_method_id,
				[application_version_id] = @application_version_id,
				[default_method_input] = @default_method_input,
				[default_method_output] = @default_method_output
			Where	test_id = @test_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_user_by_application_environment_id_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_user_by_application_environment_id_sel
?|
?|	Description:	Selects data from table test_user
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_user_by_application_environment_id_sel
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_user_by_application_environment_id_sel]
(
	@application_environment_id int

)
As
	Begin
		Select		test_user.test_user_id,
				test_user.application_environment_id,
				test_user.user_name,
				test_user.password,
				test_user.site_id,
				test_user.loc_unit
		From		test_user
		Where		test_user.application_environment_id = @application_environment_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_user_by_primary_sel]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_user_by_primary_sel
?|
?|	Description:	Selects data from table ag_test_user_by_primary_sel_by primary key
?|
?|	@Author:	Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@return:     	Select statement results
?|
?|	example		exec ag_test_user_by_primary_sel;
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_user_by_primary_sel]
(
	@test_user_id int
)
As
	Begin
		Select		test_user.test_user_id,
				test_user.application_environment_id,
				test_user.user_name,
				test_user.password,
				test_user.site_id,
				test_user.loc_unit
		From		test_user
		Where		test_user.test_user_id = @test_user_id

;
	END
GO
/****** Object:  StoredProcedure [dbo].[ag_test_user_del]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_user_del
?|
?|	Description:	Logically deletes records from the table test_user
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_user_id		int		=	TestUserId
?|			@application_environment_id	int		=	ApplicationEnvironmentId
?|			@user_name		varchar(100)	=	UserName
?|			@password		varchar(100)	=	Password
?|			@site_id		int		=	SiteId
?|			@loc_unit		char(6)		=	LocUnit
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_user_del
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_user_del]
(
				@test_user_id int,
	@arg_user_id varchar(100)
)
As
	Begin
			Delete From test_user
			Where	test_user_id = @test_user_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[ag_test_user_ins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_user_ins
?|
?|	Description:	Inserts new rows into the table test_user
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@application_environment_id	int		=	ApplicationEnvironmentId
?|			@user_name		varchar(100)	=	UserName
?|			@password		varchar(100)	=	Password
?|			@site_id		int		=	SiteId
?|			@loc_unit		char(6)		=	LocUnit
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@rowcount - 1 if add is a success
?|
?|	example:	exec ag_test_user_ins
?|
????????????????????????????????????????????????????????????????????
*/
CREATE PROCEDURE [dbo].[ag_test_user_ins]
(
	@application_environment_id int,
	@user_name varchar(100),
	@password varchar(100),
	@site_id int,
	@loc_unit char(6),
	@arg_user_id varchar(100)
)
AS
	BEGIN
			INSERT	INTO	test_user
			(
				[application_environment_id] , 
				[user_name] , 
				[password] , 
				[site_id] , 
				[loc_unit] 
				)
				Values
				(
				@application_environment_id , 
				@user_name , 
				@password , 
				@site_id , 
				@loc_unit 
			);
			select @@identity;

	END

GO
/****** Object:  StoredProcedure [dbo].[ag_test_user_upd]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
??????????????????????????????????????????????????????????????????????
?|
?|	Procedure Name:	ag_test_user_upd
?|
?|	Description:	Updates the table test_user
?|
?|	@Author:		Auto Generated
?|	@Createdate:	2/13/2018
?|
?|	@Input Param: 	@test_user_id		int		=	TestUserId
?|			@application_environment_id	int		=	ApplicationEnvironmentId
?|			@user_name		varchar(100)	=	UserName
?|			@password		varchar(100)	=	Password
?|			@site_id		int		=	SiteId
?|			@loc_unit		char(6)		=	LocUnit
?|			@arg_user_id		varchar(100)		=	OpCode
?|
?|	@return:     	select @@Rowcount - 1 if update is a success
?|
?|	example	exec ag_test_user_upd
?|
????????????????????????????????????????????????????????????????????
*/
Create Procedure [dbo].[ag_test_user_upd]
(
	@test_user_id int,
	@application_environment_id int,
	@user_name varchar(100),
	@password varchar(100),
	@site_id int,
	@loc_unit char(6),
	@arg_user_id varchar(100)
)
As
	Begin
			UPDATE	test_user
			SET	[application_environment_id] = @application_environment_id,
				[user_name] = @user_name,
				[password] = @password,
				[site_id] = @site_id,
				[loc_unit] = @loc_unit
			Where	test_user_id = @test_user_id;

			select @@rowcount;

	End
GO
/****** Object:  StoredProcedure [dbo].[MAINT_fix_Logins]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[MAINT_fix_Logins]
AS
DECLARE @name VARCHAR(50)

DECLARE curUsers 
	CURSOR FOR 
		SELECT u.name --, p.name
		FROM sys.sysusers u                                 --users in the database
        JOIN sys.server_principals p ON u.name = p.name     -- that have server logins
		WHERE u.hasdbaccess = 1
        AND uid > 4
	
OPEN curUsers 

FETCH NEXT FROM curUsers INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'exec sp_change_users_login ''auto_fix'',''' + @name + ''', NULL'
    exec sp_change_users_login 'auto_fix', @name, NULL
    
	FETCH NEXT FROM curUsers INTO @name
END
CLOSE curUsers 
DEALLOCATE curUsers 



GO
/****** Object:  StoredProcedure [dbo].[SqlToASCX]    Script Date: 2/22/2019 2:48:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SqlToASCX]	(
	@arg_tableName VARCHAR(max) ,
   @ResultCS VARCHAR(Max) OUTPUT,
   @ResultHTML VARCHAR(Max) OUTPUT)
AS
BEGIN
	
declare @TableName sysname = @arg_tableName
declare @TableCamel varchar(max) = replace(dbo.CamelCase(@TableName),'_','');

 set @ResultCS = 'using System;

public partial class TestAutomationControls_' + @TableCamel + ' : System.Web.UI.UserControl
{
'

select @ResultCS = @ResultCS + '
    public ' + ColumnType + NullableSign + ' Input' + replace(dbo.CamelCase(ColumnName),'_','') + ' { get; set; }

'
from
(
    select 
        replace(col.name, ' ', '_') ColumnName,
        column_id ColumnId,
        case typ.name 
            when 'bigint' then 'long'
            when 'binary' then 'byte[]'
            when 'bit' then 'bool'
            when 'char' then 'string'
            when 'date' then 'DateTime'
            when 'datetime' then 'DateTime'
            when 'datetime2' then 'DateTime'
            when 'datetimeoffset' then 'DateTimeOffset'
            when 'decimal' then 'decimal'
            when 'float' then 'float'
            when 'image' then 'byte[]'
            when 'int' then 'int'
            when 'money' then 'decimal'
            when 'nchar' then 'string'
            when 'ntext' then 'string'
            when 'numeric' then 'decimal'
            when 'nvarchar' then 'string'
            when 'real' then 'double'
            when 'smalldatetime' then 'DateTime'
            when 'smallint' then 'short'
            when 'smallmoney' then 'decimal'
            when 'text' then 'string'
            when 'time' then 'TimeSpan'
            when 'timestamp' then 'DateTime'
            when 'tinyint' then 'byte'
            when 'uniqueidentifier' then 'Guid'
            when 'varbinary' then 'byte[]'
            when 'varchar' then 'string'
            when 'XML' then 'XmlDocument'
            else 'UNKNOWN_' + typ.name
        end ColumnType,
        case 
            when col.is_nullable = 1 and typ.name in ('bigint', 'bit', 'date', 'datetime', 'datetime2', 'datetimeoffset', 'decimal', 'float', 'int', 'money', 'numeric', 'real', 'smalldatetime', 'smallint', 'smallmoney', 'time', 'tinyint', 'uniqueidentifier') 
            then '?' 
            else '' 
        end NullableSign
    from sys.columns col
        join sys.types typ on
            col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
    where object_id = object_id(@TableName)
) t
order by ColumnId

set @ResultCS = @ResultCS  + '

    protected void Page_Load(object sender, EventArgs e)
    {
        '
select @ResultCS = @ResultCS +'
    '+replace(dbo.CamelCase(ColumnName),'_','') + '.Value = Input' + replace(dbo.CamelCase(ColumnName),'_','') + '.ToString();

'
from
(
    select 
        replace(col.name, ' ', '_') ColumnName,
        column_id ColumnId,
        case typ.name 
            when 'bigint' then 'long'
            when 'binary' then 'byte[]'
            when 'bit' then 'bool'
            when 'char' then 'string'
            when 'date' then 'DateTime'
            when 'datetime' then 'DateTime'
            when 'datetime2' then 'DateTime'
            when 'datetimeoffset' then 'DateTimeOffset'
            when 'decimal' then 'decimal'
            when 'float' then 'float'
            when 'image' then 'byte[]'
            when 'int' then 'int'
            when 'money' then 'decimal'
            when 'nchar' then 'string'
            when 'ntext' then 'string'
            when 'numeric' then 'decimal'
            when 'nvarchar' then 'string'
            when 'real' then 'double'
            when 'smalldatetime' then 'DateTime'
            when 'smallint' then 'short'
            when 'smallmoney' then 'decimal'
            when 'text' then 'string'
            when 'time' then 'TimeSpan'
            when 'timestamp' then 'DateTime'
            when 'tinyint' then 'byte'
            when 'uniqueidentifier' then 'Guid'
            when 'varbinary' then 'byte[]'
            when 'varchar' then 'string'
            when 'XML' then 'XmlDocument'
            else 'UNKNOWN_' + typ.name
        end ColumnType,
        case 
            when col.is_nullable = 1 and typ.name in ('bigint', 'bit', 'date', 'datetime', 'datetime2', 'datetimeoffset', 'decimal', 'float', 'int', 'money', 'numeric', 'real', 'smalldatetime', 'smallint', 'smallmoney', 'time', 'tinyint', 'uniqueidentifier') 
            then '?' 
            else '' 
        end NullableSign
    from sys.columns col
        join sys.types typ on
            col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
    where object_id = object_id(@TableName)
) t
order by ColumnId
		
set @ResultCS = @ResultCS  + '
    }
}
'

set @ResultHTML = '
<%@ Control Language="C#" AutoEventWireup="true" CodeFile="'+ @TableCamel+'.ascx.cs" Inherits="TestAutomationControls_'+ @TableCamel+'" %>

<form>';

select @ResultHTML = @ResultHTML + '
  <div class="form-group row">
    <label for="input_' + ColumnName + '" class="col-sm-2 col-form-label">' + replace(dbo.CamelCase(ColumnName),'_',' ')  + '</label>
    <div class="col-sm-10">
      <input type="text" runat="server" class="form-control" id="' + replace(dbo.CamelCase(ColumnName),'_','')  + '">
    </div>
  </div>
'
from
(
    select 
        replace(col.name, ' ', '_') ColumnName,
        column_id ColumnId,
        case typ.name 
            when 'bigint' then 'long'
            when 'binary' then 'byte[]'
            when 'bit' then 'bool'
            when 'char' then 'string'
            when 'date' then 'DateTime'
            when 'datetime' then 'DateTime'
            when 'datetime2' then 'DateTime'
            when 'datetimeoffset' then 'DateTimeOffset'
            when 'decimal' then 'decimal'
            when 'float' then 'float'
            when 'image' then 'byte[]'
            when 'int' then 'int'
            when 'money' then 'decimal'
            when 'nchar' then 'string'
            when 'ntext' then 'string'
            when 'numeric' then 'decimal'
            when 'nvarchar' then 'string'
            when 'real' then 'double'
            when 'smalldatetime' then 'DateTime'
            when 'smallint' then 'short'
            when 'smallmoney' then 'decimal'
            when 'text' then 'string'
            when 'time' then 'TimeSpan'
            when 'timestamp' then 'DateTime'
            when 'tinyint' then 'byte'
            when 'uniqueidentifier' then 'Guid'
            when 'varbinary' then 'byte[]'
            when 'varchar' then 'string'
            when 'XML' then 'XmlDocument'
            else 'UNKNOWN_' + typ.name
        end ColumnType,
        case 
            when col.is_nullable = 1 and typ.name in ('bigint', 'bit', 'date', 'datetime', 'datetime2', 'datetimeoffset', 'decimal', 'float', 'int', 'money', 'numeric', 'real', 'smalldatetime', 'smallint', 'smallmoney', 'time', 'tinyint', 'uniqueidentifier') 
            then '?' 
            else '' 
        end NullableSign
    from sys.columns col
        join sys.types typ on
            col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
    where object_id = object_id(@TableName)
) t
order by ColumnId

set @ResultHTML = @ResultHTML  + '</form>
'


END
GO
USE [master]
GO
ALTER DATABASE [TestAutomation] SET  READ_WRITE 
GO
