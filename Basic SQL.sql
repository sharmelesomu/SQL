select * from naresh_16.globalorders;
select * from sharmele.Person;

-- SQL is the structured query language for storing, manipulating and retriving data from databases
-- CREATING TABLE
CREATE TABLE Person(
PersonId int,
FirstName varchar(20),
LastName varchar(20),
Address varchar(20),
Phone char(10)
);

-- INSERTING DATA INTO PERSONS TABLE
INSERT INTO Person VALUES(100,'Sharmele','Somu','Tenkasi','4455662211');
INSERT INTO Person(PersonId,FirstName) VALUES (100,'Sharme'),(101,'Raju'); -- inserting partial data on multiple rows
INSERT INTO Person VALUES (101,'Brintha','Somu','Courtallum','9988776655'), (102,'Malini','Somu','Madurai','3322446655'); -- inserting on multiple rows
INSERT INTO Person VALUES (101,'Rajam','Somu','Tenkasi','9988776655'), (102,'Somu','Mookaiah','Courtallum','3322446655');

-- UPDATING TABLE
UPDATE Person SET PersonId=103, Phone='1111111111' where FirstName = 'Rajam';
UPDATE Person SET PersonId=104, Phone='2222222222' where FirstName = 'Somu';

-- ALTER TABLE - we can add, delete and modify the columns
-- Syntax: ALTER TABLE TABLENAME ADD/DROP/MODIFY COLUMNNAME (DATATYPE)
ALTER TABLE Person ADD Salary int;
ALTER TABLE Person ADD Email varchar(20);
select * from Person;
ALTER TABLE Person DROP Salary;
ALTER TABLE Person Modify Phone varchar(11);

-- DROP TABLE
start transaction;
DROP TABLE Person; -- rollback doesnot work after drop
rollback;

-- DELETE TABLE -- only delete can be rolled back, when using truncate and drop in mysql, the table will be lost
start transaction;
DELETE FROM Person where FirstName = 'Raju';
DELETE FROM Person where FirstName = 'Sharme';
DELETE FROM Person; -- will delete all the rows. table structure still remains
rollback;

-- TRUNCATE TABLE
start transaction;
TRUNCATE TABLE Person; -- similar to delete from table will remove all the rows from the table.
rollback;

-- CONSTRAINTS
-- They can be created when we create the table or after the table is created using alter statement
-- constraints can be column level or table level. they are rules for the data to be added. data meeting these rules will be added to the table otherwise the action is aborted.
-- not null, unique, primarykey, foreign key, check, default, create index

-- NOT NULL ON CREATE TABLE
CREATE TABLE Employee(
Empid int NOT NULL,
Empname varchar(20),
Salary int);

INSERT INTO Employee (Empname,Salary)VALUES('Sharmele',2000); -- throws an error
INSERT INTO Employee (Empid,Empname,Salary)VALUES(1,'Sharmele',2000); 

-- NOT NULL ON ALTER STMT
SELECT * FROM demo;
ALTER TABLE demo modify iddemo int NOT NULL;
INSERT INTO demo (iddemo,name,salary)VALUES(1,'Sharmele',2000); 
INSERT INTO demo (name,salary)VALUES('Sharmele',2000); -- throws an error

-- UNIQUE CONSTRAINT
-- there is only one primary key for a table but there can be any number of unique constraints.
-- when unique constraint is created for the table, it takes unique values for the column. when unique constrianed is defined for several columns, they take only unique combinations.

create table UniqueCon(
empid int,
empname varchar(20),
salary int);

create table UniqueCon1(
empid int unique,
empname varchar(20),
salary int); -- adding unique constraint when creating table foe single column
Alter table UniqueCon modify empname varchar(20) unique; -- adding unique constraint on alter table for single column

create table UniqueCon2 (
empid int,
empname varchar(20),
salary int,
CONSTRAINT constraintname UNIQUE (empid,empname) -- creates unique constraint for combination of columns
);

insert into UniqueCon2 values(101,'xxxx',1000),(102,'yyyy',2000);
select * from UniqueCon2;
insert into UniqueCon2 values(101,'zzzz',1000),(102,'jjjj',2000); -- even when empid is same it accepts because it check for unique combinations
insert into UniqueCon2 values(101,'xxxx',10000); -- throws an error (Duplicate entry)

