-- ============================================================
--   SCRIPT HEADER (MSSQL RMEXPRESS Task Manager STRUCTURE)
--   Module Name: DA2 (All)
--   Description: 	DDL for Data Analytics DIS
--   Date:		09/07/2016         
-- ============================================================= 

BEGIN
DECLARE @CNT AS varchar(100);
DECLARE @CT AS varchar(100);
DECLARE @COLM AS varchar(100);
DECLARE @COLS AS varchar(100);
declare @sql as nvarchar(max);
declare @sql1 as nvarchar(max);
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DA_JOB_NAMES') 
BEGIN
set @sql = 'CREATE TABLE [dbo].[DA_JOB_NAMES](
		DSNID int not null,
 		TASK_TYPE_ID [INT],
		JOB_NAME [varchar](4000),
		DocumentManagementEnabled [varchar](5),
		rmADocumentPoolPath [varchar](50) null,
		KeepJobFilesOnSuccess [varchar](5),
		SUB_JOB_NAME[varchar](10)
	)'
EXECUTE SP_EXECUTESQL @sql	
END

ELSE
BEGIN

-- AS VARCHAR)

SET @sql='select @pcnt = count(*) from information_schema.columns where column_name=''DocumentManagementEnabled'' AND TABLE_NAME=''DA_JOB_NAMES'''
EXECUTE SP_EXECUTESQL @sql, N' @pcnt INT OUTPUT',
			@pcnt = @cnt OUTPUT

if(@CNT ='0')
BEGIN

set @sql = 'ALTER TABLE DA_JOB_NAMES ADD DocumentManagementEnabled varchar(5),rmADocumentPoolPath varchar(50) null,KeepJobFilesOnSuccess varchar(5)'
EXECUTE SP_EXECUTESQL @sql
END
ELSE
BEGIN
SET @CT='1'
END
BEGIN
SET @CNT='0'
SET @sql='select @pcnt = count(*) from information_schema.columns where column_name=''SUB_JOB_NAME'' AND TABLE_NAME=''DA_JOB_NAMES'''
EXECUTE SP_EXECUTESQL @sql, N' @pcnt INT OUTPUT',
			@pcnt = @cnt OUTPUT
END
if(@CNT='0')
BEGIN

set @sql = 'ALTER TABLE DA_JOB_NAMES ADD SUB_JOB_NAME varchar(10)'
EXECUTE SP_EXECUTESQL @sql
END

END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DA_CONFIG') 
BEGIN
set @sql = 'CREATE TABLE [dbo].[DA_CONFIG](
		DSNID int not null,
		AccessStagingDataSource [varchar](4000),
		RMXStagingDataSource [varchar](4000),
		StagingDataSource [varchar](4000) null,
		RMXLoginName [varchar](50) null ,
		RMXDataSourceName [varchar](50) null,
		FilePath [varchar](4000) null,
		DocAttachNameDelimeter [varchar](1) null,
		S3BucketOnCloud varchar(4000) null,
		
	)'
	EXECUTE SP_EXECUTESQL @sql
END

ELSE
BEGIN

SET @sql='select @pcnt = count(*) from information_schema.columns where column_name=''FilePath'' AND TABLE_NAME=''DA_CONFIG'''
EXECUTE SP_EXECUTESQL @sql, N' @pcnt INT OUTPUT',
			@pcnt = @cnt OUTPUT
if(@CNT='0')
BEGIN

set @sql = 'ALTER TABLE DA_CONFIG ADD FilePath varchar(4000),DocAttachNameDelimeter varchar(1) null,S3BucketOnCloud varchar(4000)'
EXECUTE SP_EXECUTESQL @sql
END

END


BEGIN

SET @COLM ='0'
SET @sql1='select @pcnt1 =count(*) from information_schema.columns where column_name=''KeepJobFilesOnSuccess'' AND TABLE_NAME=''DA_CONFIG'''
EXECUTE SP_EXECUTESQL @sql1, N' @pcnt1 INT OUTPUT',
			@pcnt1 = @COLM OUTPUT
END



if(@COLM>'0')
begin
set @sql = 'update DA_JOB_NAMES
set DocumentManagementEnabled = (select d.DocumentManagementEnabled from da_config d where d.dsnid=dsnid),
rmADocumentPoolPath = (select d.rmADocumentPoolPath from da_config d where d.dsnid=dsnid),
KeepJobFilesOnSuccess = (select d.KeepJobFilesOnSuccess from da_config d where d.dsnid=dsnid)
where dsnid = (select t.dsnid from da_config t where t.dsnid=dsnid)';

EXECUTE SP_EXECUTESQL @sql


end

else
begin
IF(@CT='0')
BEGIN

set @sql = 'update DA_JOB_NAMES
set DocumentManagementEnabled = (select d.DocumentManagementEnabled from da_config d where d.dsnid=dsnid),
rmADocumentPoolPath = (select d.rmADocumentPoolPath from da_config d where d.dsnid=dsnid)
where dsnid = (select t.dsnid from da_config t where t.dsnid=dsnid)';

EXECUTE SP_EXECUTESQL @sql
END
end


BEGIN

SET @COLS ='0'
SET @sql1='select @pcnt1 =count(*) from information_schema.columns where column_name=''S3BucketOnCloud'' AND TABLE_NAME=''DA_CONFIG'''
EXECUTE SP_EXECUTESQL @sql1, N' @pcnt1 INT OUTPUT',
			@pcnt1 = @COLS OUTPUT
END

if(@COLS='0')
begin
set @sql = 'ALTER TABLE DA_CONFIG ADD S3BucketOnCloud varchar(4000)'
EXECUTE SP_EXECUTESQL @sql

end



BEGIN
SET @CNT='0'
SET @sql='select @pcnt = count(*) from information_schema.columns where column_name=''DocumentManagementEnabled'' AND TABLE_NAME=''DA_CONFIG'''
EXECUTE SP_EXECUTESQL @sql, N' @pcnt INT OUTPUT',
			@pcnt = @cnt OUTPUT
END
if(@CNT>'0')
BEGIN

set @sql = 'ALTER TABLE DA_CONFIG DROP COLUMN DocumentManagementEnabled,rmADocumentPoolPath'
EXECUTE SP_EXECUTESQL @sql

END


if(@COLM>'0')
BEGIN

set @sql = 'ALTER TABLE DA_CONFIG DROP COLUMN KeepJobFilesOnSuccess'
EXECUTE SP_EXECUTESQL @sql

END
END


