USE [BI_AVOCARBON]
GO

/****** Object:  StoredProcedure [dbo].[insert_BI_AVOCARBON_tst]    Script Date: 17/05/2018 17:00:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[insert_BI_AVOCARBON] 
AS


-- on vide préalablement les tables

	TRUNCATE TABLE [BI_AVOCARBON].[dbo].[FI_D6_Inventory]
	TRUNCATE TABLE [BI_AVOCARBON].[dbo].[FI_D7_Sales]
	TRUNCATE TABLE [BI_AVOCARBON].[dbo].[FI_D8_CustomerOrders]
	TRUNCATE TABLE [BI_AVOCARBON].[dbo].[LO_D4_Movements]
	TRUNCATE TABLE [BI_AVOCARBON].[dbo].[LO_D5_SupplierOrders]
	TRUNCATE TABLE [BI_AVOCARBON].[dbo].[T01_References]
	TRUNCATE TABLE [BI_AVOCARBON].[dbo].[T02_Customers]
	TRUNCATE TABLE [BI_AVOCARBON].[dbo].[T03_Suppliers]
	TRUNCATE TABLE [BI_AVOCARBON].[dbo].[T12_RefCustomer]
	TRUNCATE TABLE [BI_AVOCARBON].[dbo].[T13_RefSupplier]

-- Requete FI_D6_Inventory

	INSERT INTO [BI_AVOCARBON].[dbo].[FI_D6_Inventory] (
		[BI_AVOCARBON].[dbo].[FI_D6_Inventory].Internal_reference,
		[BI_AVOCARBON].[dbo].[FI_D6_Inventory].Inventory_quantity,
		[BI_AVOCARBON].[dbo].[FI_D6_Inventory].Inventory_date,
		[BI_AVOCARBON].[dbo].[FI_D6_Inventory].Inventory_location, 
		[BI_AVOCARBON].[dbo].[FI_D6_Inventory].Inventory_unitprice,
		[BI_AVOCARBON].[dbo].[FI_D6_Inventory].LastMovement_date
	)
		
	SELECT 
		[AVOCARBON].[dbo].[DISPO].GQ_ARTICLE AS Internal_reference,
		[AVOCARBON].[dbo].[DISPO].GQ_PHYSIQUE AS Inventory_quantity,
		[AVOCARBON].[dbo].[DISPO].GQ_DATEINVENTAIRE AS Inventory_date,
		[AVOCARBON].[dbo].[DISPO].GQ_DEPOT AS Inventory_location, 
		[AVOCARBON].[dbo].[DISPO].GQ_PMRP AS Inventory_unitprice,
		[AVOCARBON].[dbo].[STKMOUVEMENT].GSM_DATEMVT AS LastMovement_date
	FROM 
		[AVOCARBON].[dbo].[DISPO]
			INNER JOIN [AVOCARBON].[dbo].[STKMOUVEMENT]
				ON 
				[AVOCARBON].[dbo].[DISPO].GQ_ARTICLE = [AVOCARBON].[dbo].[STKMOUVEMENT].GSM_ARTICLE
	

-- Requete FI_D7_Sales

	INSERT INTO [BI_AVOCARBON].[dbo].[FI_D7_Sales] (
		[BI_AVOCARBON].[dbo].[FI_D7_Sales].Internal_reference,
		[BI_AVOCARBON].[dbo].[FI_D7_Sales].Customer_code,
		[BI_AVOCARBON].[dbo].[FI_D7_Sales].InvoiceNumber,
		[BI_AVOCARBON].[dbo].[FI_D7_Sales].Value_in_currency, 
		[BI_AVOCARBON].[dbo].[FI_D7_Sales].Currency_code,
		[BI_AVOCARBON].[dbo].[FI_D7_Sales].Qty,
		[BI_AVOCARBON].[dbo].[FI_D7_Sales].Selling_date
	)

	SELECT
		[AVOCARBON].[dbo].[LIGNE].GL_CODEARTICLE AS Internal_reference,
		[AVOCARBON].[dbo].[LIGNE].GL_TIERS AS Customer_code,
		[AVOCARBON].[dbo].[LIGNE].GL_NUMERO AS InvoiceNumber,
		[AVOCARBON].[dbo].[LIGNE].GL_TOTALHTDEV AS Value_in_currency,
		[AVOCARBON].[dbo].[PIECE].GP_DEVISE AS Currency_code,
		[AVOCARBON].[dbo].[PIECE].GP_TOTALQTESTOCK AS Qty,
		[AVOCARBON].[dbo].[PIECE].GP_DATECREATION AS Selling_date


	FROM 
		[AVOCARBON].[dbo].[LIGNE]
			LEFT JOIN [AVOCARBON].[dbo].[PIECE] 
				ON
				[AVOCARBON].[dbo].[PIECE].GP_NUMERO = [AVOCARBON].[dbo].[LIGNE].GL_NUMERO -- adding extra columns on the join
				AND [AVOCARBON].[dbo].[LIGNE].GL_NATUREPIECEG = [AVOCARBON].[dbo].[PIECE].GP_NATUREPIECEG 
				AND [AVOCARBON].[dbo].[LIGNE].GL_SOUCHE = [AVOCARBON].[dbo].[PIECE].GP_SOUCHE 
				AND [AVOCARBON].[dbo].[PIECE].GP_INDICEG = [AVOCARBON].[dbo].[LIGNE].GL_INDICEG
	WHERE 
		--[AVOCARBON].[dbo].[LIGNE].GL_NATUREPIECEG = 'BLC' -- old version
		[AVOCARBON].[dbo].[LIGNE].GL_NATUREPIECEG = 'FAC'
	

-- Requete FI_D8_CustomerOrders
	
	INSERT INTO [BI_AVOCARBON].[dbo].[FI_D8_CustomerOrders] (
		[BI_AVOCARBON].[dbo].[FI_D8_CustomerOrders].Internal_reference,
		[BI_AVOCARBON].[dbo].[FI_D8_CustomerOrders].Customer_code,
		[BI_AVOCARBON].[dbo].[FI_D8_CustomerOrders].Quantity_requested,
		[BI_AVOCARBON].[dbo].[FI_D8_CustomerOrders].Quantity_delivered,
		[BI_AVOCARBON].[dbo].[FI_D8_CustomerOrders].Order_date,
		[BI_AVOCARBON].[dbo].[FI_D8_CustomerOrders].Date_expected,
		[BI_AVOCARBON].[dbo].[FI_D8_CustomerOrders].Date_accepted,
		[BI_AVOCARBON].[dbo].[FI_D8_CustomerOrders].Date_completed
	)
	
	SELECT
		[AVOCARBON].[dbo].[LIGNE].GL_CODEARTICLE AS Internal_reference,
		[AVOCARBON].[dbo].[LIGNE].GL_TIERS AS Customer_code,
		[AVOCARBON].[dbo].[LIGNE].GL_QTERESTE AS Quantity_requested,
		[AVOCARBON].[dbo].[LIGNE].GL_QTESTOCK AS Quantity_delivered,
		[AVOCARBON].[dbo].[LIGNE].GL_DATECREATION AS Order_date,
		[AVOCARBON].[dbo].[LIGNE].GL_DATELIVRAISON AS Date_expected,
		[AVOCARBON].[dbo].[LIGNE].GL_DATELIVRAISON AS Date_accepted,
		[AVOCARBON].[dbo].[LIGNE].GL_DATECREATION AS Date_completed
	FROM 
		[AVOCARBON].[dbo].[LIGNE]

-- Requete LO_D4_Movements
	
	INSERT INTO [BI_AVOCARBON].[dbo].[LO_D4_Movements] (
		[BI_AVOCARBON].[dbo].[LO_D4_Movements].from_code,
		[BI_AVOCARBON].[dbo].[LO_D4_Movements].to_code,
		[BI_AVOCARBON].[dbo].[LO_D4_Movements].Internal_reference,
		[BI_AVOCARBON].[dbo].[LO_D4_Movements].shipment_number,
		[BI_AVOCARBON].[dbo].[LO_D4_Movements].PO_number,
		[BI_AVOCARBON].[dbo].[LO_D4_Movements].Movement_date,
		[BI_AVOCARBON].[dbo].[LO_D4_Movements].Quantity,
		[BI_AVOCARBON].[dbo].[LO_D4_Movements].Movement_value
	)
	
	SELECT
		[AVOCARBON].[dbo].[STKMOUVEMENT].GSM_TIERS AS from_code,
		[AVOCARBON].[dbo].[STKMOUVEMENT].GSM_TIERS AS to_code,
		[AVOCARBON].[dbo].[ARTICLE].GA_CODEARTICLE AS Internal_reference,
		[AVOCARBON].[dbo].[RTINFOS00D].RDD_RDDLIBTEXTE2 AS shipment_number,
		REPLACE(CONCAT([AVOCARBON].[dbo].[STKMOUVEMENT].GSM_NATUREORI,STR([AVOCARBON].[dbo].[STKMOUVEMENT].GSM_NUMEROORI)),' ', '') AS PO_number, -- concatenating GSM_NATUREORI and GSM_NUMEROORI plus removing the space between
		[AVOCARBON].[dbo].[STKMOUVEMENT].GSM_DATEMVT AS Movement_date,
		[AVOCARBON].[dbo].[STKMOUVEMENT].GSM_PHYSIQUE AS Quantity,
		[AVOCARBON].[dbo].[STKMOUVEMENT].GSM_MONTANT AS Movement_value
	FROM 
		[AVOCARBON].[dbo].[PIECE]
			LEFT JOIN 
				[AVOCARBON].[dbo].[STKMOUVEMENT]
				ON 
				[AVOCARBON].[dbo].[STKMOUVEMENT].GSM_NUMEROORI = [AVOCARBON].[dbo].[PIECE].GP_NUMERO
			LEFT JOIN 
				[AVOCARBON].[dbo].[RTINFOS00D]
				ON [AVOCARBON].[dbo].[PIECE].GP_NBTRANSMIS = [AVOCARBON].[dbo].[RTINFOS00D].RDD_CLEDATA
			LEFT JOIN 
				[AVOCARBON].[dbo].[ARTICLE]
				ON [AVOCARBON].[dbo].[ARTICLE].GA_ARTICLE = [AVOCARBON].[dbo].[STKMOUVEMENT].GSM_ARTICLE
	
	

-- Requete LO_D5_SupplierOrders
	
	INSERT INTO [BI_AVOCARBON].[dbo].[LO_D5_SupplierOrders] (
		[BI_AVOCARBON].[dbo].[LO_D5_SupplierOrders].Internal_reference,
		[BI_AVOCARBON].[dbo].[LO_D5_SupplierOrders].Supplier_code,
		[BI_AVOCARBON].[dbo].[LO_D5_SupplierOrders].Quantity_requested,
		[BI_AVOCARBON].[dbo].[LO_D5_SupplierOrders].Quantity_delivered,
		[BI_AVOCARBON].[dbo].[LO_D5_SupplierOrders].Order_date,
		[BI_AVOCARBON].[dbo].[LO_D5_SupplierOrders].Date_expected,
		[BI_AVOCARBON].[dbo].[LO_D5_SupplierOrders].Date_accepted,
		[BI_AVOCARBON].[dbo].[LO_D5_SupplierOrders].Date_completed
	)
	
	SELECT
		[AVOCARBON].[dbo].[LIGNE].GL_CODEARTICLE AS Internal_reference,
		[AVOCARBON].[dbo].[LIGNE].GL_TIERS AS Supplier_code,
		[AVOCARBON].[dbo].[LIGNE].GL_QTERESTE AS Quantity_requested,
		[AVOCARBON].[dbo].[LIGNE].GL_QTESTOCK AS Quantity_delivered,
		[AVOCARBON].[dbo].[LIGNE].GL_DATECREATION AS Order_date,
		[AVOCARBON].[dbo].[LIGNE].GL_DATELIVRAISON AS Date_expected,
		[AVOCARBON].[dbo].[LIGNE].GL_DATELIVRAISON AS Date_accepted,
		[AVOCARBON].[dbo].[LIGNE].GL_DATECREATION AS Date_completed
	FROM 
		[AVOCARBON].[dbo].[LIGNE]
	

-- Requete T01_References
	
	INSERT INTO [BI_AVOCARBON].[dbo].[T01_References] (
		[BI_AVOCARBON].[dbo].[T01_References].Internal_reference,
		[BI_AVOCARBON].[dbo].[T01_References].Reference_description,
		[BI_AVOCARBON].[dbo].[T01_References].Segment_code,
		[BI_AVOCARBON].[dbo].[T01_References].Storage_unit,
		[BI_AVOCARBON].[dbo].[T01_References].Production_unit,
		[BI_AVOCARBON].[dbo].[T01_References].Production_line,
		[BI_AVOCARBON].[dbo].[T01_References].Cogs_rm,
		[BI_AVOCARBON].[dbo].[T01_References].Cogs_dl,
		[BI_AVOCARBON].[dbo].[T01_References].Cogs_voh,
		[BI_AVOCARBON].[dbo].[T01_References].Inventory_status,
		[BI_AVOCARBON].[dbo].[T01_References].Product_netweight,
		[BI_AVOCARBON].[dbo].[T01_References].Inventory_price,
		[BI_AVOCARBON].[dbo].[T01_References].Product_trading,
		[BI_AVOCARBON].[dbo].[T01_References].HS_code,
		[BI_AVOCARBON].[dbo].[T01_References].Country_origin
	)

	SELECT
		[AVOCARBON].[dbo].[ARTICLE].GA_CODEARTICLE AS Internal_reference,
		[AVOCARBON].[dbo].[ARTICLE].GA_LIBELLE AS Reference_description,
		[AVOCARBON].[dbo].[ARTICLE].GA_FAMILLENIV2 AS Segment_code,
		[AVOCARBON].[dbo].[ARTICLE].GA_QUALIFUNITESTO AS Storage_unit,
		[AVOCARBON].[dbo].[ARTICLE].GA_UNITECONSO AS Production_unit,
		[AVOCARBON].[dbo].[ARTICLE].GA_CHARLIBRE2 AS Production_line,
		[AVOCARBON].[dbo].[ARTICLE].GA_PMAP AS Cogs_rm,
		[AVOCARBON].[dbo].[ARTICLE].GA_PMRP AS Cogs_dl,
		0 AS Cogs_voh,
		[AVOCARBON].[dbo].[ARTICLE].GA_LIBREART3 AS Inventory_status,
		[AVOCARBON].[dbo].[ARTICLE].GA_POIDSNET AS Product_netweight,
		0 AS Inventory_price,
		[AVOCARBON].[dbo].[ARTICLE].GA_BOOLLIBRE2 AS Product_trading,
		[AVOCARBON].[dbo].[ARTICLE].GA_CODEDOUANIER AS HS_code,
		[AVOCARBON].[dbo].[ARTICLE].GA_PAYSORIGINE AS Country_origin

	FROM 
		[AVOCARBON].[dbo].[ARTICLE]
	
	
-- Requete T02_Customers

	INSERT INTO [BI_AVOCARBON].[dbo].[T02_Customers] (
		[BI_AVOCARBON].[dbo].[T02_Customers].Customer_code,
		[BI_AVOCARBON].[dbo].[T02_Customers].Customer_name,
		[BI_AVOCARBON].[dbo].[T02_Customers].Global_customer,
		[BI_AVOCARBON].[dbo].[T02_Customers].Address1,
		[BI_AVOCARBON].[dbo].[T02_Customers].Address2,
		[BI_AVOCARBON].[dbo].[T02_Customers].Address3,
		[BI_AVOCARBON].[dbo].[T02_Customers].Address4,
		[BI_AVOCARBON].[dbo].[T02_Customers].City,
		[BI_AVOCARBON].[dbo].[T02_Customers].ZipCode,
		[BI_AVOCARBON].[dbo].[T02_Customers].Country_ISO3,
		[BI_AVOCARBON].[dbo].[T02_Customers].Incoterm,
		[BI_AVOCARBON].[dbo].[T02_Customers].Incoterm_location,
		[BI_AVOCARBON].[dbo].[T02_Customers].Incoterm_via,
		[BI_AVOCARBON].[dbo].[T02_Customers].Account_manager,
		[BI_AVOCARBON].[dbo].[T02_Customers].Min_order_qty,
		[BI_AVOCARBON].[dbo].[T02_Customers].Min_order_value,
		[BI_AVOCARBON].[dbo].[T02_Customers].Payment_term_days,
		[BI_AVOCARBON].[dbo].[T02_Customers].Payment_term_type
	)

	SELECT DISTINCT
		[AVOCARBON].[dbo].[TIERS].T_TIERS AS Customer_code,
		[AVOCARBON].[dbo].[TIERS].T_LIBELLE AS Customer_name,
		[AVOCARBON].[dbo].[TIERS].T_SOCIETEGROUPE AS Global_customer,
		[AVOCARBON].[dbo].[TIERS].T_ADRESSE1 AS Address1,
		[AVOCARBON].[dbo].[TIERS].T_ADRESSE2 AS Address2,
		[AVOCARBON].[dbo].[TIERS].T_ADRESSE3 AS Address3,
		'' AS Address4,
		[AVOCARBON].[dbo].[TIERS].T_VILLE AS City,
		[AVOCARBON].[dbo].[TIERS].T_CODEPOSTAL AS ZipCode,
		[AVOCARBON].[dbo].[TIERS].T_PAYS AS Country_ISO3,
		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_INCOTERM AS Incoterm,
		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_LIEUDISPO AS Incoterm_location,
		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_DEPOT AS Incoterm_via,
		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_TABLELIBRETIERS2 AS Account_manager,
		0 AS Min_order_qty,
		0 AS Min_order_value,
		[AVOCARBON].[dbo].[TIERS].T_MODEREGLE AS Payment_term_days,
		[AVOCARBON].[dbo].[TIERS].T_MODEREGLE AS Payment_term_type
	FROM 
		[AVOCARBON].[dbo].[TIERS]
			INNER JOIN [AVOCARBON].[dbo].[TIERSCOMPL] 
				ON 
				[AVOCARBON].[dbo].[TIERSCOMPL].YTC_TIERS = [AVOCARBON].[dbo].[TIERS].T_TIERS
	WHERE [TIERS].T_TIERS LIKE 'C%' -- Customer_code always starts with a C, C for Client

	
	
-- Requete T03_Suppliers

	INSERT INTO [BI_AVOCARBON].[dbo].[T03_Suppliers] (
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Supplier_code,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Supplier_name,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Global_supplier,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Address1,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Address2,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Address3,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Address4,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].City,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].ZipCode,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Country_ISO3,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Incoterm,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Incoterm_location,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Incoterm_via,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Account_manager,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Min_order_qty,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Min_order_value,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Payment_term_days,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Payment_term_type,
		[BI_AVOCARBON].[dbo].[T03_Suppliers].Supplier_revision_level
	)
	
	SELECT DISTINCT
		[AVOCARBON].[dbo].[TIERS].T_TIERS AS Supplier_code,
		[AVOCARBON].[dbo].[TIERS].T_LIBELLE AS Supplier_name,
		[AVOCARBON].[dbo].[TIERS].T_COMMENTAIRE AS Global_supplier,
		[AVOCARBON].[dbo].[TIERS].T_ADRESSE1 AS Address1,
		[AVOCARBON].[dbo].[TIERS].T_ADRESSE2 AS Address2,
		[AVOCARBON].[dbo].[TIERS].T_ADRESSE3 AS Address3,
		'' AS Address4,
		[AVOCARBON].[dbo].[TIERS].T_VILLE AS City,
		[AVOCARBON].[dbo].[TIERS].T_CODEPOSTAL AS ZipCode,
		[AVOCARBON].[dbo].[TIERS].T_PAYS AS Country_ISO3,
		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_INCOTERM AS Incoterm,
		[AVOCARBON].[dbo].[CATALOGU].GCA_LIBREGCA2 AS Incoterm_location,
		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_DEPOT AS Incoterm_via,
		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_TABLELIBREFOU1 AS Account_manager,
		0 AS Min_order_qty,
		0 AS Min_order_value,
		[AVOCARBON].[dbo].[TIERS].T_MODEREGLE AS Payment_term_days,
		[AVOCARBON].[dbo].[TIERS].T_MODEREGLE AS Payment_term_type,
		'' AS Supplier_revision_level
	FROM 
		[AVOCARBON].[dbo].[TIERS]
			INNER JOIN [AVOCARBON].[dbo].[CATALOGU]
				ON
				[AVOCARBON].[dbo].[CATALOGU].GCA_TIERS = [AVOCARBON].[dbo].[TIERS].T_TIERS
			INNER JOIN [AVOCARBON].[dbo].[TIERSCOMPL]
				ON 
				[AVOCARBON].[dbo].[TIERSCOMPL].YTC_TIERS = [AVOCARBON].[dbo].[TIERS].T_TIERS
		
	
	
-- Requete T12_RefCustomer
	
	INSERT INTO [BI_AVOCARBON].[dbo].[T12_RefCustomer] (
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Customer_code,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Internal_reference,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Customer_reference,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Application_code,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Selling_unit,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Selling_price,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Selling_currency,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Consigned,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Eco_order_qty,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Pack_order_qty,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Min_order_qty,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Min_order_value,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Product_grossweight,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Product_grosscube,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Leadtime_days,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Ref_price,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Customer_active,
		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Global_customer
	)

	SELECT 
	    DISTINCT
		[AVOCARBON].[dbo].[ARTICLETIERS].GAT_REFTIERS AS Customer_code,
		[AVOCARBON].[dbo].[ARTICLE].GA_CODEARTICLE AS Internal_reference,
		[AVOCARBON].[dbo].[ARTICLETIERS].GAT_REFARTICLE AS Customer_reference,
		[AVOCARBON].[dbo].[ARTICLE].GA_FAMILLENIV1 AS Application_code,
		[AVOCARBON].[dbo].[ARTICLE].GA_QUALIFUNITEVTE AS Selling_unit,
		[AVOCARBON].[dbo].[YTARIFS].YTS_PRIXNET AS Selling_price,
		[AVOCARBON].[dbo].[TIERS].T_DEVISE AS Selling_currency,
		[AVOCARBON].[dbo].[ZREFERENCEMENT].ZRF_DECISIONLIBRE1 AS Consigned,
		[AVOCARBON].[dbo].[CATALOGU].GCA_QECOACH AS Eco_order_qty,
		[AVOCARBON].[dbo].[ARTICLETIERS].GAT_QTEARTUC AS Pack_order_qty,
		[AVOCARBON].[dbo].[ARTICLETIERS].GAT_QTEARTUC AS Min_order_qty,
		0 AS Min_order_value,
		0 AS Product_grossweight,
		0 AS Product_grosscube,
		[AVOCARBON].[dbo].[ARTICLETIERS].GAT_DELAIMOYEN AS Leadtime_days,
		0 AS Ref_price,
		0 AS Customer_active,
		[AVOCARBON].[dbo].[TIERS].T_SOCIETEGROUPE AS Global_customer
	FROM 
		[AVOCARBON].[dbo].[ARTICLE]
			LEFT JOIN [AVOCARBON].[dbo].[CATALOGU]
				ON
				[AVOCARBON].[dbo].[ARTICLE].GA_ARTICLE = [AVOCARBON].[dbo].[CATALOGU].GCA_ARTICLE
			LEFT JOIN [AVOCARBON].[dbo].[ARTICLETIERS]
				ON
				[AVOCARBON].[dbo].[ARTICLETIERS].GAT_ARTICLE = [AVOCARBON].[dbo].[ARTICLE].GA_ARTICLE
			LEFT JOIN [AVOCARBON].[dbo].[TIERS]
				ON
				[AVOCARBON].[dbo].[ARTICLETIERS].GAT_REFTIERS = [AVOCARBON].[dbo].[TIERS].T_TIERS
			LEFT JOIN [AVOCARBON].[dbo].[YTARIFS]
				ON
				[AVOCARBON].[dbo].[ARTICLE].GA_ARTICLE = [AVOCARBON].[dbo].[YTARIFS].YTS_ARTICLE
			LEFT JOIN [AVOCARBON].[dbo].[ZREFERENCEMENT]
				ON
				[AVOCARBON].[dbo].[ARTICLETIERS].GAT_ARTICLE = [AVOCARBON].[dbo].[ZREFERENCEMENT].ZRF_REFARTICLE 
				AND [AVOCARBON].[dbo].[TIERS].T_TIERS = [AVOCARBON].[dbo].[ZREFERENCEMENT].ZRF_REFTIERS
			LEFT JOIN [AVOCARBON].[dbo].[LIGNE]
				ON 
				[AVOCARBON].[dbo].[LIGNE].GL_TIERSLIVRE = [AVOCARBON].[dbo].[TIERS].T_TIERS
	WHERE
		[AVOCARBON].[dbo].[LIGNE].GL_NATUREPIECEG = 'BLC' 

	
	
-- Requete T13_RefSupplier ok

	INSERT INTO [BI_AVOCARBON].[dbo].[T13_RefSupplier] (
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Supplier_code,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Internal_reference,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Supplier_reference,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Family_code,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Purchasing_unit,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Purchasing_price,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Purchasing_currency,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Consigned,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Eco_order_qty,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Pack_order_qty,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Min_order_qty,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Min_order_value,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Product_grossweight,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Product_grosscube,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Leadtime_days,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Supplier_active,
		[BI_AVOCARBON].[dbo].[T13_RefSupplier].Ref_price
	)
	
	SELECT
		[AVOCARBON].[dbo].[CATALOGU].GCA_TIERS AS Supplier_code,
		[AVOCARBON].[dbo].[ARTICLE].GA_CODEARTICLE AS Internal_reference, --changed to GA_CODEARTICLE
		[AVOCARBON].[dbo].[CATALOGU].GCA_REFERENCE AS Supplier_reference,
		[AVOCARBON].[dbo].[ARTICLE].GA_FAMILLENIV2 AS Family_code,
		[AVOCARBON].[dbo].[CATALOGU].GCA_QUALIFUNITEACH AS Purchasing_unit,
		[AVOCARBON].[dbo].[YTARIFS].YTS_PRIXNET AS Purchasing_price,
		[AVOCARBON].[dbo].[TIERS].T_DEVISE AS Purchasing_currency,
		[AVOCARBON].[dbo].[CATALOGU].GCA_BOOLLIBRE2 AS Consigned,
		[AVOCARBON].[dbo].[CATALOGU].GCA_QECOACH AS Eco_order_qty,
		[AVOCARBON].[dbo].[CATALOGU].GCA_QPCBACH AS Pack_order_qty,
		[AVOCARBON].[dbo].[CATALOGU].GCA_QECOACH AS Min_order_qty,
		0 AS Min_order_value,
		0 AS Product_grossweight,
		0 AS Product_grosscube,
		[AVOCARBON].[dbo].[CATALOGU].GCA_DELAILIVRAISON AS Leadtime_days,
		0 AS Supplier_active,
		0 AS Ref_price
	FROM 
		[AVOCARBON].[dbo].[CATALOGU]
			INNER JOIN [AVOCARBON].[dbo].[ARTICLE]
				ON
				[AVOCARBON].[dbo].[ARTICLE].GA_ARTICLE = [AVOCARBON].[dbo].[CATALOGU].GCA_ARTICLE
			INNER JOIN [AVOCARBON].[dbo].[TIERS]
				ON
				[AVOCARBON].[dbo].[CATALOGU].GCA_TIERS = [AVOCARBON].[dbo].[TIERS].T_TIERS
			LEFT JOIN [AVOCARBON].[dbo].[YTARIFS]
				ON
					[AVOCARBON].[dbo].[CATALOGU].GCA_ARTICLE = [AVOCARBON].[dbo].[YTARIFS].YTS_ARTICLE
					AND [AVOCARBON].[dbo].[CATALOGU].GCA_TIERS = [AVOCARBON].[dbo].[YTARIFS].YTS_TIERS
			LEFT JOIN [AVOCARBON].[dbo].[LIGNE]
				ON 
				[AVOCARBON].[dbo].[LIGNE].GL_TIERS = [AVOCARBON].[dbo].[TIERS].T_TIERS
	WHERE
		[AVOCARBON].[dbo].[LIGNE].GL_NATUREPIECEG = 'BLF' 
	
	

	
---- Requete T02_Customers

--	INSERT INTO [BI_AVOCARBON].[dbo].[T02_Customers] (
--		[BI_AVOCARBON].[dbo].[T02_Customers].Customer_code,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Customer_name,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Global_customer,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Address1,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Address2,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Address3,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Address4,
--		[BI_AVOCARBON].[dbo].[T02_Customers].City,
--		[BI_AVOCARBON].[dbo].[T02_Customers].ZipCode,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Country_ISO3,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Incoterm,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Incoterm_location,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Incoterm_via,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Account_manager,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Min_order_qty,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Min_order_value,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Payment_term_days,
--		[BI_AVOCARBON].[dbo].[T02_Customers].Payment_term_type
--	)

--	SELECT DISTINCT
--		[AVOCARBON].[dbo].[TIERS].T_TIERS AS Customer_code,
--		[AVOCARBON].[dbo].[TIERS].T_LIBELLE AS Customer_name,
--		[AVOCARBON].[dbo].[TIERS].T_SOCIETEGROUPE AS Global_customer,
--		[AVOCARBON].[dbo].[TIERS].T_ADRESSE1 AS Address1,
--		[AVOCARBON].[dbo].[TIERS].T_ADRESSE2 AS Address2,
--		[AVOCARBON].[dbo].[TIERS].T_ADRESSE3 AS Address3,
--		'' AS Address4,
--		[AVOCARBON].[dbo].[TIERS].T_VILLE AS City,
--		[AVOCARBON].[dbo].[TIERS].T_CODEPOSTAL AS ZipCode,
--		[AVOCARBON].[dbo].[TIERS].T_PAYS AS Country_ISO3,
--		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_INCOTERM AS Incoterm,
--		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_LIEUDISPO AS Incoterm_location,
--		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_DEPOT AS Incoterm_via,
--		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_TABLELIBRETIERS2 AS Account_manager,
--		0 AS Min_order_qty,
--		0 AS Min_order_value,
--		[AVOCARBON].[dbo].[TIERS].T_MODEREGLE AS Payment_term_days,
--		[AVOCARBON].[dbo].[TIERS].T_MODEREGLE AS Payment_term_type
--	FROM 
--		[AVOCARBON].[dbo].[TIERS]
--			INNER JOIN [AVOCARBON].[dbo].[TIERSCOMPL] 
--				ON 
--				[AVOCARBON].[dbo].[TIERSCOMPL].YTC_TIERS = [AVOCARBON].[dbo].[TIERS].T_TIERS
	
	
---- Requete T03_Suppliers

--	INSERT INTO [BI_AVOCARBON].[dbo].[T03_Suppliers] (
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Supplier_code,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Supplier_name,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Global_supplier,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Address1,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Address2,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Address3,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Address4,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].City,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].ZipCode,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Country_ISO3,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Incoterm,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Incoterm_location,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Incoterm_via,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Account_manager,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Min_order_qty,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Min_order_value,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Payment_term_days,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Payment_term_type,
--		[BI_AVOCARBON].[dbo].[T03_Suppliers].Supplier_revision_level
--	)
	
--	SELECT
--		[AVOCARBON].[dbo].[TIERS].T_TIERS AS Supplier_code,
--		[AVOCARBON].[dbo].[TIERS].T_LIBELLE AS Supplier_name,
--		[AVOCARBON].[dbo].[TIERS].T_COMMENTAIRE AS Global_supplier,
--		[AVOCARBON].[dbo].[TIERS].T_ADRESSE1 AS Address1,
--		[AVOCARBON].[dbo].[TIERS].T_ADRESSE2 AS Address2,
--		[AVOCARBON].[dbo].[TIERS].T_ADRESSE3 AS Address3,
--		'' AS Address4,
--		[AVOCARBON].[dbo].[TIERS].T_VILLE AS City,
--		[AVOCARBON].[dbo].[TIERS].T_CODEPOSTAL AS ZipCode,
--		[AVOCARBON].[dbo].[TIERS].T_PAYS AS Country_ISO3,
--		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_INCOTERM AS Incoterm,
--		[AVOCARBON].[dbo].[CATALOGU].GCA_LIBREGCA2 AS Incoterm_location,
--		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_DEPOT AS Incoterm_via,
--		[AVOCARBON].[dbo].[TIERSCOMPL].YTC_TABLELIBREFOU1 AS Account_manager,
--		0 AS Min_order_qty,
--		0 AS Min_order_value,
--		[AVOCARBON].[dbo].[TIERS].T_MODEREGLE AS Payment_term_days,
--		[AVOCARBON].[dbo].[TIERS].T_MODEREGLE AS Payment_term_type,
--		0 AS Supplier_revision_level
--	FROM 
--		[AVOCARBON].[dbo].[TIERS]
--			INNER JOIN [AVOCARBON].[dbo].[CATALOGU]
--				ON
--				[AVOCARBON].[dbo].[CATALOGU].GCA_TIERS = [AVOCARBON].[dbo].[TIERS].T_TIERS
--			INNER JOIN [AVOCARBON].[dbo].[TIERSCOMPL]
--				ON 
--				[AVOCARBON].[dbo].[TIERSCOMPL].YTC_TIERS = [AVOCARBON].[dbo].[TIERS].T_TIERS
		
	


---- Requete T12_RefCustomer
	
--	INSERT INTO [BI_AVOCARBON].[dbo].[T12_RefCustomer] (
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Customer_code,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Internal_reference,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Customer_reference,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Application_code,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Selling_unit,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Selling_price,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Selling_currency,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Consigned,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Eco_order_qty,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Pack_order_qty,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Min_order_qty,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Min_order_value,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Product_grossweight,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Product_grosscube,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Leadtime_days,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Ref_price,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Customer_active,
--		[BI_AVOCARBON].[dbo].[T12_RefCustomer].Global_customer
--	)

--	SELECT 
--		[AVOCARBON].[dbo].[ARTICLETIERS].GAT_REFTIERS AS Customer_code,
--		[AVOCARBON].[dbo].[ARTICLE].GA_CODEARTICLE AS Internal_reference,
--		[AVOCARBON].[dbo].[ARTICLETIERS].GAT_REFARTICLE AS Customer_reference,
--		[AVOCARBON].[dbo].[ARTICLE].GA_FAMILLENIV1 AS Application_code,
--		[AVOCARBON].[dbo].[ARTICLE].GA_QUALIFUNITEVTE AS Selling_unit,
--		[AVOCARBON].[dbo].[YTARIFS].YTS_PRIXNET AS Selling_price,
--		[AVOCARBON].[dbo].[TIERS].T_DEVISE AS Selling_currency,
--		[AVOCARBON].[dbo].[ZREFERENCEMENT].ZRF_DECISIONLIBRE1 AS Consigned,
--		[AVOCARBON].[dbo].[CATALOGU].GCA_QECOACH AS Eco_order_qty,
--		[AVOCARBON].[dbo].[CATALOGU].GCA_QPCBACH AS Pack_order_qty,
--		[AVOCARBON].[dbo].[CATALOGU].GCA_QECOACH AS Min_order_qty,
--		0 AS Min_order_value,
--		0 AS Product_grossweight,
--		0 AS Product_grosscube,
--		[AVOCARBON].[dbo].[ARTICLETIERS].GAT_DELAIMOYEN AS Leadtime_days,
--		0 AS Ref_price,
--		0 AS Customer_active,
--		[AVOCARBON].[dbo].[TIERS].T_SOCIETEGROUPE AS Global_customer
--	FROM 
--		[AVOCARBON].[dbo].[ARTICLE]
--			LEFT JOIN [AVOCARBON].[dbo].[CATALOGU]
--				ON
--				[AVOCARBON].[dbo].[ARTICLE].GA_ARTICLE = [AVOCARBON].[dbo].[CATALOGU].GCA_ARTICLE
--			LEFT JOIN [AVOCARBON].[dbo].[ARTICLETIERS]
--				ON
--				[AVOCARBON].[dbo].[ARTICLETIERS].GAT_ARTICLE = [AVOCARBON].[dbo].[ARTICLE].GA_ARTICLE
--			LEFT JOIN [AVOCARBON].[dbo].[TIERS]
--				ON
--				[AVOCARBON].[dbo].[ARTICLETIERS].GAT_REFTIERS = [AVOCARBON].[dbo].[TIERS].T_TIERS
--			LEFT JOIN [AVOCARBON].[dbo].[YTARIFS]
--				ON
--				[AVOCARBON].[dbo].[ARTICLE].GA_ARTICLE = [AVOCARBON].[dbo].[YTARIFS].YTS_ARTICLE
--			LEFT JOIN [AVOCARBON].[dbo].[ZREFERENCEMENT]
--				ON
--				[AVOCARBON].[dbo].[ARTICLETIERS].GAT_ARTICLE = [AVOCARBON].[dbo].[ZREFERENCEMENT].ZRF_REFARTICLE 
--				AND [AVOCARBON].[dbo].[TIERS].T_TIERS = [AVOCARBON].[dbo].[ZREFERENCEMENT].ZRF_REFTIERS
--			LEFT JOIN [AVOCARBON].[dbo].[LIGNE]
--				ON 
--				[AVOCARBON].[dbo].[LIGNE].GL_TIERSLIVRE = [AVOCARBON].[dbo].[TIERS].T_TIERS
--	WHERE
--		[AVOCARBON].[dbo].[LIGNE].GL_NATUREPIECEG = 'BLC' 

	
	
-- Requete T13_RefSupplier

	--INSERT INTO [BI_AVOCARBON].[dbo].[T13_RefSupplier] (
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Supplier_code,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Internal_reference,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Supplier_reference,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Family_code,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Purchasing_unit,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Purchasing_price,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Purchasing_currency,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Consigned,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Eco_order_qty,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Pack_order_qty,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Min_order_qty,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Min_order_value,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Product_grossweight,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Product_grosscube,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Leadtime_days,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Supplier_active,
	--	[BI_AVOCARBON].[dbo].[T13_RefSupplier].Ref_price
	--)
	
	--SELECT
	--	[AVOCARBON].[dbo].[CATALOGU].GCA_TIERS AS Supplier_code,
	--	[AVOCARBON].[dbo].[CATALOGU].GCA_ARTICLE AS Internal_reference,
	--	[AVOCARBON].[dbo].[CATALOGU].GCA_REFERENCE AS Supplier_reference,
	--	[AVOCARBON].[dbo].[ARTICLE].GA_FAMILLENIV2 AS Family_code,
	--	[AVOCARBON].[dbo].[CATALOGU].GCA_QUALIFUNITEACH AS Purchasing_unit,
	--	[AVOCARBON].[dbo].[YTARIFS].YTS_PRIXNET AS Purchasing_price,
	--	[AVOCARBON].[dbo].[TIERS].T_DEVISE AS Purchasing_currency,
	--	[AVOCARBON].[dbo].[CATALOGU].GCA_BOOLLIBRE2 AS Consigned,
	--	[AVOCARBON].[dbo].[CATALOGU].GCA_QECOACH AS Eco_order_qty,
	--	[AVOCARBON].[dbo].[CATALOGU].GCA_QPCBACH AS Pack_order_qty,
	--	[AVOCARBON].[dbo].[CATALOGU].GCA_QECOACH AS Min_order_qty,
	--	0 AS Min_order_value,
	--	0 AS Product_grossweight,
	--	0 AS Product_grosscube,
	--	[AVOCARBON].[dbo].[CATALOGU].GCA_DELAILIVRAISON AS Leadtime_days,
	--	0 AS Supplier_active,
	--	0 AS Ref_price
	--FROM 
	--	[AVOCARBON].[dbo].[CATALOGU]
	--		INNER JOIN [AVOCARBON].[dbo].[ARTICLE]
	--			ON
	--			[AVOCARBON].[dbo].[ARTICLE].GA_ARTICLE = [AVOCARBON].[dbo].[CATALOGU].GCA_ARTICLE
	--		INNER JOIN [AVOCARBON].[dbo].[TIERS]
	--			ON
	--			[AVOCARBON].[dbo].[CATALOGU].GCA_TIERS = [AVOCARBON].[dbo].[TIERS].T_TIERS
	--		LEFT JOIN [AVOCARBON].[dbo].[YTARIFS]
	--			ON
	--				[AVOCARBON].[dbo].[CATALOGU].GCA_ARTICLE = [AVOCARBON].[dbo].[YTARIFS].YTS_ARTICLE
	--				AND [AVOCARBON].[dbo].[CATALOGU].GCA_TIERS = [AVOCARBON].[dbo].[YTARIFS].YTS_TIERS
	--		LEFT JOIN [AVOCARBON].[dbo].[LIGNE]
	--			ON 
	--			[AVOCARBON].[dbo].[LIGNE].GL_TIERSLIVRE = [AVOCARBON].[dbo].[TIERS].T_TIERS
	--WHERE
	--	[AVOCARBON].[dbo].[LIGNE].GL_NATUREPIECEG = 'BLF' 
	

GO


