--Database owners are as expected
--Remove people from Owner role where they should not be there...
SELECT USER_NAME(member_principal_id) AS [Owner]
--ALTER ROLE db_owner DROP MEMBER [XXX];
,      'ALTER ROLE db_owner DROP MEMBER [' + USER_NAME(member_principal_id) + '];' sql_to_remediate
FROM   sys.database_role_members
WHERE  USER_NAME(role_principal_id) = 'db_owner'
AND    USER_NAME(member_principal_id) != 'dbo'


-- Server-level firewall rules should be tracked and maintained at a strict minimum
SELECT name
,      start_ip_address
,      end_ip_address
FROM   sys.firewall_rules1


--Minimal set of principals should be granted ALTER or ALTER ANY USER database-scoped permissions
SELECT perms.class_desc AS [Permission Class]
    ,perms.permission_name AS Permission
    ,type_desc AS [Principal Type]
    ,prin.name AS Principal
--REVOKE XXX FROM YYY;
,      'REVOKE ' + perms.permission_name COLLATE DATABASE_DEFAULT + ' FROM [' + prin.name COLLATE DATABASE_DEFAULT + '];' sql_to_remediate
FROM sys.database_permissions AS perms
INNER JOIN sys.database_principals AS prin ON perms.grantee_principal_id = prin.principal_id
WHERE permission_name IN (
        'ALTER'
        ,'ALTER ANY USER'
        )
    AND user_name(grantee_principal_id) NOT IN (
        'guest'
        ,'public'
        )
    AND perms.class = 0
    AND [state] IN ('G','W')
    AND NOT (
        prin.type = 'S'
        AND prin.name = 'dbo'
        AND prin.authentication_type = 1
        AND prin.owning_principal_id IS NULL
        )

-- Minimal set of principals should be granted database-scoped ALTER permission on various securables		
WITH get_elements AS
(
SELECT REPLACE(REPLACE(perms.class_desc, 'DATABASE_PRINCIPAL', 'ROLE'), '_', ' ') AS [Permission Class]
    ,CASE
        WHEN perms.class = 3
            THEN schema_name(major_id) -- schema
        WHEN perms.class = 4
            THEN printarget.name -- principal
        WHEN perms.class = 5
            THEN asm.name -- assembly
        WHEN perms.class = 6
            THEN type_name(major_id) -- type
        WHEN perms.class = 10
            THEN xmlsc.name -- xml schema
        WHEN perms.class = 15
            THEN msgt.name COLLATE DATABASE_DEFAULT -- message types
        WHEN perms.class = 16
            THEN svcc.name COLLATE DATABASE_DEFAULT -- service contracts
        WHEN perms.class = 17
            THEN svcs.name COLLATE DATABASE_DEFAULT -- services
        WHEN perms.class = 18
            THEN rsb.name COLLATE DATABASE_DEFAULT -- remote service bindings
        WHEN perms.class = 19
            THEN rts.name COLLATE DATABASE_DEFAULT -- routes
        WHEN perms.class = 23
            THEN ftc.name -- full text catalog
        WHEN perms.class = 24
            THEN sym.name -- symmetric key
        WHEN perms.class = 25
            THEN crt.name -- certificate
        WHEN perms.class = 26
            THEN asym.name -- asymmetric key
        ELSE ''
        END AS [Object]
    ,perms.permission_name AS [Permission]
    ,prin.type_desc AS [Principal Type]
    ,prin.name AS [Principal]
FROM sys.database_permissions AS perms
LEFT JOIN sys.database_principals AS prin ON perms.grantee_principal_id = prin.principal_id
LEFT JOIN sys.assemblies AS asm ON perms.major_id = asm.assembly_id
LEFT JOIN sys.xml_schema_collections AS xmlsc ON perms.major_id = xmlsc.xml_collection_id
LEFT JOIN sys.service_message_types AS msgt ON perms.major_id = msgt.message_type_id
LEFT JOIN sys.service_contracts AS svcc ON perms.major_id = svcc.service_contract_id
LEFT JOIN sys.services AS svcs ON perms.major_id = svcs.service_id
LEFT JOIN sys.remote_service_bindings AS rsb ON perms.major_id = rsb.remote_service_binding_id
LEFT JOIN sys.routes AS rts ON perms.major_id = rts.route_id
LEFT JOIN sys.database_principals AS printarget ON perms.major_id = printarget.principal_id
LEFT JOIN sys.symmetric_keys AS sym ON perms.major_id = sym.symmetric_key_id
LEFT JOIN sys.asymmetric_keys AS asym ON perms.major_id = asym.asymmetric_key_id
LEFT JOIN sys.certificates AS crt ON perms.major_id = crt.certificate_id
LEFT JOIN sys.fulltext_catalogs AS ftc ON perms.major_id = ftc.fulltext_catalog_id
WHERE permission_name = 'ALTER'
    AND class IN (
        3
        ,4
        ,5
        ,6
        ,10
        ,15
        ,16
        ,17
        ,18
        ,19
        ,23
        ,24
        ,25
        ,26
        )
    AND user_name(grantee_principal_id) NOT IN (
        'guest'
        ,'public'
        )
    AND [state] IN ('G','W')
    AND NOT (
        prin.type = 'S'
        AND prin.name = 'dbo'
        AND prin.authentication_type = 1
        AND prin.owning_principal_id IS NULL
        )
)
SELECT [Permission Class]
,      Object
,      Permission
,      [Principal Type]
,      [Principal]
--REVOKE XXX FROM YYY;
,      'REVOKE ' + Permission + ' ON ' + [Permission Class] + ':: ' + Object + ' FROM [' + Principal COLLATE DATABASE_DEFAULT + '];' sql_to_remediate
FROM   get_elements