-- PRIMARY KEY COSTRAINT
-- There will be only one primary key for a table. primary key combines unique and not null constraint. A column as primary key cannot have any null value and the value must be unique.
-- there can be only one column as a primary key or combination of columns. even if 2 columns are mentioned as primary key. the two columns together make one primary key
-- they can be created using create table or alter table commands

create table pktable(
empid int,
empname varchar(20),
salary int);
select * from pktable;

alter table pktable add primary key (empid);  -- adding primary key using alter command
alter table pktable drop primary key; -- delete the primary key
alter table pktable add constraint pkcostraint primary key (empid,empname); -- adding two column combination as primary key using alter command

create table pktable1( -- single primary key using create statement
empid int,
empname varchar(20),
salary int,
primary key (empid)
);

create table pktable2( -- two primary key combination using create statement
empid int,
empname varchar(20),
salary int,
primary key (empid,empname)
);

-- FOREIGN KEY CONSTRAINT
-- orders table: orderid is the primary key and person id  is the foreign key -- fact table
-- persons table: personid the primary key -- dimension table
-- to add a foreign key using alter command, we have to create foreign key constraint.
-- to drop a foreign key using alter command, we have to create foreign key constraint.
-- create the referencing table(dimension table) before creating the fact table

create table orders(
orderid int not null,
item varchar(20),
quantity int,
personid int,
primary key (orderid),
foreign key (personid) references persons(personid)
);
select * from orders;
ALTER TABLE orders drop foreign key; -- to drop foreign key, foreign key constraint should be added
-- or
create table orders1(
orderid int not null,
item varchar(20),
quantity int,
personid int,
primary key (orderid),
constraint fkconstraint foreign key (personid) references persons(personid)
);
alter table orders1 drop foreign key fkconstraint; -- to drop the foreign key we are giving the constraint name

-- adding composite foreign key
CREATE TABLE orders2 (
    orderid INT NOT NULL,
    item VARCHAR(20),
    quantity INT,
    personid INT,
    name varchar(20), -- Additional column for composite key
    PRIMARY KEY (orderid),
    CONSTRAINT fk_composite FOREIGN KEY (personid, name) REFERENCES persons1(personid, name)
);
-- when creating composite foreign key, composite primary key or unique constriant is required in the referencing table (persons)
-- unique creating for each column will make them two seperate unique columns not a combination

create table persons( -- two seperate unique statement will make two columns unique seperately. they are not unique combinations
personid int unique,
name varchar(20) unique
);

create table persons1( -- Dimension table having composite primary key
personid int,
name varchar(20),
CONSTRAINT fkcons primary key (personid, name)
);

create table persons2( -- Dimension table having combination of unique columns
personid int,
name varchar(20),
CONSTRAINT fkunique UNIQUE (personid, name)
);

CREATE TABLE orders3 (
    orderid INT NOT NULL,
    item VARCHAR(20),
    quantity INT,
    personid INT,
    name varchar(20), -- Additional column for composite key
    PRIMARY KEY (orderid),
    CONSTRAINT fk_composite1 FOREIGN KEY (personid, name) REFERENCES persons2(personid, name)
);

select * from persons;
alter table persons add primary key(personid);

-- CHECK CONSTRAINT
-- it is used to limit the range of values that can be assigned in the column e.g., age
-- to define check constraint on multiple columns, constraint name is used
-- check constraint can be created for column or table(references 2 or more columns in a table like salary = age*10000. constraint name should be created for this)

DROP TABLE children;
CREATE TABLE children(
id int,
name varchar(10),
age int,
CHECK (age<10)
);

INSERT into children values (1,'rayan',5);
INSERT into children2 values (1,'kamal',5); -- throws error change age =15, name ='kamal'
select * from children;

CREATE TABLE children2( -- multiple cheeck constraint without constraint name
id int,
name varchar(10),
age int,
CHECK (age<10),
CHECK (name LIKE 'r*')
);

CREATE TABLE children3( -- multiple cheeck constraint with constraint name
id int,
name varchar(10),
age int,
CONSTRAINT checkcons CHECK (age<10 & (name LIKE 'r*'))
);

-- to add a check constraint we dont have to create constraint name
-- to drop a check constraint we have to create a constraint name

CREATE TABLE children1( -- creates age constraint using constraint name
id int,
name varchar(10),
age int,
CONSTRAINT checkcon CHECK (age<10)
);

CREATE TABLE children4( -- table to add constraint using alter command
id int,
name varchar(10),
age int
);

CREATE TABLE children5( -- table to add constraint using alter command
id int,
name varchar(10),
age int
);

