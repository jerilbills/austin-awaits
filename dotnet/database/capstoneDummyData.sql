USE master
GO

--drop database if it exists
IF DB_ID('dummy_data') IS NOT NULL
BEGIN
	ALTER DATABASE dummy_data SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE dummy_data;
END

CREATE DATABASE dummy_data
GO

USE dummy_data
GO

--create tables
CREATE TABLE departments (
	department_id int IDENTITY(1,1) NOT NULL,
	department_name varchar(50) NOT NULL,
	is_active bit DEFAULT 1 NOT NULL,
	CONSTRAINT PK_department PRIMARY KEY (department_id)
)

CREATE TABLE list_statuses (
	list_status_id int IDENTITY(1,1) NOT NULL,
	list_status_name varchar(25) NOT NULL,
	CONSTRAINT PK_list_status PRIMARY KEY (list_status_id)
)

CREATE TABLE list_item_statuses (
	list_item_status_id int IDENTITY(1,1) NOT NULL,
	list_item_status_name varchar(25) NOT NULL,
	CONSTRAINT PK_list_item_status PRIMARY KEY (list_item_status_id)
)

CREATE TABLE users (
	user_id int IDENTITY(1,1) NOT NULL,
	username varchar(50) NOT NULL,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	department_id int NOT NULL,
	password_hash varchar(200) NOT NULL,
	salt varchar(200) NOT NULL,
	user_role varchar(50) NOT NULL,
	avatar_url varchar(2048) NULL,
	is_active bit DEFAULT 1 NOT NULL,
	created_date_utc DATETIME DEFAULT GETUTCDATE() NOT NULL,
	CONSTRAINT PK_user PRIMARY KEY (user_id)
)

CREATE TABLE items (
	item_id int IDENTITY(1,1) NOT NULL,
	item_name varchar(256) NOT NULL,
	item_description nvarchar(MAX) NULL,
	item_image_url varchar(2048) NULL,
	is_tracked_inventory bit DEFAULT 0 NOT NULL,
	created_by_user_id int NOT NULL,
	created_date_utc DATETIME DEFAULT GETUTCDATE() NOT NULL,
	last_modified_by_user_id int NOT NULL,
	last_modified_date_utc DATETIME DEFAULT GETUTCDATE() NOT NULL,
	is_active bit DEFAULT 1 NOT NULL,
	CONSTRAINT PK_items PRIMARY KEY (item_id)
)

CREATE TABLE lists (
	list_id int IDENTITY(1,1) NOT NULL,
	list_name varchar(100) NOT NULL,
	department_id int NOT NULL,
	list_status_id int NOT NULL,
	list_owner_user_id int NOT NULL,
	due_date_utc DATETIME DEFAULT DATEADD(week, 1, GETUTCDATE()) NOT NULL,
	created_date_utc DATETIME DEFAULT GETUTCDATE() NOT NULL,
	last_modified_date_utc DATETIME DEFAULT GETUTCDATE() NOT NULL,
	is_active bit DEFAULT 1 NOT NULL,
	CONSTRAINT PK_list PRIMARY KEY (list_id)
)

CREATE TABLE list_items (
	list_id int NOT NULL,
	item_id int NOT NULL,
	quantity int DEFAULT 1 NOT NULL,
	list_item_claimed_by_user_id int NULL,
	list_item_status_id int NOT NULL,
	created_date_utc DATETIME DEFAULT GETUTCDATE() NOT NULL,
	last_modified_by_user_id int NOT NULL,
	last_modified_date_utc DATETIME DEFAULT GETUTCDATE() NOT NULL,
	is_active bit DEFAULT 1 NOT NULL,
	CONSTRAINT PK_list_items PRIMARY KEY (list_id, item_id)
)

CREATE TABLE users_lists (
	user_id int NOT NULL,
	list_id int NOT NULL
)

--add FKs
ALTER TABLE users ADD CONSTRAINT FK_users_departments FOREIGN KEY (department_id) REFERENCES departments(department_id);

ALTER TABLE lists ADD CONSTRAINT FK_lists_departments FOREIGN KEY (department_id) REFERENCES departments(department_id);
ALTER TABLE lists ADD CONSTRAINT FK_lists_list_status FOREIGN KEY (list_status_id) REFERENCES list_statuses(list_status_id);
ALTER TABLE lists ADD CONSTRAINT FK_lists_users FOREIGN KEY (list_owner_user_id) REFERENCES users(user_id);

ALTER TABLE items ADD CONSTRAINT FK_items_users_created FOREIGN KEY (created_by_user_id) REFERENCES users(user_id);
ALTER TABLE items ADD CONSTRAINT FK_items_users_modified FOREIGN KEY (last_modified_by_user_id) REFERENCES users(user_id);

ALTER TABLE list_items ADD CONSTRAINT FK_list_items_lists FOREIGN KEY (list_id) REFERENCES lists(list_id);
ALTER TABLE list_items ADD CONSTRAINT FK_list_items_items FOREIGN KEY (item_id) REFERENCES items(item_id);
ALTER TABLE list_items ADD CONSTRAINT FK_list_items_list_item_statues FOREIGN KEY (list_item_status_id) REFERENCES list_item_statuses(list_item_status_id);
ALTER TABLE list_items ADD CONSTRAINT FK_list_items_users_claimed FOREIGN KEY (list_item_claimed_by_user_id) REFERENCES users(user_id);
ALTER TABLE list_items ADD CONSTRAINT FK_list_items_users_modified FOREIGN KEY (last_modified_by_user_id) REFERENCES users(user_id);
ALTER TABLE users_lists ADD CONSTRAINT FK_users_lists_users FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE users_lists ADD CONSTRAINT FK_users_lists_lists FOREIGN KEY (list_id) REFERENCES lists(list_id);

