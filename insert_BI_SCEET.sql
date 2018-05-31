USE [BI_SCEET]
GO

/****** Object:  StoredProcedure [dbo].[insert_BI_SCEET_tst]    Script Date: 31/05/2018 11:25:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[insert_BI_SCEET] 
AS


-- on vide préalablement les tables

	TRUNCATE TABLE [BI_SCEET].[dbo].[FI_D6_Inventory]
	TRUNCATE TABLE [BI_SCEET].[dbo].[FI_D7_Sales]
	TRUNCATE TABLE [BI_SCEET].[dbo].[FI_D8_CustomerOrders]
	TRUNCATE TABLE [BI_SCEET].[dbo].[LO_D4_Movements]
	TRUNCATE TABLE [BI_SCEET].[dbo].[LO_D5_SupplierOrders]
	TRUNCATE TABLE [BI_SCEET].[dbo].[T01_References]
	TRUNCATE TABLE [BI_SCEET].[dbo].[T02_Customers]
	TRUNCATE TABLE [BI_SCEET].[dbo].[T03_Suppliers]
	TRUNCATE TABLE [BI_SCEET].[dbo].[T12_RefCustomer]
	TRUNCATE TABLE [BI_SCEET].[dbo].[T13_RefSupplier]

-- Requete FI_D6_Inventory

	INSERT INTO [BI_SCEET].[dbo].[FI_D6_Inventory] (
		[BI_SCEET].[dbo].[FI_D6_Inventory].Internal_reference,
		[BI_SCEET].[dbo].[FI_D6_Inventory].Inventory_quantity,
		[BI_SCEET].[dbo].[FI_D6_Inventory].Inventory_date,
		[BI_SCEET].[dbo].[FI_D6_Inventory].Inventory_location, 
		[BI_SCEET].[dbo].[FI_D6_Inventory].Inventory_unitprice,
		[BI_SCEET].[dbo].[FI_D6_Inventory].LastMovement_date
	)
		
	SELECT 
		[SCEET].[dbo].[ARTICLE].GA_CODEARTICLE AS Internal_reference,
		[SCEET].[dbo].[DISPO].GQ_PHYSIQUE AS Inventory_quantity,
		[SCEET].[dbo].[DISPO].GQ_DATEINVENTAIRE AS Inventory_date,
		[SCEET].[dbo].[DISPO].GQ_DEPOT AS Inventory_location, 
		[SCEET].[dbo].[DISPO].GQ_PMRP AS Inventory_unitprice,
		[SCEET].[dbo].[STKMOUVEMENT].GSM_DATEMVT AS LastMovement_date
	FROM 
		[SCEET].[dbo].[DISPO]
			INNER JOIN [SCEET].[dbo].[STKMOUVEMENT]
				ON 
				[SCEET].[dbo].[DISPO].GQ_ARTICLE = [SCEET].[dbo].[STKMOUVEMENT].GSM_ARTICLE
			LEFT JOIN [SCEET].[dbo].[ARTICLE] ON GQ_ARTICLE = GA_ARTICLE --adding the left join!
	

-- Requete FI_D7_Sales

	INSERT INTO [BI_SCEET].[dbo].[FI_D7_Sales] (
		[BI_SCEET].[dbo].[FI_D7_Sales].Internal_reference,
		[BI_SCEET].[dbo].[FI_D7_Sales].Customer_code,
		[BI_SCEET].[dbo].[FI_D7_Sales].InvoiceNumber,
		[BI_SCEET].[dbo].[FI_D7_Sales].Value_in_currency, 
		[BI_SCEET].[dbo].[FI_D7_Sales].Currency_code,
		[BI_SCEET].[dbo].[FI_D7_Sales].Qty,
		[BI_SCEET].[dbo].[FI_D7_Sales].Selling_date
	)

	SELECT
		[SCEET].[dbo].[LIGNE].GL_CODEARTICLE AS Internal_reference,
		[SCEET].[dbo].[LIGNE].GL_TIERS AS Customer_code,
		[SCEET].[dbo].[LIGNE].GL_NUMERO AS InvoiceNumber,
		[SCEET].[dbo].[LIGNE].GL_TOTALHTDEV AS Value_in_currency,
		[SCEET].[dbo].[PIECE].GP_DEVISE AS Currency_code,
		[SCEET].[dbo].[PIECE].GP_TOTALQTESTOCK AS Qty,
		[SCEET].[dbo].[PIECE].GP_DATECREATION AS Selling_date


	FROM 
		[SCEET].[dbo].[LIGNE]
			INNER JOIN [SCEET].[dbo].[PIECE] -- change from left join to inner join
				ON
				[SCEET].[dbo].[PIECE].GP_NUMERO = [SCEET].[dbo].[LIGNE].GL_NUMERO -- adding extra columns on the join
				AND [SCEET].[dbo].[LIGNE].GL_NATUREPIECEG = [SCEET].[dbo].[PIECE].GP_NATUREPIECEG 
				AND [SCEET].[dbo].[LIGNE].GL_SOUCHE = [SCEET].[dbo].[PIECE].GP_SOUCHE 
				AND [SCEET].[dbo].[PIECE].GP_INDICEG = [SCEET].[dbo].[LIGNE].GL_INDICEG
	WHERE 
		--[SCEET].[dbo].[LIGNE].GL_NATUREPIECEG = 'BLC' -- old version
		[SCEET].[dbo].[LIGNE].GL_NATUREPIECEG = 'FAC'
		AND [SCEET].[dbo].[LIGNE].GL_CODEARTICLE != ''
	

-- Requete FI_D8_CustomerOrders
	
	INSERT INTO [BI_SCEET].[dbo].[FI_D8_CustomerOrders] (
		[BI_SCEET].[dbo].[FI_D8_CustomerOrders].Internal_reference,
		[BI_SCEET].[dbo].[FI_D8_CustomerOrders].Customer_code,
		[BI_SCEET].[dbo].[FI_D8_CustomerOrders].Quantity_requested,
		[BI_SCEET].[dbo].[FI_D8_CustomerOrders].Quantity_delivered,
		[BI_SCEET].[dbo].[FI_D8_CustomerOrders].Order_date,
		[BI_SCEET].[dbo].[FI_D8_CustomerOrders].Date_expected,
		[BI_SCEET].[dbo].[FI_D8_CustomerOrders].Date_accepted,
		[BI_SCEET].[dbo].[FI_D8_CustomerOrders].Date_completed
	)
	
	SELECT
		[SCEET].[dbo].[LIGNE].GL_CODEARTICLE AS Internal_reference,
		[SCEET].[dbo].[LIGNE].GL_TIERS AS Customer_code,
		[SCEET].[dbo].[LIGNE].GL_QTERESTE AS Quantity_requested,
		[SCEET].[dbo].[LIGNE].GL_QTESTOCK AS Quantity_delivered,
		[SCEET].[dbo].[LIGNE].GL_DATECREATION AS Order_date,
		[SCEET].[dbo].[LIGNE].GL_DATELIVRAISON AS Date_expected,
		[SCEET].[dbo].[LIGNE].GL_DATELIVRAISON AS Date_accepted,
		[SCEET].[dbo].[LIGNE].GL_DATECREATION AS Date_completed
	FROM 
		[SCEET].[dbo].[LIGNE]

-- Requete LO_D4_Movements
	
	INSERT INTO [BI_SCEET].[dbo].[LO_D4_Movements] (
		[BI_SCEET].[dbo].[LO_D4_Movements].from_code,
		[BI_SCEET].[dbo].[LO_D4_Movements].to_code,
		[BI_SCEET].[dbo].[LO_D4_Movements].Internal_reference,
		[BI_SCEET].[dbo].[LO_D4_Movements].shipment_number,
		[BI_SCEET].[dbo].[LO_D4_Movements].PO_number,
		[BI_SCEET].[dbo].[LO_D4_Movements].Movement_date,
		[BI_SCEET].[dbo].[LO_D4_Movements].Quantity,
		[BI_SCEET].[dbo].[LO_D4_Movements].Movement_value
	)
	
	SELECT
		[SCEET].[dbo].[STKMOUVEMENT].GSM_TIERS AS from_code,
		[SCEET].[dbo].[STKMOUVEMENT].GSM_TIERS AS to_code,
		[SCEET].[dbo].[ARTICLE].GA_CODEARTICLE AS Internal_reference,
		[SCEET].[dbo].[RTINFOS00D].RDD_RDDLIBTEXTE2 AS shipment_number,
		REPLACE(CONCAT([SCEET].[dbo].[STKMOUVEMENT].GSM_NATUREORI,STR([SCEET].[dbo].[STKMOUVEMENT].GSM_NUMEROORI)),' ', '') AS PO_number, -- concatenating GSM_NATUREORI and GSM_NUMEROORI plus removing the space between
		[SCEET].[dbo].[STKMOUVEMENT].GSM_DATEMVT AS Movement_date,
		[SCEET].[dbo].[STKMOUVEMENT].GSM_PHYSIQUE AS Quantity,
		[SCEET].[dbo].[STKMOUVEMENT].GSM_MONTANT AS Movement_value
	FROM 
		[SCEET].[dbo].[PIECE]
			LEFT JOIN 
				[SCEET].[dbo].[STKMOUVEMENT]
				ON 
				[SCEET].[dbo].[STKMOUVEMENT].GSM_NUMEROORI = [SCEET].[dbo].[PIECE].GP_NUMERO
			LEFT JOIN 
				[SCEET].[dbo].[RTINFOS00D]
				ON [SCEET].[dbo].[PIECE].GP_NBTRANSMIS = [SCEET].[dbo].[RTINFOS00D].RDD_CLEDATA
			LEFT JOIN 
				[SCEET].[dbo].[ARTICLE]
				ON [SCEET].[dbo].[ARTICLE].GA_ARTICLE = [SCEET].[dbo].[STKMOUVEMENT].GSM_ARTICLE
	
	

-- Requete LO_D5_SupplierOrders
	
	INSERT INTO [BI_SCEET].[dbo].[LO_D5_SupplierOrders] (
		[BI_SCEET].[dbo].[LO_D5_SupplierOrders].Internal_reference,
		[BI_SCEET].[dbo].[LO_D5_SupplierOrders].Supplier_code,
		[BI_SCEET].[dbo].[LO_D5_SupplierOrders].Quantity_requested,
		[BI_SCEET].[dbo].[LO_D5_SupplierOrders].Quantity_delivered,
		[BI_SCEET].[dbo].[LO_D5_SupplierOrders].Order_date,
		[BI_SCEET].[dbo].[LO_D5_SupplierOrders].Date_expected,
		[BI_SCEET].[dbo].[LO_D5_SupplierOrders].Date_accepted,
		[BI_SCEET].[dbo].[LO_D5_SupplierOrders].Date_completed
	)
	
	SELECT
		[SCEET].[dbo].[LIGNE].GL_CODEARTICLE AS Internal_reference,
		[SCEET].[dbo].[LIGNE].GL_TIERS AS Supplier_code,
		[SCEET].[dbo].[LIGNE].GL_QTERESTE AS Quantity_requested,
		[SCEET].[dbo].[LIGNE].GL_QTESTOCK AS Quantity_delivered,
		[SCEET].[dbo].[LIGNE].GL_DATECREATION AS Order_date,
		[SCEET].[dbo].[LIGNE].GL_DATELIVRAISON AS Date_expected,
		[SCEET].[dbo].[LIGNE].GL_DATELIVRAISON AS Date_accepted,
		[SCEET].[dbo].[LIGNE].GL_DATECREATION AS Date_completed
	FROM 
		[SCEET].[dbo].[LIGNE]
	

-- Requete T01_References
	
	INSERT INTO [BI_SCEET].[dbo].[T01_References] (
		[BI_SCEET].[dbo].[T01_References].Internal_reference,
		[BI_SCEET].[dbo].[T01_References].Reference_description,
		[BI_SCEET].[dbo].[T01_References].Segment_code,
		[BI_SCEET].[dbo].[T01_References].Storage_unit,
		[BI_SCEET].[dbo].[T01_References].Production_unit,
		[BI_SCEET].[dbo].[T01_References].Production_line,
		[BI_SCEET].[dbo].[T01_References].Cogs_rm,
		[BI_SCEET].[dbo].[T01_References].Cogs_dl,
		[BI_SCEET].[dbo].[T01_References].Cogs_voh,
		[BI_SCEET].[dbo].[T01_References].Inventory_status,
		[BI_SCEET].[dbo].[T01_References].Product_netweight,
		[BI_SCEET].[dbo].[T01_References].Inventory_price,
		[BI_SCEET].[dbo].[T01_References].Product_trading,
		[BI_SCEET].[dbo].[T01_References].HS_code,
		[BI_SCEET].[dbo].[T01_References].Country_origin
	)

	SELECT
		[SCEET].[dbo].[ARTICLE].GA_CODEARTICLE AS Internal_reference,
		[SCEET].[dbo].[ARTICLE].GA_LIBELLE AS Reference_description,
		[SCEET].[dbo].[ARTICLE].GA_FAMILLENIV2 AS Segment_code,
		[SCEET].[dbo].[ARTICLE].GA_QUALIFUNITESTO AS Storage_unit,
		[SCEET].[dbo].[ARTICLE].GA_UNITECONSO AS Production_unit,
		[SCEET].[dbo].[ARTICLE].GA_CHARLIBRE2 AS Production_line,
		[SCEET].[dbo].[ARTICLE].GA_PMAP AS Cogs_rm,
		[SCEET].[dbo].[ARTICLE].GA_PMRP AS Cogs_dl,
		0 AS Cogs_voh,
		[SCEET].[dbo].[ARTICLE].GA_LIBREART3 AS Inventory_status,
		[SCEET].[dbo].[ARTICLE].GA_POIDSNET AS Product_netweight,
		0 AS Inventory_price,
		[SCEET].[dbo].[ARTICLE].GA_BOOLLIBRE2 AS Product_trading,
		[SCEET].[dbo].[ARTICLE].GA_CODEDOUANIER AS HS_code,
		[SCEET].[dbo].[ARTICLE].GA_PAYSORIGINE AS Country_origin

	FROM 
		[SCEET].[dbo].[ARTICLE]
	
	
-- Requete T02_Customers

	INSERT INTO [BI_SCEET].[dbo].[T02_Customers] (
		[BI_SCEET].[dbo].[T02_Customers].Customer_code,
		[BI_SCEET].[dbo].[T02_Customers].Customer_name,
		[BI_SCEET].[dbo].[T02_Customers].Global_customer,
		[BI_SCEET].[dbo].[T02_Customers].Address1,
		[BI_SCEET].[dbo].[T02_Customers].Address2,
		[BI_SCEET].[dbo].[T02_Customers].Address3,
		[BI_SCEET].[dbo].[T02_Customers].Address4,
		[BI_SCEET].[dbo].[T02_Customers].City,
		[BI_SCEET].[dbo].[T02_Customers].ZipCode,
		[BI_SCEET].[dbo].[T02_Customers].Country_ISO3,
		[BI_SCEET].[dbo].[T02_Customers].Incoterm,
		[BI_SCEET].[dbo].[T02_Customers].Incoterm_location,
		[BI_SCEET].[dbo].[T02_Customers].Incoterm_via,
		[BI_SCEET].[dbo].[T02_Customers].Account_manager,
		[BI_SCEET].[dbo].[T02_Customers].Min_order_qty,
		[BI_SCEET].[dbo].[T02_Customers].Min_order_value,
		[BI_SCEET].[dbo].[T02_Customers].Payment_term_days,
		[BI_SCEET].[dbo].[T02_Customers].Payment_term_type
	)

	SELECT DISTINCT
		[SCEET].[dbo].[TIERS].T_TIERS AS Customer_code,
		[SCEET].[dbo].[TIERS].T_LIBELLE AS Customer_name,
		[SCEET].[dbo].[TIERS].T_SOCIETEGROUPE AS Global_customer,
		[SCEET].[dbo].[TIERS].T_ADRESSE1 AS Address1,
		[SCEET].[dbo].[TIERS].T_ADRESSE2 AS Address2,
		[SCEET].[dbo].[TIERS].T_ADRESSE3 AS Address3,
		'' AS Address4,
		[SCEET].[dbo].[TIERS].T_VILLE AS City,
		[SCEET].[dbo].[TIERS].T_CODEPOSTAL AS ZipCode,
		[SCEET].[dbo].[TIERS].T_PAYS AS Country_ISO3,
		[SCEET].[dbo].[TIERSCOMPL].YTC_INCOTERM AS Incoterm,
		[SCEET].[dbo].[TIERSCOMPL].YTC_LIEUDISPO AS Incoterm_location,
		[SCEET].[dbo].[TIERSCOMPL].YTC_DEPOT AS Incoterm_via,
		[SCEET].[dbo].[TIERSCOMPL].YTC_TABLELIBRETIERS2 AS Account_manager,
		0 AS Min_order_qty,
		0 AS Min_order_value,
		[SCEET].[dbo].[TIERS].T_MODEREGLE AS Payment_term_days,
		[SCEET].[dbo].[TIERS].T_MODEREGLE AS Payment_term_type
	FROM 
		[SCEET].[dbo].[TIERS]
			INNER JOIN [SCEET].[dbo].[TIERSCOMPL] 
				ON 
				[SCEET].[dbo].[TIERSCOMPL].YTC_TIERS = [SCEET].[dbo].[TIERS].T_TIERS
	WHERE [TIERS].T_TIERS LIKE 'C%' -- Customer_code always starts with a C, C for Client

	
	
-- Requete T03_Suppliers

	INSERT INTO [BI_SCEET].[dbo].[T03_Suppliers] (
		[BI_SCEET].[dbo].[T03_Suppliers].Supplier_code,
		[BI_SCEET].[dbo].[T03_Suppliers].Supplier_name,
		[BI_SCEET].[dbo].[T03_Suppliers].Global_supplier,
		[BI_SCEET].[dbo].[T03_Suppliers].Address1,
		[BI_SCEET].[dbo].[T03_Suppliers].Address2,
		[BI_SCEET].[dbo].[T03_Suppliers].Address3,
		[BI_SCEET].[dbo].[T03_Suppliers].Address4,
		[BI_SCEET].[dbo].[T03_Suppliers].City,
		[BI_SCEET].[dbo].[T03_Suppliers].ZipCode,
		[BI_SCEET].[dbo].[T03_Suppliers].Country_ISO3,
		[BI_SCEET].[dbo].[T03_Suppliers].Incoterm,
		[BI_SCEET].[dbo].[T03_Suppliers].Incoterm_location,
		[BI_SCEET].[dbo].[T03_Suppliers].Incoterm_via,
		[BI_SCEET].[dbo].[T03_Suppliers].Account_manager,
		[BI_SCEET].[dbo].[T03_Suppliers].Min_order_qty,
		[BI_SCEET].[dbo].[T03_Suppliers].Min_order_value,
		[BI_SCEET].[dbo].[T03_Suppliers].Payment_term_days,
		[BI_SCEET].[dbo].[T03_Suppliers].Payment_term_type,
		[BI_SCEET].[dbo].[T03_Suppliers].Supplier_revision_level
	)
	
	SELECT DISTINCT
		[SCEET].[dbo].[TIERS].T_TIERS AS Supplier_code,
		[SCEET].[dbo].[TIERS].T_LIBELLE AS Supplier_name,
		[SCEET].[dbo].[TIERS].T_COMMENTAIRE AS Global_supplier,
		[SCEET].[dbo].[TIERS].T_ADRESSE1 AS Address1,
		[SCEET].[dbo].[TIERS].T_ADRESSE2 AS Address2,
		[SCEET].[dbo].[TIERS].T_ADRESSE3 AS Address3,
		'' AS Address4,
		[SCEET].[dbo].[TIERS].T_VILLE AS City,
		[SCEET].[dbo].[TIERS].T_CODEPOSTAL AS ZipCode,
		[SCEET].[dbo].[TIERS].T_PAYS AS Country_ISO3,
		[SCEET].[dbo].[TIERSCOMPL].YTC_INCOTERM AS Incoterm,
		[SCEET].[dbo].[CATALOGU].GCA_LIBREGCA2 AS Incoterm_location,
		[SCEET].[dbo].[TIERSCOMPL].YTC_DEPOT AS Incoterm_via,
		[SCEET].[dbo].[TIERSCOMPL].YTC_TABLELIBREFOU1 AS Account_manager,
		0 AS Min_order_qty,
		0 AS Min_order_value,
		[SCEET].[dbo].[TIERS].T_MODEREGLE AS Payment_term_days,
		[SCEET].[dbo].[TIERS].T_MODEREGLE AS Payment_term_type,
		'' AS Supplier_revision_level
	FROM 
		[SCEET].[dbo].[TIERS]
			INNER JOIN [SCEET].[dbo].[CATALOGU]
				ON
				[SCEET].[dbo].[CATALOGU].GCA_TIERS = [SCEET].[dbo].[TIERS].T_TIERS
			INNER JOIN [SCEET].[dbo].[TIERSCOMPL]
				ON 
				[SCEET].[dbo].[TIERSCOMPL].YTC_TIERS = [SCEET].[dbo].[TIERS].T_TIERS
		
	
	
-- Requete T12_RefCustomer
	
	INSERT INTO [BI_SCEET].[dbo].[T12_RefCustomer] (
		[BI_SCEET].[dbo].[T12_RefCustomer].Customer_code,
		[BI_SCEET].[dbo].[T12_RefCustomer].Internal_reference,
		[BI_SCEET].[dbo].[T12_RefCustomer].Customer_reference,
		[BI_SCEET].[dbo].[T12_RefCustomer].Application_code,
		[BI_SCEET].[dbo].[T12_RefCustomer].Selling_unit,
		[BI_SCEET].[dbo].[T12_RefCustomer].Selling_price,
		[BI_SCEET].[dbo].[T12_RefCustomer].Selling_currency,
		[BI_SCEET].[dbo].[T12_RefCustomer].Consigned,
		[BI_SCEET].[dbo].[T12_RefCustomer].Eco_order_qty,
		[BI_SCEET].[dbo].[T12_RefCustomer].Pack_order_qty,
		[BI_SCEET].[dbo].[T12_RefCustomer].Min_order_qty,
		[BI_SCEET].[dbo].[T12_RefCustomer].Min_order_value,
		[BI_SCEET].[dbo].[T12_RefCustomer].Product_grossweight,
		[BI_SCEET].[dbo].[T12_RefCustomer].Product_grosscube,
		[BI_SCEET].[dbo].[T12_RefCustomer].Leadtime_days,
		[BI_SCEET].[dbo].[T12_RefCustomer].Ref_price,
		[BI_SCEET].[dbo].[T12_RefCustomer].Customer_active,
		[BI_SCEET].[dbo].[T12_RefCustomer].Global_customer
	)

	SELECT 
	    DISTINCT
		[SCEET].[dbo].[ARTICLETIERS].GAT_REFTIERS AS Customer_code,
		[SCEET].[dbo].[ARTICLE].GA_CODEARTICLE AS Internal_reference,
		[SCEET].[dbo].[ARTICLETIERS].GAT_REFARTICLE AS Customer_reference,
		[SCEET].[dbo].[ARTICLE].GA_FAMILLENIV1 AS Application_code,
		[SCEET].[dbo].[ARTICLE].GA_QUALIFUNITEVTE AS Selling_unit,
		[SCEET].[dbo].[YTARIFS].YTS_PRIXNET AS Selling_price,
		[SCEET].[dbo].[TIERS].T_DEVISE AS Selling_currency,
		[SCEET].[dbo].[ZREFERENCEMENT].ZRF_DECISIONLIBRE1 AS Consigned,
		[SCEET].[dbo].[CATALOGU].GCA_QECOACH AS Eco_order_qty,
		[SCEET].[dbo].[ARTICLETIERS].GAT_QTEARTUC AS Pack_order_qty,
		[SCEET].[dbo].[ARTICLETIERS].GAT_QTEARTUC AS Min_order_qty,
		0 AS Min_order_value,
		0 AS Product_grossweight,
		0 AS Product_grosscube,
		[SCEET].[dbo].[ARTICLETIERS].GAT_DELAIMOYEN AS Leadtime_days,
		0 AS Ref_price,
		0 AS Customer_active,
		[SCEET].[dbo].[TIERS].T_SOCIETEGROUPE AS Global_customer
	FROM 
		[SCEET].[dbo].[ARTICLE]
			LEFT JOIN [SCEET].[dbo].[CATALOGU]
				ON
				[SCEET].[dbo].[ARTICLE].GA_ARTICLE = [SCEET].[dbo].[CATALOGU].GCA_ARTICLE
			LEFT JOIN [SCEET].[dbo].[ARTICLETIERS]
				ON
				[SCEET].[dbo].[ARTICLETIERS].GAT_ARTICLE = [SCEET].[dbo].[ARTICLE].GA_ARTICLE
			LEFT JOIN [SCEET].[dbo].[TIERS]
				ON
				[SCEET].[dbo].[ARTICLETIERS].GAT_REFTIERS = [SCEET].[dbo].[TIERS].T_TIERS
			LEFT JOIN [SCEET].[dbo].[YTARIFS]
				ON
				[SCEET].[dbo].[ARTICLE].GA_ARTICLE = [SCEET].[dbo].[YTARIFS].YTS_ARTICLE
			LEFT JOIN [SCEET].[dbo].[ZREFERENCEMENT]
				ON
				[SCEET].[dbo].[ARTICLETIERS].GAT_ARTICLE = [SCEET].[dbo].[ZREFERENCEMENT].ZRF_REFARTICLE 
				AND [SCEET].[dbo].[TIERS].T_TIERS = [SCEET].[dbo].[ZREFERENCEMENT].ZRF_REFTIERS
			LEFT JOIN [SCEET].[dbo].[LIGNE]
				ON 
				[SCEET].[dbo].[LIGNE].GL_TIERSLIVRE = [SCEET].[dbo].[TIERS].T_TIERS
	WHERE
		[SCEET].[dbo].[LIGNE].GL_NATUREPIECEG = 'BLC' 

	
	
-- Requete T13_RefSupplier ok

	INSERT INTO [BI_SCEET].[dbo].[T13_RefSupplier] (
		[BI_SCEET].[dbo].[T13_RefSupplier].Supplier_code,
		[BI_SCEET].[dbo].[T13_RefSupplier].Internal_reference,
		[BI_SCEET].[dbo].[T13_RefSupplier].Supplier_reference,
		[BI_SCEET].[dbo].[T13_RefSupplier].Family_code,
		[BI_SCEET].[dbo].[T13_RefSupplier].Purchasing_unit,
		[BI_SCEET].[dbo].[T13_RefSupplier].Purchasing_price,
		[BI_SCEET].[dbo].[T13_RefSupplier].Purchasing_currency,
		[BI_SCEET].[dbo].[T13_RefSupplier].Consigned,
		[BI_SCEET].[dbo].[T13_RefSupplier].Eco_order_qty,
		[BI_SCEET].[dbo].[T13_RefSupplier].Pack_order_qty,
		[BI_SCEET].[dbo].[T13_RefSupplier].Min_order_qty,
		[BI_SCEET].[dbo].[T13_RefSupplier].Min_order_value,
		[BI_SCEET].[dbo].[T13_RefSupplier].Product_grossweight,
		[BI_SCEET].[dbo].[T13_RefSupplier].Product_grosscube,
		[BI_SCEET].[dbo].[T13_RefSupplier].Leadtime_days,
		[BI_SCEET].[dbo].[T13_RefSupplier].Supplier_active,
		[BI_SCEET].[dbo].[T13_RefSupplier].Ref_price
	)
	
	SELECT
		[SCEET].[dbo].[CATALOGU].GCA_TIERS AS Supplier_code,
		[SCEET].[dbo].[ARTICLE].GA_CODEARTICLE AS Internal_reference, --changed to GA_CODEARTICLE
		[SCEET].[dbo].[CATALOGU].GCA_REFERENCE AS Supplier_reference,
		[SCEET].[dbo].[ARTICLE].GA_FAMILLENIV2 AS Family_code,
		[SCEET].[dbo].[CATALOGU].GCA_QUALIFUNITEACH AS Purchasing_unit,
		[SCEET].[dbo].[YTARIFS].YTS_PRIXNET AS Purchasing_price,
		[SCEET].[dbo].[TIERS].T_DEVISE AS Purchasing_currency,
		[SCEET].[dbo].[CATALOGU].GCA_BOOLLIBRE2 AS Consigned,
		[SCEET].[dbo].[CATALOGU].GCA_QECOACH AS Eco_order_qty,
		[SCEET].[dbo].[CATALOGU].GCA_QPCBACH AS Pack_order_qty,
		[SCEET].[dbo].[CATALOGU].GCA_QECOACH AS Min_order_qty,
		0 AS Min_order_value,
		0 AS Product_grossweight,
		0 AS Product_grosscube,
		[SCEET].[dbo].[CATALOGU].GCA_DELAILIVRAISON AS Leadtime_days,
		0 AS Supplier_active,
		0 AS Ref_price
	FROM 
		[SCEET].[dbo].[CATALOGU]
			INNER JOIN [SCEET].[dbo].[ARTICLE]
				ON
				[SCEET].[dbo].[ARTICLE].GA_ARTICLE = [SCEET].[dbo].[CATALOGU].GCA_ARTICLE
			INNER JOIN [SCEET].[dbo].[TIERS]
				ON
				[SCEET].[dbo].[CATALOGU].GCA_TIERS = [SCEET].[dbo].[TIERS].T_TIERS
			LEFT JOIN [SCEET].[dbo].[YTARIFS]
				ON
					[SCEET].[dbo].[CATALOGU].GCA_ARTICLE = [SCEET].[dbo].[YTARIFS].YTS_ARTICLE
					AND [SCEET].[dbo].[CATALOGU].GCA_TIERS = [SCEET].[dbo].[YTARIFS].YTS_TIERS
			LEFT JOIN [SCEET].[dbo].[LIGNE]
				ON 
				[SCEET].[dbo].[LIGNE].GL_TIERS = [SCEET].[dbo].[TIERS].T_TIERS
	WHERE
		[SCEET].[dbo].[LIGNE].GL_NATUREPIECEG = 'BLF' 
	
	

	
---- Requete T02_Customers

--	INSERT INTO [BI_SCEET].[dbo].[T02_Customers] (
--		[BI_SCEET].[dbo].[T02_Customers].Customer_code,
--		[BI_SCEET].[dbo].[T02_Customers].Customer_name,
--		[BI_SCEET].[dbo].[T02_Customers].Global_customer,
--		[BI_SCEET].[dbo].[T02_Customers].Address1,
--		[BI_SCEET].[dbo].[T02_Customers].Address2,
--		[BI_SCEET].[dbo].[T02_Customers].Address3,
--		[BI_SCEET].[dbo].[T02_Customers].Address4,
--		[BI_SCEET].[dbo].[T02_Customers].City,
--		[BI_SCEET].[dbo].[T02_Customers].ZipCode,
--		[BI_SCEET].[dbo].[T02_Customers].Country_ISO3,
--		[BI_SCEET].[dbo].[T02_Customers].Incoterm,
--		[BI_SCEET].[dbo].[T02_Customers].Incoterm_location,
--		[BI_SCEET].[dbo].[T02_Customers].Incoterm_via,
--		[BI_SCEET].[dbo].[T02_Customers].Account_manager,
--		[BI_SCEET].[dbo].[T02_Customers].Min_order_qty,
--		[BI_SCEET].[dbo].[T02_Customers].Min_order_value,
--		[BI_SCEET].[dbo].[T02_Customers].Payment_term_days,
--		[BI_SCEET].[dbo].[T02_Customers].Payment_term_type
--	)

--	SELECT DISTINCT
--		[SCEET].[dbo].[TIERS].T_TIERS AS Customer_code,
--		[SCEET].[dbo].[TIERS].T_LIBELLE AS Customer_name,
--		[SCEET].[dbo].[TIERS].T_SOCIETEGROUPE AS Global_customer,
--		[SCEET].[dbo].[TIERS].T_ADRESSE1 AS Address1,
--		[SCEET].[dbo].[TIERS].T_ADRESSE2 AS Address2,
--		[SCEET].[dbo].[TIERS].T_ADRESSE3 AS Address3,
--		'' AS Address4,
--		[SCEET].[dbo].[TIERS].T_VILLE AS City,
--		[SCEET].[dbo].[TIERS].T_CODEPOSTAL AS ZipCode,
--		[SCEET].[dbo].[TIERS].T_PAYS AS Country_ISO3,
--		[SCEET].[dbo].[TIERSCOMPL].YTC_INCOTERM AS Incoterm,
--		[SCEET].[dbo].[TIERSCOMPL].YTC_LIEUDISPO AS Incoterm_location,
--		[SCEET].[dbo].[TIERSCOMPL].YTC_DEPOT AS Incoterm_via,
--		[SCEET].[dbo].[TIERSCOMPL].YTC_TABLELIBRETIERS2 AS Account_manager,
--		0 AS Min_order_qty,
--		0 AS Min_order_value,
--		[SCEET].[dbo].[TIERS].T_MODEREGLE AS Payment_term_days,
--		[SCEET].[dbo].[TIERS].T_MODEREGLE AS Payment_term_type
--	FROM 
--		[SCEET].[dbo].[TIERS]
--			INNER JOIN [SCEET].[dbo].[TIERSCOMPL] 
--				ON 
--				[SCEET].[dbo].[TIERSCOMPL].YTC_TIERS = [SCEET].[dbo].[TIERS].T_TIERS
	
	
---- Requete T03_Suppliers

--	INSERT INTO [BI_SCEET].[dbo].[T03_Suppliers] (
--		[BI_SCEET].[dbo].[T03_Suppliers].Supplier_code,
--		[BI_SCEET].[dbo].[T03_Suppliers].Supplier_name,
--		[BI_SCEET].[dbo].[T03_Suppliers].Global_supplier,
--		[BI_SCEET].[dbo].[T03_Suppliers].Address1,
--		[BI_SCEET].[dbo].[T03_Suppliers].Address2,
--		[BI_SCEET].[dbo].[T03_Suppliers].Address3,
--		[BI_SCEET].[dbo].[T03_Suppliers].Address4,
--		[BI_SCEET].[dbo].[T03_Suppliers].City,
--		[BI_SCEET].[dbo].[T03_Suppliers].ZipCode,
--		[BI_SCEET].[dbo].[T03_Suppliers].Country_ISO3,
--		[BI_SCEET].[dbo].[T03_Suppliers].Incoterm,
--		[BI_SCEET].[dbo].[T03_Suppliers].Incoterm_location,
--		[BI_SCEET].[dbo].[T03_Suppliers].Incoterm_via,
--		[BI_SCEET].[dbo].[T03_Suppliers].Account_manager,
--		[BI_SCEET].[dbo].[T03_Suppliers].Min_order_qty,
--		[BI_SCEET].[dbo].[T03_Suppliers].Min_order_value,
--		[BI_SCEET].[dbo].[T03_Suppliers].Payment_term_days,
--		[BI_SCEET].[dbo].[T03_Suppliers].Payment_term_type,
--		[BI_SCEET].[dbo].[T03_Suppliers].Supplier_revision_level
--	)
	
--	SELECT
--		[SCEET].[dbo].[TIERS].T_TIERS AS Supplier_code,
--		[SCEET].[dbo].[TIERS].T_LIBELLE AS Supplier_name,
--		[SCEET].[dbo].[TIERS].T_COMMENTAIRE AS Global_supplier,
--		[SCEET].[dbo].[TIERS].T_ADRESSE1 AS Address1,
--		[SCEET].[dbo].[TIERS].T_ADRESSE2 AS Address2,
--		[SCEET].[dbo].[TIERS].T_ADRESSE3 AS Address3,
--		'' AS Address4,
--		[SCEET].[dbo].[TIERS].T_VILLE AS City,
--		[SCEET].[dbo].[TIERS].T_CODEPOSTAL AS ZipCode,
--		[SCEET].[dbo].[TIERS].T_PAYS AS Country_ISO3,
--		[SCEET].[dbo].[TIERSCOMPL].YTC_INCOTERM AS Incoterm,
--		[SCEET].[dbo].[CATALOGU].GCA_LIBREGCA2 AS Incoterm_location,
--		[SCEET].[dbo].[TIERSCOMPL].YTC_DEPOT AS Incoterm_via,
--		[SCEET].[dbo].[TIERSCOMPL].YTC_TABLELIBREFOU1 AS Account_manager,
--		0 AS Min_order_qty,
--		0 AS Min_order_value,
--		[SCEET].[dbo].[TIERS].T_MODEREGLE AS Payment_term_days,
--		[SCEET].[dbo].[TIERS].T_MODEREGLE AS Payment_term_type,
--		0 AS Supplier_revision_level
--	FROM 
--		[SCEET].[dbo].[TIERS]
--			INNER JOIN [SCEET].[dbo].[CATALOGU]
--				ON
--				[SCEET].[dbo].[CATALOGU].GCA_TIERS = [SCEET].[dbo].[TIERS].T_TIERS
--			INNER JOIN [SCEET].[dbo].[TIERSCOMPL]
--				ON 
--				[SCEET].[dbo].[TIERSCOMPL].YTC_TIERS = [SCEET].[dbo].[TIERS].T_TIERS
		
	


---- Requete T12_RefCustomer
	
--	INSERT INTO [BI_SCEET].[dbo].[T12_RefCustomer] (
--		[BI_SCEET].[dbo].[T12_RefCustomer].Customer_code,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Internal_reference,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Customer_reference,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Application_code,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Selling_unit,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Selling_price,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Selling_currency,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Consigned,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Eco_order_qty,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Pack_order_qty,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Min_order_qty,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Min_order_value,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Product_grossweight,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Product_grosscube,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Leadtime_days,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Ref_price,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Customer_active,
--		[BI_SCEET].[dbo].[T12_RefCustomer].Global_customer
--	)

--	SELECT 
--		[SCEET].[dbo].[ARTICLETIERS].GAT_REFTIERS AS Customer_code,
--		[SCEET].[dbo].[ARTICLE].GA_CODEARTICLE AS Internal_reference,
--		[SCEET].[dbo].[ARTICLETIERS].GAT_REFARTICLE AS Customer_reference,
--		[SCEET].[dbo].[ARTICLE].GA_FAMILLENIV1 AS Application_code,
--		[SCEET].[dbo].[ARTICLE].GA_QUALIFUNITEVTE AS Selling_unit,
--		[SCEET].[dbo].[YTARIFS].YTS_PRIXNET AS Selling_price,
--		[SCEET].[dbo].[TIERS].T_DEVISE AS Selling_currency,
--		[SCEET].[dbo].[ZREFERENCEMENT].ZRF_DECISIONLIBRE1 AS Consigned,
--		[SCEET].[dbo].[CATALOGU].GCA_QECOACH AS Eco_order_qty,
--		[SCEET].[dbo].[CATALOGU].GCA_QPCBACH AS Pack_order_qty,
--		[SCEET].[dbo].[CATALOGU].GCA_QECOACH AS Min_order_qty,
--		0 AS Min_order_value,
--		0 AS Product_grossweight,
--		0 AS Product_grosscube,
--		[SCEET].[dbo].[ARTICLETIERS].GAT_DELAIMOYEN AS Leadtime_days,
--		0 AS Ref_price,
--		0 AS Customer_active,
--		[SCEET].[dbo].[TIERS].T_SOCIETEGROUPE AS Global_customer
--	FROM 
--		[SCEET].[dbo].[ARTICLE]
--			LEFT JOIN [SCEET].[dbo].[CATALOGU]
--				ON
--				[SCEET].[dbo].[ARTICLE].GA_ARTICLE = [SCEET].[dbo].[CATALOGU].GCA_ARTICLE
--			LEFT JOIN [SCEET].[dbo].[ARTICLETIERS]
--				ON
--				[SCEET].[dbo].[ARTICLETIERS].GAT_ARTICLE = [SCEET].[dbo].[ARTICLE].GA_ARTICLE
--			LEFT JOIN [SCEET].[dbo].[TIERS]
--				ON
--				[SCEET].[dbo].[ARTICLETIERS].GAT_REFTIERS = [SCEET].[dbo].[TIERS].T_TIERS
--			LEFT JOIN [SCEET].[dbo].[YTARIFS]
--				ON
--				[SCEET].[dbo].[ARTICLE].GA_ARTICLE = [SCEET].[dbo].[YTARIFS].YTS_ARTICLE
--			LEFT JOIN [SCEET].[dbo].[ZREFERENCEMENT]
--				ON
--				[SCEET].[dbo].[ARTICLETIERS].GAT_ARTICLE = [SCEET].[dbo].[ZREFERENCEMENT].ZRF_REFARTICLE 
--				AND [SCEET].[dbo].[TIERS].T_TIERS = [SCEET].[dbo].[ZREFERENCEMENT].ZRF_REFTIERS
--			LEFT JOIN [SCEET].[dbo].[LIGNE]
--				ON 
--				[SCEET].[dbo].[LIGNE].GL_TIERSLIVRE = [SCEET].[dbo].[TIERS].T_TIERS
--	WHERE
--		[SCEET].[dbo].[LIGNE].GL_NATUREPIECEG = 'BLC' 

	
	
-- Requete T13_RefSupplier

	--INSERT INTO [BI_SCEET].[dbo].[T13_RefSupplier] (
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Supplier_code,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Internal_reference,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Supplier_reference,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Family_code,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Purchasing_unit,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Purchasing_price,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Purchasing_currency,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Consigned,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Eco_order_qty,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Pack_order_qty,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Min_order_qty,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Min_order_value,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Product_grossweight,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Product_grosscube,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Leadtime_days,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Supplier_active,
	--	[BI_SCEET].[dbo].[T13_RefSupplier].Ref_price
	--)
	
	--SELECT
	--	[SCEET].[dbo].[CATALOGU].GCA_TIERS AS Supplier_code,
	--	[SCEET].[dbo].[CATALOGU].GCA_ARTICLE AS Internal_reference,
	--	[SCEET].[dbo].[CATALOGU].GCA_REFERENCE AS Supplier_reference,
	--	[SCEET].[dbo].[ARTICLE].GA_FAMILLENIV2 AS Family_code,
	--	[SCEET].[dbo].[CATALOGU].GCA_QUALIFUNITEACH AS Purchasing_unit,
	--	[SCEET].[dbo].[YTARIFS].YTS_PRIXNET AS Purchasing_price,
	--	[SCEET].[dbo].[TIERS].T_DEVISE AS Purchasing_currency,
	--	[SCEET].[dbo].[CATALOGU].GCA_BOOLLIBRE2 AS Consigned,
	--	[SCEET].[dbo].[CATALOGU].GCA_QECOACH AS Eco_order_qty,
	--	[SCEET].[dbo].[CATALOGU].GCA_QPCBACH AS Pack_order_qty,
	--	[SCEET].[dbo].[CATALOGU].GCA_QECOACH AS Min_order_qty,
	--	0 AS Min_order_value,
	--	0 AS Product_grossweight,
	--	0 AS Product_grosscube,
	--	[SCEET].[dbo].[CATALOGU].GCA_DELAILIVRAISON AS Leadtime_days,
	--	0 AS Supplier_active,
	--	0 AS Ref_price
	--FROM 
	--	[SCEET].[dbo].[CATALOGU]
	--		INNER JOIN [SCEET].[dbo].[ARTICLE]
	--			ON
	--			[SCEET].[dbo].[ARTICLE].GA_ARTICLE = [SCEET].[dbo].[CATALOGU].GCA_ARTICLE
	--		INNER JOIN [SCEET].[dbo].[TIERS]
	--			ON
	--			[SCEET].[dbo].[CATALOGU].GCA_TIERS = [SCEET].[dbo].[TIERS].T_TIERS
	--		LEFT JOIN [SCEET].[dbo].[YTARIFS]
	--			ON
	--				[SCEET].[dbo].[CATALOGU].GCA_ARTICLE = [SCEET].[dbo].[YTARIFS].YTS_ARTICLE
	--				AND [SCEET].[dbo].[CATALOGU].GCA_TIERS = [SCEET].[dbo].[YTARIFS].YTS_TIERS
	--		LEFT JOIN [SCEET].[dbo].[LIGNE]
	--			ON 
	--			[SCEET].[dbo].[LIGNE].GL_TIERSLIVRE = [SCEET].[dbo].[TIERS].T_TIERS
	--WHERE
	--	[SCEET].[dbo].[LIGNE].GL_NATUREPIECEG = 'BLF' 
	

GO


