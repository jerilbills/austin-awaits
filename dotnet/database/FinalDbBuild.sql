USE [master]
GO

IF DB_ID('final_capstone') IS NOT NULL
BEGIN
	ALTER DATABASE final_capstone SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE final_capstone;
END

/****** Object:  Database [final_capstone]    Script Date: 12/14/2023 2:33:39 PM ******/
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
/****** Object:  Table [dbo].[departments]    Script Date: 12/14/2023 2:33:39 PM ******/
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
/****** Object:  Table [dbo].[items]    Script Date: 12/14/2023 2:33:39 PM ******/
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
/****** Object:  Table [dbo].[list_item_statuses]    Script Date: 12/14/2023 2:33:39 PM ******/
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
/****** Object:  Table [dbo].[list_items]    Script Date: 12/14/2023 2:33:39 PM ******/
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
/****** Object:  Table [dbo].[list_statuses]    Script Date: 12/14/2023 2:33:39 PM ******/
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
/****** Object:  Table [dbo].[lists]    Script Date: 12/14/2023 2:33:39 PM ******/
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
/****** Object:  Table [dbo].[users]    Script Date: 12/14/2023 2:33:39 PM ******/
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
/****** Object:  Table [dbo].[users_lists]    Script Date: 12/14/2023 2:33:39 PM ******/
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
INSERT [dbo].[items] ([item_id], [item_name], [item_description], [item_image_url], [is_tracked_inventory], [created_by_user_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (17, N'Mouse Pad', N'Just a mouse pad.', N'https://rlv.zcache.com/austin_texas_city_skyline_mouse_pad-r8373f5d9a11442329e69890d46f2cf94_x74vi_8byvr_540.jpg', 1, 14, CAST(N'2023-12-14T17:03:02.740' AS DateTime), 14, CAST(N'2023-12-14T17:03:02.740' AS DateTime), 1)
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
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (2, 1, 1, NULL, 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 12, CAST(N'2023-12-14T19:25:09.697' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (2, 2, 1, NULL, 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 13, CAST(N'2023-12-14T17:10:17.260' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (2, 3, 1, NULL, 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (3, 4, 1, NULL, 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1, CAST(N'2023-12-10T18:49:10.453' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (8, 1, 1, 13, 3, CAST(N'2023-12-14T16:24:52.830' AS DateTime), 13, CAST(N'2023-12-14T16:41:43.510' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (8, 4, 1, 13, 3, CAST(N'2023-12-14T16:24:46.753' AS DateTime), 13, CAST(N'2023-12-14T16:41:44.180' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (8, 9, 1, 13, 3, CAST(N'2023-12-14T16:24:57.930' AS DateTime), 13, CAST(N'2023-12-14T16:41:44.827' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (8, 15, 1, 13, 3, CAST(N'2023-12-14T16:25:03.120' AS DateTime), 13, CAST(N'2023-12-14T16:41:45.480' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (9, 2, 1, NULL, 1, CAST(N'2023-12-14T16:33:16.760' AS DateTime), 11, CAST(N'2023-12-14T16:33:16.760' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (9, 3, 1, 12, 2, CAST(N'2023-12-14T16:33:19.283' AS DateTime), 12, CAST(N'2023-12-14T16:39:22.740' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (9, 4, 1, 13, 2, CAST(N'2023-12-14T16:33:09.617' AS DateTime), 13, CAST(N'2023-12-14T16:41:52.290' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (9, 7, 1, 12, 3, CAST(N'2023-12-14T16:57:56.797' AS DateTime), 12, CAST(N'2023-12-14T17:06:31.517' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (9, 11, 1, 12, 2, CAST(N'2023-12-14T16:32:59.057' AS DateTime), 12, CAST(N'2023-12-14T16:39:32.797' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (9, 13, 1, NULL, 1, CAST(N'2023-12-14T16:33:02.383' AS DateTime), 11, CAST(N'2023-12-14T16:33:02.383' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (9, 14, 1, NULL, 1, CAST(N'2023-12-14T16:33:05.777' AS DateTime), 11, CAST(N'2023-12-14T16:33:05.777' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (9, 16, 1, NULL, 1, CAST(N'2023-12-14T16:32:56.583' AS DateTime), 11, CAST(N'2023-12-14T16:32:56.583' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (10, 2, 1, NULL, 1, CAST(N'2023-12-14T16:38:09.173' AS DateTime), 11, CAST(N'2023-12-14T16:38:09.173' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (10, 3, 1, NULL, 1, CAST(N'2023-12-14T16:38:29.007' AS DateTime), 11, CAST(N'2023-12-14T16:38:29.007' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (10, 10, 1, NULL, 1, CAST(N'2023-12-14T16:38:12.417' AS DateTime), 11, CAST(N'2023-12-14T16:38:12.417' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (10, 11, 1, NULL, 1, CAST(N'2023-12-14T16:38:24.827' AS DateTime), 11, CAST(N'2023-12-14T16:38:24.827' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (10, 14, 1, NULL, 1, CAST(N'2023-12-14T16:38:15.563' AS DateTime), 11, CAST(N'2023-12-14T16:38:15.563' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (10, 15, 1, NULL, 1, CAST(N'2023-12-14T16:38:18.623' AS DateTime), 11, CAST(N'2023-12-14T16:38:18.623' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (10, 16, 1, NULL, 1, CAST(N'2023-12-14T16:38:21.370' AS DateTime), 11, CAST(N'2023-12-14T16:38:21.370' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (11, 2, 1, NULL, 1, CAST(N'2023-12-14T16:37:47.280' AS DateTime), 11, CAST(N'2023-12-14T16:37:47.280' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (11, 5, 1, NULL, 1, CAST(N'2023-12-14T16:37:57.053' AS DateTime), 11, CAST(N'2023-12-14T16:37:57.053' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (11, 10, 1, NULL, 1, CAST(N'2023-12-14T16:37:44.010' AS DateTime), 11, CAST(N'2023-12-14T16:37:44.010' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (11, 14, 1, NULL, 1, CAST(N'2023-12-14T16:37:50.973' AS DateTime), 11, CAST(N'2023-12-14T16:37:50.973' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (11, 16, 1, NULL, 1, CAST(N'2023-12-14T16:37:41.300' AS DateTime), 11, CAST(N'2023-12-14T16:37:41.300' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (12, 1, 1, 13, 3, CAST(N'2023-12-14T16:37:12.200' AS DateTime), 13, CAST(N'2023-12-14T16:41:26.197' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (12, 3, 1, 13, 3, CAST(N'2023-12-14T16:37:23.160' AS DateTime), 13, CAST(N'2023-12-14T16:41:29.283' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (12, 8, 1, 13, 3, CAST(N'2023-12-14T16:37:29.033' AS DateTime), 13, CAST(N'2023-12-14T16:41:30.800' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (12, 9, 1, 13, 3, CAST(N'2023-12-14T16:37:06.427' AS DateTime), 13, CAST(N'2023-12-14T16:41:27.053' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (12, 12, 1, 13, 3, CAST(N'2023-12-14T16:37:35.033' AS DateTime), 13, CAST(N'2023-12-14T16:41:32.810' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (12, 15, 1, 13, 3, CAST(N'2023-12-14T16:37:17.350' AS DateTime), 13, CAST(N'2023-12-14T16:41:35.140' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (14, 1, 1, NULL, 1, CAST(N'2023-12-14T16:35:34.687' AS DateTime), 11, CAST(N'2023-12-14T16:35:34.687' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (14, 6, 1, NULL, 1, CAST(N'2023-12-14T16:35:31.313' AS DateTime), 11, CAST(N'2023-12-14T16:35:31.313' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (14, 7, 1, NULL, 1, CAST(N'2023-12-14T16:35:39.413' AS DateTime), 11, CAST(N'2023-12-14T16:35:39.413' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (14, 8, 1, NULL, 1, CAST(N'2023-12-14T16:35:25.373' AS DateTime), 11, CAST(N'2023-12-14T16:35:25.373' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (14, 17, 1, NULL, 1, CAST(N'2023-12-14T17:04:07.913' AS DateTime), 14, CAST(N'2023-12-14T17:04:07.913' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (15, 2, 1, NULL, 1, CAST(N'2023-12-14T16:42:42.977' AS DateTime), 11, CAST(N'2023-12-14T16:42:42.977' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (15, 3, 1, NULL, 1, CAST(N'2023-12-14T16:42:39.990' AS DateTime), 11, CAST(N'2023-12-14T16:42:39.990' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (15, 6, 1, NULL, 1, CAST(N'2023-12-14T16:42:35.797' AS DateTime), 11, CAST(N'2023-12-14T16:42:35.797' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (15, 7, 1, NULL, 1, CAST(N'2023-12-14T16:42:31.317' AS DateTime), 11, CAST(N'2023-12-14T16:42:31.317' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (15, 10, 1, NULL, 1, CAST(N'2023-12-14T16:42:33.310' AS DateTime), 11, CAST(N'2023-12-14T16:42:33.310' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (15, 12, 1, NULL, 1, CAST(N'2023-12-14T16:42:28.357' AS DateTime), 11, CAST(N'2023-12-14T16:42:28.357' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (16, 3, 1, NULL, 1, CAST(N'2023-12-14T16:43:17.687' AS DateTime), 11, CAST(N'2023-12-14T16:43:17.687' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (16, 6, 1, NULL, 1, CAST(N'2023-12-14T16:43:04.683' AS DateTime), 11, CAST(N'2023-12-14T16:43:04.683' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (16, 10, 1, NULL, 1, CAST(N'2023-12-14T16:43:06.993' AS DateTime), 11, CAST(N'2023-12-14T16:43:06.993' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (16, 11, 1, NULL, 1, CAST(N'2023-12-14T16:43:20.657' AS DateTime), 11, CAST(N'2023-12-14T16:43:20.657' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (16, 13, 1, NULL, 1, CAST(N'2023-12-14T16:43:08.927' AS DateTime), 11, CAST(N'2023-12-14T16:43:08.927' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (16, 14, 1, NULL, 1, CAST(N'2023-12-14T16:43:11.483' AS DateTime), 11, CAST(N'2023-12-14T16:43:11.483' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (16, 15, 1, NULL, 1, CAST(N'2023-12-14T16:43:23.387' AS DateTime), 11, CAST(N'2023-12-14T16:43:23.387' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (16, 16, 1, NULL, 1, CAST(N'2023-12-14T16:43:15.460' AS DateTime), 11, CAST(N'2023-12-14T16:43:15.460' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (17, 4, 1, NULL, 1, CAST(N'2023-12-14T16:45:58.267' AS DateTime), 11, CAST(N'2023-12-14T16:45:58.267' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (18, 1, 1, NULL, 1, CAST(N'2023-12-14T16:59:33.570' AS DateTime), 11, CAST(N'2023-12-14T16:59:33.570' AS DateTime), 1)
INSERT [dbo].[list_items] ([list_id], [item_id], [quantity], [list_item_claimed_by_user_id], [list_item_status_id], [created_date_utc], [last_modified_by_user_id], [last_modified_date_utc], [is_active]) VALUES (19, 3, 1, 13, 3, CAST(N'2023-12-14T17:00:02.100' AS DateTime), 13, CAST(N'2023-12-14T17:10:54.703' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[list_statuses] ON 

INSERT [dbo].[list_statuses] ([list_status_id], [list_status_name]) VALUES (1, N'Draft')
INSERT [dbo].[list_statuses] ([list_status_id], [list_status_name]) VALUES (2, N'In Progress')
INSERT [dbo].[list_statuses] ([list_status_id], [list_status_name]) VALUES (3, N'Complete')
SET IDENTITY_INSERT [dbo].[list_statuses] OFF
GO
SET IDENTITY_INSERT [dbo].[lists] ON 

INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (1, N'Mimi Malone', 1, 1, 11, CAST(N'2023-12-17T18:49:10.447' AS DateTime), CAST(N'2023-12-10T18:49:10.447' AS DateTime), CAST(N'2023-12-10T18:49:10.447' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (2, N'Henry Edwards', 1, 2, 11, CAST(N'2023-12-17T18:49:10.450' AS DateTime), CAST(N'2023-12-10T18:49:10.450' AS DateTime), CAST(N'2023-12-10T18:49:10.450' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (3, N'Douglas Adams', 1, 3, 11, CAST(N'2023-12-17T18:49:10.450' AS DateTime), CAST(N'2023-12-10T18:49:10.450' AS DateTime), CAST(N'2023-12-10T18:49:10.450' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (8, N'Emily Thompson', 3, 3, 11, CAST(N'2023-12-31T00:00:00.000' AS DateTime), CAST(N'2023-12-14T11:24:29.900' AS DateTime), CAST(N'2023-12-14T16:41:49.490' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (9, N'Benjamin Davis', 1, 2, 11, CAST(N'2023-12-31T00:00:00.000' AS DateTime), CAST(N'2023-12-14T11:25:14.877' AS DateTime), CAST(N'2023-12-14T11:25:14.877' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (10, N'Olivia Johnson', 5, 2, 11, CAST(N'2024-01-24T00:00:00.000' AS DateTime), CAST(N'2023-12-14T11:29:10.230' AS DateTime), CAST(N'2023-12-14T11:29:10.230' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (11, N'Ethan Wilson', 4, 2, 11, CAST(N'2024-01-22T00:00:00.000' AS DateTime), CAST(N'2023-12-14T11:29:33.323' AS DateTime), CAST(N'2023-12-14T11:29:33.323' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (12, N'Ava Martinez', 3, 3, 11, CAST(N'2024-01-30T00:00:00.000' AS DateTime), CAST(N'2023-12-14T11:30:03.930' AS DateTime), CAST(N'2023-12-14T16:41:39.137' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (14, N'Jackson Taylor', 2, 2, 11, CAST(N'2023-12-31T00:00:00.000' AS DateTime), CAST(N'2023-12-14T11:35:01.013' AS DateTime), CAST(N'2023-12-14T11:35:01.013' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (15, N'Grace Walker', 3, 2, 11, CAST(N'2023-12-31T00:00:00.000' AS DateTime), CAST(N'2023-12-14T11:42:25.187' AS DateTime), CAST(N'2023-12-14T11:42:25.187' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (16, N'Noah Baker', 3, 2, 11, CAST(N'2023-12-31T00:00:00.000' AS DateTime), CAST(N'2023-12-14T11:43:01.110' AS DateTime), CAST(N'2023-12-14T11:43:01.110' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (17, N'Bobby Tables', 1, 1, 11, CAST(N'2023-12-31T00:00:00.000' AS DateTime), CAST(N'2023-12-14T11:45:53.730' AS DateTime), CAST(N'2023-12-14T11:45:53.730' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (18, N'Harper Mitchell', 1, 2, 11, CAST(N'2023-12-31T00:00:00.000' AS DateTime), CAST(N'2023-12-14T11:59:25.773' AS DateTime), CAST(N'2023-12-14T11:59:25.773' AS DateTime), 1)
INSERT [dbo].[lists] ([list_id], [list_name], [department_id], [list_status_id], [list_owner_user_id], [due_date_utc], [created_date_utc], [last_modified_date_utc], [is_active]) VALUES (19, N'Abigail Turner', 3, 3, 11, CAST(N'2023-12-31T00:00:00.000' AS DateTime), CAST(N'2023-12-14T11:59:53.517' AS DateTime), CAST(N'2023-12-14T17:10:58.683' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[lists] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (1, N'user', N'Regular', N'User', 1, N'Jg45HuwT7PZkfuKTz6IB90CtWY4=', N'LHxP4Xh7bN0=', N'user', N'https://api.dicebear.com/7.x/personas/svg?seed=RegularUser', 1, CAST(N'2023-12-10T18:49:10.447' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (2, N'admin', N'Admin', N'User', 0, N'YhyGVQ+Ch69n4JMBncM4lNF/i9s=', N'Ar/aB2thQTI=', N'admin', N'https://api.dicebear.com/7.x/personas/svg?seed=AdminUser', 1, CAST(N'2023-12-10T18:49:10.447' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (11, N'dmiller', N'Dustin', N'Miller', 0, N'okFkdauuI/y5EB4Y6gncABrqWJ4=', N'ertUYGL9feA=', N'admin', N'https://api.dicebear.com/7.x/initials/svg?seed=DM8002', 1, CAST(N'2023-12-14T16:22:52.293' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (12, N'nhutner', N'Natalie', N'Hutner', 1, N'8866qQut4q/K4GirBe0CCcQ66UE=', N'S8FeeJ5TQE0=', N'user', N'https://api.dicebear.com/7.x/initials/svg?seed=NH3705', 1, CAST(N'2023-12-14T16:23:20.197' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (13, N'jbills', N'Jeril', N'Bills', 3, N'7lwfiPpVN+5qzpMWAOgWWNKfg6w=', N'adQXP25/EIQ=', N'user', N'https://api.dicebear.com/7.x/initials/svg?seed=JB2629', 1, CAST(N'2023-12-14T16:24:03.620' AS DateTime))
INSERT [dbo].[users] ([user_id], [username], [first_name], [last_name], [department_id], [password_hash], [salt], [user_role], [avatar_url], [is_active], [created_date_utc]) VALUES (14, N'joshuafutrell', N'Joshua', N'Futrell', 0, N'GeJVwjQUMBhprgn7Erpfk9d2ZIg=', N'K/53Id8wIAM=', N'admin', N'https://api.dicebear.com/7.x/initials/svg?seed=JF8510', 1, CAST(N'2023-12-14T17:01:48.543' AS DateTime))
SET IDENTITY_INSERT [dbo].[users] OFF
GO
INSERT [dbo].[users_lists] ([user_id], [list_id]) VALUES (13, 9)
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