--populate default data
INSERT INTO departments (department_name) VALUES ('Engineering');
INSERT INTO departments (department_name) VALUES ('Sales');
INSERT INTO departments (department_name) VALUES ('Customer Success');
INSERT INTO departments (department_name) VALUES ('Product/Marketing');
INSERT INTO departments (department_name) VALUES ('Admin/Finance');

INSERT INTO list_statuses (list_status_name) VALUES('Draft');
INSERT INTO list_statuses (list_status_name) VALUES('Ready');
INSERT INTO list_statuses (list_status_name) VALUES('In Progress');
INSERT INTO list_statuses (list_status_name) VALUES('Complete');

INSERT INTO list_item_statuses (list_item_status_name) VALUES('Needed');
INSERT INTO list_item_statuses (list_item_status_name) VALUES('Claimed');
INSERT INTO list_item_statuses (list_item_status_name) VALUES('Purchased');

INSERT INTO users (username, first_name, last_name, department_id, password_hash, salt, user_role, avatar_url) 
VALUES ('user', 'Regular', 'User', 1, 'Jg45HuwT7PZkfuKTz6IB90CtWY4=','LHxP4Xh7bN0=','user','https://api.dicebear.com/7.x/personas/svg?seed=RegularUser');

INSERT INTO users (username, first_name, last_name, department_id, password_hash, salt, user_role, avatar_url)
VALUES ('admin', 'Admin', 'User', 1, 'YhyGVQ+Ch69n4JMBncM4lNF/i9s=', 'Ar/aB2thQTI=','admin', 'https://api.dicebear.com/7.x/personas/svg?seed=AdminUser');

INSERT INTO lists (list_name, department_id, list_status_id, list_owner_user_id) VALUES ('Mimi Malone', 1, 1, 1);
INSERT INTO lists (list_name, department_id, list_status_id, list_owner_user_id) VALUES ('Henry Edwards', 1, 1, 1);
INSERT INTO lists (list_name, department_id, list_status_id, list_owner_user_id) VALUES ('Douglas Adams', 1, 1, 1);

INSERT INTO items (item_name, item_description, item_image_url, created_by_user_id, last_modified_by_user_id)
VALUES ('Keep Austin Weird T-Shirt', 'Any kind of Keep Austin Weird T-shirt - be sure to check with user for size/style preferences', 
'https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcTNXfM8kHzW5CM4qxsK0z_HxlxwpAbwVs_b4UU_RxuJeHmtV6V1CXokAEzvcrXXit3VqWkh435DEB69AmfnF8-dhswDho0q', 1, 1);

INSERT INTO items (item_name, item_description, item_image_url, created_by_user_id, last_modified_by_user_id)
VALUES ('Cowboy Hat', 'Our preferred vendor is American Hat Makers', 
'https://americanhatmakers.com/cdn/shop/products/austin-cream-f_1.jpg?v=1668703888&width=1000', 1, 1);

INSERT INTO items (item_name, item_description, item_image_url, created_by_user_id, last_modified_by_user_id)
VALUES ('Big Truck', 'Any model as long as it is American made', 
'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.motortrend.com%2Ffeatures%2Ftop-10-biggest-2017-ford-super-duty-trucks%2F&psig=AOvVaw0GSm5Qp_UDpNLgGnsn7M3Z&ust=1701886905523000&source=images&cd=vfe&ved=0CBIQjRxqFwoTCJit-Pb0-IIDFQAAAAAdAAAAABAE', 1, 1);

INSERT INTO items (item_name, item_description, item_image_url, created_by_user_id, last_modified_by_user_id)
VALUES ('Engineering Grade Laptop (Dell)', 'Check with IT for the current specs and order direct from the Dell website', 
'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-15-9530/media-gallery/touch-black/notebook-xps-15-9530-t-black-gallery-5.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=677&qlt=100,1&resMode=sharp2&size=677,402&chrss=full', 1, 1);


INSERT INTO list_items (list_id, item_id, list_item_status_id, last_modified_by_user_id) VALUES (1, 1, 1, 1);
INSERT INTO list_items (list_id, item_id, list_item_status_id, last_modified_by_user_id) VALUES (1, 2, 1, 1);
INSERT INTO list_items (list_id, item_id, list_item_status_id, last_modified_by_user_id) VALUES (1, 3, 1, 1);
INSERT INTO list_items (list_id, item_id, list_item_status_id, last_modified_by_user_id) VALUES (1, 4, 1, 1);

INSERT INTO list_items (list_id, item_id, list_item_status_id, last_modified_by_user_id) VALUES (2, 1, 1, 1);
INSERT INTO list_items (list_id, item_id, list_item_status_id, last_modified_by_user_id) VALUES (2, 2, 1, 1);
INSERT INTO list_items (list_id, item_id, list_item_status_id, last_modified_by_user_id) VALUES (2, 3, 1, 1);

INSERT INTO list_items (list_id, item_id, list_item_status_id, last_modified_by_user_id) VALUES (3, 4, 1, 1);

GO
