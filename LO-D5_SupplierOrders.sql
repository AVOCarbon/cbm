CREATE VIEW 
	[LO-D5_SupplierOrders]

AS 
	SELECT
		LIGNE.GL_CODEARTICLE AS Internal_reference,
		LIGNE.GL_TIERS AS Supplier_code,
		LIGNE.GL_QTERESTE AS Quantity_requested,
		LIGNE.GL_QTESTOCK AS Quantity_delivered,
		LIGNE.GL_DATECREATION AS Order_date,
		LIGNE.GL_DATELIVRAISON AS Date_expected,
		LIGNE.GL_DATELIVRAISON AS Date_accepted,
		LIGNE.GL_DATECREATION AS Date_completed
	FROM 
		LIGNE
;
