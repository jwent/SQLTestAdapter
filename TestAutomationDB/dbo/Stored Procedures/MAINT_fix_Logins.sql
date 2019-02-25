

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



