CREATE VIEW 
	T02_Customers

AS 
	SELECT DISTINCT
		TIERS.T_TIERS AS Customer_code,
		TIERS.T_LIBELLE AS Customer_name,
		TIERS.T_SOCIETEGROUPE AS Global_customer,
		TIERS.T_ADRESSE1 AS Address1,
		TIERS.T_ADRESSE2 AS Address2,
		TIERS.T_ADRESSE3 AS Address3,
		TIERS.T_VILLE AS City,
		TIERS.T_CODEPOSTAL AS ZipCode,
		TIERS.T_PAYS AS Country_ISO3,
		TIERSCOMPL.YTC_INCOTERM AS Incoterm,
		TIERSCOMPL.YTC_LIEUDISPO AS Incoterm_location,
		TIERSCOMPL.YTC_DEPOT AS Incoterm_via,
		TIERSCOMPL.YTC_TABLELIBRETIERS2 AS Account_manager,
		'' AS Min_order_qty,
		'' AS Min_order_value,
		TIERS.T_MODEREGLE AS Payment_term_type
	FROM 
		[TEST_AVO].[dbo].[TIERS]
			INNER JOIN [TEST_AVO].[dbo].[TIERSCOMPL] 
				ON 
				TIERSCOMPL.YTC_TIERS = TIERS.T_TIERS
		
;
