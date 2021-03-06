﻿CREATE VIEW 
	T12_RefCustomer
AS 
	SELECT 
		ARTICLETIERS.GAT_REFTIERS AS Customer_code,
		ARTICLE.GA_CODEARTICLE AS Internal_reference,
		ARTICLETIERS.GAT_REFARTICLE AS Customer_reference,
		ARTICLE.GA_FAMILLENIV1 AS Application_code,
		ARTICLE.GA_QUALIFUNITEVTE AS Selling_unit,
		YTARIFS.YTS_PRIXNET AS Selling_price,
		TIERS.T_DEVISE AS Selling_currency,
		ZREFERENCEMENT.ZRF_DECISIONLIBRE1 AS Consigned,
		CATALOGU.GCA_QECOACH AS Eco_order_qty,
		CATALOGU.GCA_QPCBACH AS Pack_order_qty,
		CATALOGU.GCA_QECOACH AS Min_order_qty,
		'' AS Min_order_value,
		ARTICLETIERS.GAT_DELAIMOYEN AS Leadtime_days,
		TIERS.T_SOCIETEGROUPE AS Global_customer
	FROM 
		[TEST_AVO].[dbo].[ARTICLE]
			LEFT JOIN [TEST_AVO].[dbo].[CATALOGU]
				ON
				ARTICLE.GA_ARTICLE = CATALOGU.GCA_ARTICLE
			LEFT JOIN [TEST_AVO].[dbo].[ARTICLETIERS]
				ON
				ARTICLETIERS.GAT_ARTICLE = [TEST_AVO].[dbo].[ARTICLE].GA_ARTICLE
			LEFT JOIN [TEST_AVO].[dbo].[TIERS]
				ON
				ARTICLETIERS.GAT_REFTIERS = TIERS.T_TIERS
			LEFT JOIN [TEST_AVO].[dbo].[YTARIFS]
				ON
				ARTICLE.GA_ARTICLE = YTARIFS.YTS_ARTICLE
			LEFT JOIN [TEST_AVO].[dbo].[ZREFERENCEMENT]
				ON
				ARTICLETIERS.GAT_ARTICLE = ZREFERENCEMENT.ZRF_REFARTICLE 
				AND TIERS.T_TIERS = ZREFERENCEMENT.ZRF_REFTIERS
			LEFT JOIN [TEST_AVO].[dbo].[LIGNE]
				ON 
				LIGNE.GL_TIERSLIVRE = TIERS.T_TIERS
	WHERE
		GL_NATUREPIECEG = 'BLC' 

;