ALTER TABLE children4 add check (age>5); -- adding check constraint for single column
-- when table is created with check for single column, check cannot be created for multiple column -- says table doesnot exist
ALTER TABLE children5 add check (age>5),add check(name LIKE 'r*'); -- adding check constraint for multiple column
5.
CREATE TABLE children6( -- table to add constraint using alter command using constraint name
id int,
name varchar(10),
age int
);

ALTER TABLE children6 add constraint conscheck check (age>5),add check(name LIKE 'r*'); -- adding constraint on multiple columns using constraintname
ALTER TABLE children6 drop constraint conscheck; -- works even if red
ALTER TABLE children6 drop check conscheck; -- works even if red

alter table children add constraint checkcons check (age<12);
insert into children values(101,'Manu',13); -- throws error saying check constraint is violated
alter table children drop constraint checkcons;
insert into children values(101,'Manu',13); -- works now after deleting check constraint
alter table children add constraint checkcons check (age<12 AND tname='xxxx'); -- it table already contains violated check constraint rows. Adding new constraint is not successful, delete the columns and addd the constraint again
select * from children;
delete from children;
insert into children values(101,'xxxx',11); -- works now after deleting the contents in the table

-- DEFAULT CONSTRAINT
-- It is used to assign a default value for the selected column when no value is specified.
CREATE TABLE DEFAULT_TABLE(
Id int,
Name varchar(20),
Salary int DEFAULT 0,
City varchar(20)
);

CREATE TABLE DEFAULT_TABLE1(
Id int,
Name varchar(20),
City varchar(20),
Salary int
);

select * from DEFAULT_TABLE;
INSERT INTO DEFAULT_TABLE (Id,Name,City) VALUES (1,'sharme','Dubai'); -- on inserting this row default value of 0 is created for salary

ALTER TABLE DEFAULT_TABLE1 ALTER CITY SET DEFAULT 'Dubai'; -- adds default constraint to city columns
ALTER TABLE DEFAULT_TABLE1 ALTER CITY DROP DEFAULT; -- drops default constraint from city column

-- INDEXES
-- Create indexes are used to create indexes for the table. they makes the retrivals quicker.
-- updating table with out indexes is faster compared to updating table with indexes. so use indexes only for columns that are frequent queryed.
-- indexes can be created on single column or multiple column when creating the index
-- indexes cannot be seen by the user. they are used only for speedy recovery
-- create index - duplicates are allowed
-- create unique index - duplicates are not allowed

select * from studentinfo;

CREATE INDEX stuname ON studentinfo (Stuname);
CREATE UNIQUE INDEX stuname1 ON studentinfo (Stuid, Stuname); -- 2 cols have index and cannot be seen by user
ALTER TABLE studentinfo DROP INDEX stuname; -- drops the created index

-- AUTO INCREMENT
-- it is used to automatically increment the value for personid
-- Mysql, Access - Autoincrement, MYSQL SERVER identity(1,1) - starts at 1 increases by 1, oracle - create sequence seqname( minvalue 1, startswith 1, increment by 1, cache 10)

CREATE TABLE AUTOINC(
id int NOT NULL AUTO_INCREMENT PRIMARY KEY, -- autoincrement column should be primary key
Name varchar(20)
);
insert into AUTOINC (Name) values('Kamal');
select * from AUTOINC;
insert into AUTOINC (Name) values('Vimal'),('Suji'),('Amal');

-- DATE DATATYPES
-- DATE - YYYY/MM/DD
-- DATETIME - YYYY/MM/DD HH:MI:SS
-- TIMESTAMP - YYYY/MM/DD HH:MI:SS
-- YEAR - YYYY/YY

-- VIEWS
-- Views are virtual tables created from the result of SQL statement
-- we can create, update and drop view
-- When you query a view, the database engine translates the view definition into its corresponding SQL query and runs it on the base tables.
-- As a result, the data returned by the view is always as current as the data in the base tables.

select * from naresh_16.globalorders;

CREATE VIEW DEMOVIEW AS
SELECT * 
FROM naresh_16.globalorders
WHERE Market = 'Africa' and Country = 'Senegal';

select * from DEMOVIEW; -- can display the view like an table

CREATE OR REPLACE VIEW DEMOVIEW AS -- updates the view
SELECT *
FROM naresh_16.globalorders
WHERE Market = 'Africa'and Country = 'Senegal' and City='Dakar';

DROP VIEW DEMOVIEW; -- drops the view