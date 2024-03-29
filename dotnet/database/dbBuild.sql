USE [master]
GO

--drop database if it exists
IF DB_ID('final_capstone') IS NOT NULL
BEGIN
	ALTER DATABASE final_capstone SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE final_capstone;
END

/****** Object:  Database [final_capstone]    Script Date: 12/11/2023 9:55:43 AM ******/
CREATE DATABASE [final_capstone]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'final_capstone', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\final_capstone.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'final_capstone_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\final_capstone_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [final_capstone] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [final_capstone].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [final_capstone] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [final_capstone] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [final_capstone] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [final_capstone] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [final_capstone] SET ARITHABORT OFF 
GO
ALTER DATABASE [final_capstone] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [final_capstone] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [final_capstone] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [final_capstone] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [final_capstone] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [final_capstone] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [final_capstone] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [final_capstone] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [final_capstone] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [final_capstone] SET  ENABLE_BROKER 
GO
ALTER DATABASE [final_capstone] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [final_capstone] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [final_capstone] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [final_capstone] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [final_capstone] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [final_capstone] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [final_capstone] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [final_capstone] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [final_capstone] SET  MULTI_USER 
GO
ALTER DATABASE [final_capstone] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [final_capstone] SET DB_CHAINING OFF 
GO
ALTER DATABASE [final_capstone] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [final_capstone] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [final_capstone] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [final_capstone] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [final_capstone] SET QUERY_STORE = OFF
GO
USE [final_capstone]
GO
/****** Object:  Table [dbo].[departments]    Script Date: 12/11/2023 9:55:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[departments](
	[department_id] [int] IDENTITY(0,1) NOT NULL,
	[department_name] [varchar](50) NOT NULL,
	[is_active] [bit] NOT NULL,
 CONSTRAINT [PK_department] PRIMARY KEY CLUSTERED 
(
	[department_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[items]    Script Date: 12/11/2023 9:55:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[items](
	[item_id] [int] IDENTITY(1,1) NOT NULL,
	[item_name] [varchar](256) NOT NULL,
	[item_description] [nvarchar](max) NULL,
	[item_image_url] [varchar](2048) NULL,
	[is_tracked_inventory] [bit] NOT NULL,
	[created_by_user_id] [int] NOT NULL,
	[created_date_utc] [datetime] NOT NULL,
	[last_modified_by_user_id] [int] NOT NULL,
	[last_modified_date_utc] [datetime] NOT NULL,
	[is_active] [bit] NOT NULL,
 CONSTRAINT [PK_items] PRIMARY KEY CLUSTERED 
(
	[item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[list_item_statuses]    Script Date: 12/11/2023 9:55:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[list_item_statuses](
	[list_item_status_id] [int] IDENTITY(1,1) NOT NULL,
	[list_item_status_name] [varchar](25) NOT NULL,
 CONSTRAINT [PK_list_item_status] PRIMARY KEY CLUSTERED 
(
	[list_item_status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[list_items]    Script Date: 12/11/2023 9:55:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[list_items](
	[list_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[list_item_claimed_by_user_id] [int] NULL,
	[list_item_status_id] [int] NOT NULL,
	[created_date_utc] [datetime] NOT NULL,
	[last_modified_by_user_id] [int] NOT NULL,
	[last_modified_date_utc] [datetime] NOT NULL,
	[is_active] [bit] NOT NULL,
 CONSTRAINT [PK_list_items] PRIMARY KEY CLUSTERED 
(
	[list_id] ASC,
	[item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[list_statuses]    Script Date: 12/11/2023 9:55:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[list_statuses](
	[list_status_id] [int] IDENTITY(1,1) NOT NULL,
	[list_status_name] [varchar](25) NOT NULL,
 CONSTRAINT [PK_list_status] PRIMARY KEY CLUSTERED 
(
	[list_status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lists]    Script Date: 12/11/2023 9:55:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lists](
	[list_id] [int] IDENTITY(1,1) NOT NULL,
	[list_name] [varchar](100) NOT NULL,
	[department_id] [int] NOT NULL,
	[list_status_id] [int] NOT NULL,
	[list_owner_user_id] [int] NOT NULL,
	[due_date_utc] [datetime] NOT NULL,
	[created_date_utc] [datetime] NOT NULL,
	[last_modified_date_utc] [datetime] NOT NULL,
	[is_active] [bit] NOT NULL,
 CONSTRAINT [PK_list] PRIMARY KEY CLUSTERED 
(
	[list_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 12/11/2023 9:55:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[first_name] [varchar](50) NOT NULL,
	[last_name] [varchar](50) NOT NULL,
	[department_id] [int] NOT NULL,
	[password_hash] [varchar](200) NOT NULL,
	[salt] [varchar](200) NOT NULL,
	[user_role] [varchar](50) NOT NULL,
	[avatar_url] [varchar](2048) NULL,
	[is_active] [bit] NOT NULL,
	[created_date_utc] [datetime] NOT NULL,
 CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users_lists]    Script Date: 12/11/2023 9:55:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users_lists](
	[user_id] [int] NOT NULL,
	[list_id] [int] NOT NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[departments] ON 

INSERT [dbo].[departments] ([department_id], [department_name], [is_active]) VALUES (0, N'Boss Hogs', 1) 
INSERT [dbo].[departments] ([department_id], [department_name], [is_active]) VALUES (1, N'Engineering', 1)
INSERT [dbo].[departments] ([department_id], [department_name], [is_active]) VALUES (2, N'Sales', 1)
INSERT [dbo].[departments] ([department_id], [department_name], [is_active]) VALUES (3, N'Customer Success', 1)
INSERT [dbo].[departments] ([department_id], [department_name], [is_active]) VALUES (4, N'Product/Marketing', 1)
INSERT [dbo].[departments] ([department_id], [department_name], [is_active]) VALUES (5, N'Finance', 1)
SET IDENTITY_INSERT [dbo].[departments] OFF
GO
SET IDENTITY_INSERT [dbo].[items] ON 

INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (1, N'Keep Austin Weird T-Shirt', N'Any kind of Keep Austin Weird T-shirt - be sure to check with user for size/style preferences', N'https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcTNXfM8kHzW5CM4qxsK0z_HxlxwpAbwVs_b4UU_RxuJeHmtV6V1CXokAEzvcrXXit3VqWkh435DEB69AmfnF8-dhswDho0q', 0, 1, CAST(N'2023-12-10T18:49:10.450' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.450' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (2, N'Cowboy Hat', N'Our preferred vendor is American Hat Makers', N'https://americanhatmakers.com/cdn/shop/products/austin-cream-f_1.jpg?v=1668703888&width=1000', 0, 1, CAST(N'2023-12-10T18:49:10.450' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.450' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (3, N'Big Truck', N'Any model as long as it is American made', N'https://www.motortrend.com/uploads/sites/2/2020/08/007-2017-ford-f450-super-duty.jpg', 0, 1, CAST(N'2023-12-10T18:49:10.450' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.450' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (4, N'Engineering Grade Laptop (Dell)', N'Check with IT for the current specs and order direct from the Dell website', N'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-15-9530/media-gallery/touch-black/notebook-xps-15-9530-t-black-gallery-5.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=677&qlt=100,1&resMode=sharp2&size=677,402&chrss=full', 0, 1, CAST(N'2023-12-10T18:49:10.450' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.450' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (5, N'Hot Sauce Set', N'set of different flavors of Texan hot sauce', N'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.texasfood.com%2FTexas-Hot-Sauce-Build-a-Box.html&psig=AOvVaw3wnf2J_LXVrpxQEvq9DjuZ&ust=1702322615351000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCNi2v4fMhYMDFQAAAAAdAAAAABAE', 0, 2, CAST(N'2023-12-10T14:27:25.797' AS DateTime), 2, CAST(N'2023-12-10T14:27:25.797' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (6, N'SXSW Poster 2023', N'Wall art poster print for SXSW 2023', N'https://www.google.com/url?sa=i&url=https%3A%2F%2Fmerch.sxsw.com%2Fproducts%2F2023-sxsw-poster&psig=AOvVaw0jHxescEq5afwHIbM1yLYE&ust=1702323061908000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCMj0rNzNhYMDFQAAAAAdAAAAABAG ', 0, 2, CAST(N'2023-12-10T14:32:37.083' AS DateTime), 2, CAST(N'2023-12-10T14:32:37.083' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (7, N'Austin City Limits Vinyl Record', N'Vinyl record of any artist performing live from Austin City Limits', N'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.ebay.com%2Fp%2F5042767231&psig=AOvVaw0RCGd6ugOsWMUsD3NtH4k6&ust=1702323244315000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPi0qLbOhYMDFQAAAAAdAAAAABAV ', 0, 2, CAST(N'2023-12-10T14:36:04.073' AS DateTime), 2, CAST(N'2023-12-10T14:36:04.073' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (8, N'The Austin Cookbook', N'Cookbook of recipes and stories from deep in the heart of Texas. ', N'https://prodimage.images-bn.com/lf?set=key%5Bresolve.pixelRatio%5D,value%5B1%5D&set=key%5Bresolve.width%5D,value%5B600%5D&set=key%5Bresolve.height%5D,value%5B10000%5D&set=key%5Bresolve.imageFit%5D,value%5Bcontainerwidth%5D&set=key%5Bresolve.allowImageUpscaling%5D,value%5B0%5D&set=key%5Bresolve.format%5D,value%5Bwebp%5D&source=url%5Bhttps://prodimage.images-bn.com/pimages/9781419728938_p0_v2_s600x595.jpg%5D&scale=options%5Blimit%5D,size%5B600x10000%5D&sink=format%5Bwebp%5D ', 0, 2, CAST(N'2023-12-10T14:41:36.590' AS DateTime), 2, CAST(N'2023-12-10T14:41:36.590' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (9, N'Sustainable Hiking Boots', N'Sustainable hiking boots from any eco-friendly brand ', N'https://www.sustainablejungle.com/wp-content/uploads/2023/04/Images-by-Erem-1-1024x667.jpg ', 0, 2, CAST(N'2023-12-10T14:46:48.570' AS DateTime), 2, CAST(N'2023-12-10T14:46:48.570' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (10, N'6-pack of Austin Craft Beer', N'6-pack of craft beer from Austin Beerworks ', N'https://assets0.dostuffmedia.com/uploads/aws_asset/aws_asset/6057099/9835b2ca-ef50-4a5f-b8ba-df133f916747.png ', 0, 2, CAST(N'2023-12-10T14:49:42.507' AS DateTime), 2, CAST(N'2023-12-10T14:49:42.507' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (11, N'Austin Bats Snow Globe', N'Austin Bats Snow Globe from Texas Capitol Gift Shop ', N'https://www.texascapitolgiftshop.com/mas_assets/cache/image/2/4/a/6/750x-9382.Jpg ', 0, 2, CAST(N'2023-12-10T14:52:16.743' AS DateTime), 2, CAST(N'2023-12-10T14:52:16.743' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (12, N'Western Leather Belt', N'Leather belt with excessively large buckle from any brand', N'https://m.media-amazon.com/images/W/MEDIAX_792452-T2/images/I/71ltCdt06zL._AC_SX569_.jpg ', 0, 2, CAST(N'2023-12-10T14:56:27.687' AS DateTime), 2, CAST(N'2023-12-10T14:56:27.687' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (13, N'Gun Safe', NULL, N'https://www.cothrons.com/uploads/1/0/8/3/108367487/bf1716-lg-f-pw-closed-hv-481_orig.png ', 0, 2, CAST(N'2023-12-10T15:00:12.423' AS DateTime), 2, CAST(N'2023-12-10T15:00:12.423' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (14, N'Mustache Grooming Kit', N'Mustache grooming kit with scissors, wax, and comb', N'https://images.squarespace-cdn.com/content/v1/5dbdb977739dc2113954e2b5/1622831858057-81J7V1751QYM8MIQZKS0/moustache+Kit2.jpg ', 0, 2, CAST(N'2023-12-10T15:02:07.773' AS DateTime), 2, CAST(N'2023-12-10T15:02:07.773' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (15, N'Specialty Whole Bean Coffee', N'16oz bag of Organic Fair Trade Whole Bean Coffee, any flavor', N'https://www.thirdcoastcoffee.com/cdn/shop/products/cnq_900x.png?v=1672773785', 0, 2, CAST(N'2023-12-10T15:07:03.097' AS DateTime), 2, CAST(N'2023-12-10T15:07:03.097' AS DateTime), 1)
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (16, N'Texas Flag Acoustic Guitar', NULL, N'https://i5.walmartimages.com/seo/Main-Street-Guitars-MATXF-Dreadnought-Acoustic-Guitar-with-Texas-Flag-on-High-Gloss-White-Finish_77f92203-11d6-4b1e-a70b-b622263dada8_1.f15891402f2f7888501d14ce70258783.jpeg?odnHeight=2000&odnWidth=2000&odnBg=FFFFFF', 0, 2, CAST(N'2023-12-10T15:11:11.687' AS DateTime), 2, CAST(N'2023-12-10T15:11:11.687' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[items] OFF
GO
SET IDENTITY_INSERT [dbo].[list_item_statuses] ON 

INSERT [dbo].[list_item_statuses] ([list_item_status_id], [list_item_status_name]) VALUES (1, N'Needed')
INSERT [dbo].[list_item_statuses] ([list_item_status_id], [list_item_status_name]) VALUES (2, N'Claimed')
INSERT [dbo].[list_item_statuses] ([list_item_status_id], [list_item_status_name]) VALUES (3, N'Purchased')
SET IDENTITY_INSERT [dbo].[list_item_statuses] OFF
GO
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (1, 1, 1, NULL, 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (1, 2, 1, NULL, 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (1, 3, 1, NULL, 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (1, 4, 1, NULL, 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (2, 1, 1, NULL, 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (2, 2, 1, NULL, 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (2, 3, 1, NULL, 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (3, 4, 1, NULL, 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[list_statuses] ON 

INSERT [dbo].[list_statuses] ([list_status_id], [list_status_name]) VALUES (1, N'Draft')
INSERT [dbo].[list_statuses] ([list_status_id], [list_status_name]) VALUES (2, N'In Progress')
INSERT [dbo].[list_statuses] ([list_status_id], [list_status_name]) VALUES (3, N'Complete')
SET IDENTITY_INSERT [dbo].[list_statuses] OFF
GO
SET IDENTITY_INSERT [dbo].[lists] ON 

INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (1, N'Mimi Malone', 1, 1, 1, CAST(N'2023-12-17T18:49:10.447' AS DateTime), CAST(N'2023-12-10T18:49:10.447' AS DateTime), CAST(N'2023-12-10T18:49:10.447' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (2, N'Henry Edwards', 1, 2, 1, CAST(N'2023-12-17T18:49:10.450' AS DateTime), CAST(N'2023-12-10T18:49:10.450' AS DateTime), CAST(N'2023-12-10T18:49:10.450' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (3, N'Douglas Adams', 1, 3, 1, CAST(N'2023-12-17T18:49:10.450' AS DateTime), CAST(N'2023-12-10T18:49:10.450' AS DateTime), CAST(N'2023-12-10T18:49:10.450' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (6, N'Mister President', 2, 2, 1, CAST(N'2023-12-11T09:23:45.660' AS DateTime), CAST(N'2023-12-11T09:23:45.660' AS DateTime), CAST(N'2023-12-11T09:23:45.660' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (7, N'Mister President', 5, 2, 1, CAST(N'2023-12-11T09:24:17.687' AS DateTime), CAST(N'2023-12-11T09:24:17.687' AS DateTime), CAST(N'2023-12-11T09:24:17.687' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[lists] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (1, N'user', N'Regular', N'User', 1, N'Jg45HuwT7PZkfuKTz6IB90CtWY4=', N'LHxP4Xh7bN0=', N'user', N'https://api.dicebear.com/7.x/personas/svg?seed=RegularUser', 1, CAST(N'2023-12-10T18:49:10.447' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (2, N'admin', N'Admin', N'User', 0, N'YhyGVQ+Ch69n4JMBncM4lNF/i9s=', N'Ar/aB2thQTI=', N'admin', N'https://api.dicebear.com/7.x/personas/svg?seed=AdminUser', 1, CAST(N'2023-12-10T18:49:10.447' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (3, N'spaceman44', N'Matthew', N'McConaughey', 2, N'+X1KL6ohKIJ8rKVZwq1YIfAIXDs=', N'KqZYJJvZS8k=', N'user', N'https://api.dicebear.com/7.x/initials/svg?seed=MM8623', 1, CAST(N'2023-12-10T18:55:26.970' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (4, N'natalie', N'natalie', N'natalie', 1, N'HAOgFykRIY2B8z0YHSSEehX4sc0=', N'tMNLmKPgN4I=', N'user', N'https://api.dicebear.com/7.x/initials/svg?seed=nn5492', 1, CAST(N'2023-12-10T18:56:50.373' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (5, N'hutner', N'hutner', N'hutner', 3, N'7b9w/Gme0thGwEVe0Bmsoxq6VLA=', N'nxHgOdrtzHo=', N'user', N'https://api.dicebear.com/7.x/initials/svg?seed=hh1211', 1, CAST(N'2023-12-10T18:57:41.647' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (6, N'outlaw1933', N'Willie', N'Nelson ', 4, N'34XL8dmWjToIEZt9lytVtI8Yg6w=', N'xrbOaSpMQgM=', N'user', N'https://api.dicebear.com/7.x/initials/svg?seed=WN3810', 1, CAST(N'2023-12-10T18:58:55.177' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (7, N'Jschmoe', N'Joe', N'Schmoe', 3, N'SwYDY6K49L6afaTP32PUbPXjmHQ=', N'jjZcyArsByo=', N'user', N'https://api.dicebear.com/7.x/initials/svg?seed=JS6479', 0, CAST(N'2023-12-10T18:59:59.320' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (8, N'fruitKing47', N'Chiquita', N'Banana', 5, N'WyqMhUleYTL0XYVzoEiWjx8B0v8=', N'ksJT1e5M/dg=', N'user', N'https://api.dicebear.com/7.x/initials/svg?seed=CB2580', 1, CAST(N'2023-12-10T19:02:03.347' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (9, N'bobbySalesman', N'Bobby ', N'Tables', 2, N'Ri67g4wJUjLogRnOINw2Uj86a64=', N'q1VT6609h0k=', N'user', N'https://api.dicebear.com/7.x/initials/svg?seed=BT8421', 0, CAST(N'2023-12-10T19:03:56.473' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (10, N'mrBoss', N'Boss', N'Boss', 5, N'd1J+ZFZ/vyyX3RarAhW6IjFRniI=', N'8BtFJQ0N3/s=', N'user', N'https://api.dicebear.com/7.x/initials/svg?seed=BB1612', 1, CAST(N'2023-12-10T19:17:21.987' AS DateTime))
SET IDENTITY_INSERT [dbo].[users] OFF
GO
ALTER TABLE [dbo].[departments] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[items] ADD  DEFAULT ((0)) FOR [is_tracked_inventory]
GO
ALTER TABLE [dbo].[items] ADD  DEFAULT (getutcdate()) FOR [created_date_utc]
GO
ALTER TABLE [dbo].[items] ADD  DEFAULT (getutcdate()) FOR [last_modified_date_utc]
GO
ALTER TABLE [dbo].[items] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[list_items] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[list_items] ADD  DEFAULT (getutcdate()) FOR [created_date_utc]
GO
ALTER TABLE [dbo].[list_items] ADD  DEFAULT (getutcdate()) FOR [last_modified_date_utc]
GO
ALTER TABLE [dbo].[list_items] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[lists] ADD  DEFAULT (dateadd(week,(1),getutcdate())) FOR [due_date_utc]
GO
ALTER TABLE [dbo].[lists] ADD  DEFAULT (getutcdate()) FOR [created_date_utc]
GO
ALTER TABLE [dbo].[lists] ADD  DEFAULT (getutcdate()) FOR [last_modified_date_utc]
GO
ALTER TABLE [dbo].[lists] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getutcdate()) FOR [created_date_utc]
GO
ALTER TABLE [dbo].[items]  WITH CHECK ADD  CONSTRAINT [FK_items_users_created] FOREIGN KEY([created_by_user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[items] CHECK CONSTRAINT [FK_items_users_created]
GO
ALTER TABLE [dbo].[items]  WITH CHECK ADD  CONSTRAINT [FK_items_users_modified] FOREIGN KEY([last_modified_by_user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[items] CHECK CONSTRAINT [FK_items_users_modified]
GO
ALTER TABLE [dbo].[list_items]  WITH CHECK ADD  CONSTRAINT [FK_list_items_items] FOREIGN KEY([item_id])
REFERENCES [dbo].[items] ([item_id])
GO
ALTER TABLE [dbo].[list_items] CHECK CONSTRAINT [FK_list_items_items]
GO
ALTER TABLE [dbo].[list_items]  WITH CHECK ADD  CONSTRAINT [FK_list_items_list_item_statues] FOREIGN KEY([list_item_status_id])
REFERENCES [dbo].[list_item_statuses] ([list_item_status_id])
GO
ALTER TABLE [dbo].[list_items] CHECK CONSTRAINT [FK_list_items_list_item_statues]
GO
ALTER TABLE [dbo].[list_items]  WITH CHECK ADD  CONSTRAINT [FK_list_items_lists] FOREIGN KEY([list_id])
REFERENCES [dbo].[lists] ([list_id])
GO
ALTER TABLE [dbo].[list_items] CHECK CONSTRAINT [FK_list_items_lists]
GO
ALTER TABLE [dbo].[list_items]  WITH CHECK ADD  CONSTRAINT [FK_list_items_users_claimed] FOREIGN KEY([list_item_claimed_by_user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[list_items] CHECK CONSTRAINT [FK_list_items_users_claimed]
GO
ALTER TABLE [dbo].[list_items]  WITH CHECK ADD  CONSTRAINT [FK_list_items_users_modified] FOREIGN KEY([last_modified_by_user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[list_items] CHECK CONSTRAINT [FK_list_items_users_modified]
GO
ALTER TABLE [dbo].[lists]  WITH CHECK ADD  CONSTRAINT [FK_lists_departments] FOREIGN KEY([department_id])
REFERENCES [dbo].[departments] ([department_id])
GO
ALTER TABLE [dbo].[lists] CHECK CONSTRAINT [FK_lists_departments]
GO
ALTER TABLE [dbo].[lists]  WITH CHECK ADD  CONSTRAINT [FK_lists_list_status] FOREIGN KEY([list_status_id])
REFERENCES [dbo].[list_statuses] ([list_status_id])
GO
ALTER TABLE [dbo].[lists] CHECK CONSTRAINT [FK_lists_list_status]
GO
ALTER TABLE [dbo].[lists]  WITH CHECK ADD  CONSTRAINT [FK_lists_users] FOREIGN KEY([list_owner_user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[lists] CHECK CONSTRAINT [FK_lists_users]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [FK_users_departments] FOREIGN KEY([department_id])
REFERENCES [dbo].[departments] ([department_id])
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [FK_users_departments]
GO
ALTER TABLE [dbo].[users_lists]  WITH CHECK ADD  CONSTRAINT [FK_users_lists_lists] FOREIGN KEY([list_id])
REFERENCES [dbo].[lists] ([list_id])
GO
ALTER TABLE [dbo].[users_lists] CHECK CONSTRAINT [FK_users_lists_lists]
GO
ALTER TABLE [dbo].[users_lists]  WITH CHECK ADD  CONSTRAINT [FK_users_lists_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[users_lists] CHECK CONSTRAINT [FK_users_lists_users]
GO
USE [master]
GO
ALTER DATABASE [final_capstone] SET  READ_WRITE 
GO
