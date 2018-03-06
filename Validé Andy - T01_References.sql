CREATE VIEW 
	T01_References
AS 
	SELECT
		ARTICLE.GA_CODEARTICLE AS Internal_reference,
		ARTICLE.GA_LIBELLE AS Reference_description,
		ARTICLE.GA_FAMILLENIV2 AS Segment_code,
		ARTICLE.GA_QUALIFUNITESTO AS Storage_unit,
		ARTICLE.GA_UNITECONSO AS Production_unit,
		ARTICLE.GA_CHARLIBRE2 AS Production_line,
		ARTICLE.GA_PMAP AS Cogs_rm,
		ARTICLE.GA_PMRP AS Cogs_dl,
		ARTICLE.GA_LIBREART3 AS Inventory_status,
		ARTICLE.GA_POIDSNET AS Product_netweight,
		ARTICLE.GA_BOOLLIBRE2 AS Product_trading,
		ARTICLE.GA_CODEDOUANIER AS HS_code,
		ARTICLE.GA_PAYSORIGINE AS Country_origin

	FROM 
		ARTICLE
;
