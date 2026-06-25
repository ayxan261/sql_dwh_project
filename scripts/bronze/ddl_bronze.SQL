if OBJECT_ID('bronze.crm_cust_info','U') is not null
drop table bronze.crm_cust_info;
create table bronze.crm_cust_info
(
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date
);

if OBJECT_ID('bronze.crm_prd_info','U') is not null
drop table bronze.crm_prd_info;
create table bronze.crm_prd_info
(
prd_id int,
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt date,
prd_end_dt date
);

if OBJECT_ID('bronze.crm_sales_details','U') is not null
drop table bronze.crm_sales_details;
create table bronze.crm_sales_details
(
 sls_ord_num nvarchar(50),
 sls_prd_key nvarchar(50),
 sls_cust_id int,
 sls_order_dt int,
 sls_ship_dt int,
 sls_due_dt int,
 sls_sales int,
 sls_quantity int,
 sls_price decimal
);
alter table bronze.crm_sales_details
alter column sls_price int

if OBJECT_ID('bronze.erp_CUST_AZ12','U') is not null
drop table bronze.erp_CUST_AZ12;
create table bronze.erp_CUST_AZ12
(
CID nvarchar(50),
BDATE date,
GEN nvarchar(50)
);

create table bronze.erp_LOC_A101
(
CID int,
CNTRY nvarchar(50)
);

ALTER TABLE bronze.erp_LOC_A101
ALTER COLUMN CID NVARCHAR(50);

if OBJECT_ID('bronze.erp_PX_CAT_G1V2','U') is not null
drop table bronze.erp_PX_CAT_G1V2;
create table bronze.erp_PX_CAT_G1V2
(
ID nvarchar(50),
CAT nvarchar(50),
SUBCAT nvarchar(50),
MAINTENANCE nvarchar(50)
);




create or alter procedure bronze.load_bronze as
begin
declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
begin try
set @batch_start_time=getdate();
print '================================================';
print 'Loading bronze layer';
print '------------------------------------------------';
print 'Loading crm Tables';

set @start_time=GETDATE();
truncate table bronze.crm_cust_info;
bulk insert bronze.crm_cust_info
from 'D:\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
with 
(
firstrow=2,
fieldterminator=',',
tablock
);
set @end_time=GETDATE();

PRINT 'Load Duration: '+ CAST(datediff(second,@start_time,@end_time) AS NVARCHAR);


set @start_time=GETDATE();
truncate table bronze.crm_prd_info

bulk insert bronze.crm_prd_info
from 'D:\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
with
(
firstrow=2,
fieldterminator=',',
tablock
)
set @end_time=GETDATE();
PRINT 'Load Duration: '+ CAST(datediff(second,@start_time,@end_time) AS NVARCHAR);

set @start_time=GETDATE();
truncate table bronze.crm_sales_details
bulk insert bronze.crm_sales_details
from 'D:\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
with
(
firstrow=2,
fieldterminator=',',
tablock
)
set @end_time=GETDATE();
PRINT 'Load Duration: '+ CAST(datediff(second,@start_time,@end_time) AS NVARCHAR);
print '------------------------------------------------';
print 'Loading erp Tables';

set @start_time=GETDATE();
truncate table bronze.erp_CUST_AZ12
bulk insert bronze.erp_CUST_AZ12
from 'D:\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
with
(
firstrow=2,
fieldterminator=',',
tablock
)
set @end_time=GETDATE();
PRINT 'Load Duration: '+ CAST(datediff(second,@start_time,@end_time) AS NVARCHAR);


set @start_time=GETDATE();
truncate table bronze.erp_LOC_A101
bulk insert bronze.erp_LOC_A101
from 'D:\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
with
(
firstrow=2,
fieldterminator=',',
tablock
)
set @end_time=GETDATE();
PRINT 'Load Duration: '+ CAST(datediff(second,@start_time,@end_time) AS NVARCHAR);
set @start_time=GETDATE();
truncate table bronze.erp_PX_CAT_G1V2
bulk insert bronze.erp_PX_CAT_G1V2
from 'D:\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
with
(
firstrow=2,
fieldterminator=',',
tablock
)
set @end_time=GETDATE();
PRINT 'Load Duration: '+ CAST(datediff(second,@start_time,@end_time) AS NVARCHAR);
print '-------------------------'
set @batch_end_time=GETDATE();
PRINT 'PROCEDURE Duration: '+ CAST(datediff(second,@batch_start_time,@batch_end_time) AS NVARCHAR);
end try
begin catch
print '========================================='
print 'ERROR OCCURED DURING LOADING BRONZE LAYER'
PRINT'Error Message: '+error_message();
PRINT'Error Message: '+cast(error_number() as nvarchar);
print '========================================='
end catch
end

exec bronze.load_bronze

select * from bronze.crm_prd_info
