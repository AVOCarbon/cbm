CREATE VIEW 
	FI_D6_Inventory
AS 
	SELECT
		DISPO.GQ_ARTICLE AS Intenal_reference,
		DISPO.GQ_PHYSIQUE AS Inventory_quantity,
		DISPO.GQ_DATEINVENTAIRE AS Inventory_date,
		DISPO.GQ_DEPOT AS Inventory_location, 
		DISPO.GQ_PMRP AS Inventory_unitprice,
		STKMOUVEMENT.GSM_DATEMVT AS LastMovement_date
	FROM 
		[TEST_AVO].[dbo].[DISPO]
			INNER JOIN [TEST_AVO].[dbo].[STKMOUVEMENT]
				ON 
				DISPO.GQ_ARTICLE = STKMOUVEMENT.GSM_ARTICLE

;