--Minimal set of principals should be granted high impact database-scoped permissions on various securables
WITH get_elements AS
(
SELECT REPLACE(perms.class_desc, '_', ' ') AS [Permission Class]
    ,CASE
        WHEN perms.class = 3
            THEN schema_name(major_id) -- schema
        WHEN perms.class = 4
            THEN printarget.name -- principal
        WHEN perms.class = 5
            THEN asm.name -- assembly
        WHEN perms.class = 6
            THEN type_name(major_id) -- type
        WHEN perms.class = 24
            THEN sym.name -- symmetric key
        WHEN perms.class = 25
            THEN crt.name -- certificate
        END AS [Object]
    ,perms.permission_name AS Permission
    ,prin.type_desc AS [Principal Type]
    ,prin.name AS Principal
FROM sys.database_permissions AS perms
LEFT JOIN sys.database_principals AS prin ON perms.grantee_principal_id = prin.principal_id
LEFT JOIN sys.assemblies AS asm ON perms.major_id = asm.assembly_id
LEFT JOIN sys.database_principals AS printarget ON perms.major_id = printarget.principal_id
LEFT JOIN sys.symmetric_keys AS sym ON perms.major_id = sym.symmetric_key_id
LEFT JOIN sys.certificates AS crt ON perms.major_id = crt.certificate_id
WHERE permission_name IN ('CONTROL', 'TAKE OWNERSHIP', 'REFERENCES')
    AND user_name(grantee_principal_id) NOT IN ('guest', 'public')
    AND class IN (3, 4, 5, 6, 10, 15, 16, 17, 18, 19, 23, 24, 25, 26)
    AND [state] IN ('G', 'W')
)
SELECT [Permission Class]
,      Object
,      Permission
,      [Principal Type]
,      [Principal]
--REVOKE XXX FROM YYY;
,      'REVOKE ' + Permission + ' ON ' + [Permission Class] + ':: ' + Object + ' FROM [' + Principal COLLATE DATABASE_DEFAULT + '];' sql_to_remediate
FROM   get_elements

