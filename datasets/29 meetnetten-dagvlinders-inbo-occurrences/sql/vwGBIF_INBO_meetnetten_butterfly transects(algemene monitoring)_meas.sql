USE [S0008_00_Meetnetten]
GO

/****** Object:  View [ipt].[vwGBIF_INBO_meetnetten_29_vlinders_transecten_alg_meas]    Script Date: 1/03/2021 9:23:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER VIEW [ipt].[vwGBIF_INBO_meetnetten_29_vlinders_transecten_alg_meas]
AS

SELECT  --fa.*   --unieke kolomnamen
	DISTINCT
	--	 [parentEventID] = N'visitID :' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkVisitID),6)
	
	 ---EVENT---	
	
	  [eventID] = N'INBO:MEETNET:EVENT:' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkSampleID),6)  
--	, [eventDate] = fwp.VisitStartDate
	

	--- Properties---

--	, [measurementID] =  Fco.AttributeID 
	, [measurementType] = case FCo.AttributeName
							WHEN 'wind-force' THEN 'wind force'
							ELSE FCo.AttributeName
							END
	, [measurementValue] = (CASE
			WHEN FCO.AttributeUnit = 'temperature' AND FCO.AttributeValue = 'onbekend' THEN ''
			WHEN FCO.AttributeUnit = 'temperature' AND FCO.AttributeValue = '' THEN ''

			WHEN FCO.AttributeValue = 'windstil (0 Bft)' THEN '0'
			WHEN FCO.AttributeValue = 'zeer zwakke wind (1 Bft)' THEN '1'
			WHEN FCO.AttributeValue = 'zwakke wind (2 Bft)' THEN '2'
			WHEN FCO.AttributeValue = 'vrij matige wind (3 Bft)' THEN '3'
			WHEN FCO.AttributeValue = 'matige wind (4 Bft)' THEN '4'
			WHEN FCO.AttributeValue = 'vrij krachtige wind (5 Bft)' THEN '5'

			WHEN FCO.AttributeValue = 'heldere hemel (0/8)' THEN 'clear (0/8)'
			WHEN FCO.AttributeValue = 'unclouded' THEN 'clear (0/8)'
			WHEN FCO.AttributeValue = 'lichtbewolkt (1 tot 2/8)' THEN 'mostly clear (1/8 - 2/8)'
			WHEN FCO.AttributeValue = 'halfbewolkt (3 tot 5/8)' THEN 'partly cloudy (3/8 - 5/8)'
			WHEN FCO.AttributeValue = 'half clouded' THEN 'partly cloudy (3/8 - 5/8)'
			WHEN FCO.AttributeValue = 'partially clouded' THEN 'partly cloudy (3/8 - 5/8)'
			WHEN FCO.AttributeValue = 'zwaarbewolkt (6 tot 7/8)' THEN 'mostly cloudy (6/8 - 7/8)'
			WHEN FCO.AttributeValue = 'heavily clouded' THEN 'mostly cloudy (6/8 - 7/8)'
			WHEN FCO.AttributeValue = 'betrokken (8/8)' THEN 'cloudy (8/8)'
			WHEN FCO.AttributeValue = 'onbekend' THEN ''
			WHEN FCO.AttributeValue = '' THEN ''

			ELSE FCO.AttributeValue
			END) 
	, [measurementUnit] = CASE FCO.AttributeUnit
							WHEN 'temperature' THEN ' °C'
							WHEN 'wind-force' THEN 'Beaufort'
							WHEN 'cloudiness' THEN 'okta'
							ELSE 'unknown'
							END


FROM dbo.FactAantal fA


	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
--	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
--	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
	INNER JOIN ( SELECT fa.FieldworkSampleID
					, COALESCE( dlp.LocationKey, dol.LocationKey) as ParentLocationKey
					, COUNT (*) as Nmbr
				FROM dbo.FactAantal fa
				LEFT OUTER JOIN dbo.DimLocation dol ON dol.LocationKey = fa.LocationKey
				LEFT OUTER JOIN dbo.DimLocation dlp ON dlp.LocationID = dol.ParentLocationID
				GROUP BY fa.FieldworkSampleID
					, COALESCE( dlp.LocationKey, dol.LocationKey)
				) ParentLocation ON  ParentLocation.FieldworkSampleID = fa.FieldworkSampleID
								--AND ParentLocation.ParentLocationKey = fa.LocationKey
	--INNER JOIN dbo.DimLocation duL ON duL.LocationKey = ParentLocation.ParentLocationKey

	

--	INNER JOIN dbo.DimSpecies dSP ON dsp.SpeciesKey = fa.SpeciesKey
	INNER JOIN (SELECT DISTINCT(FieldworkSampleID), VisitStartDate FROM dbo.FactWerkpakket ) FWp ON FWp.FieldworkSampleID = fa.FieldworkSampleID
--	INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
	INNER JOIN dbo.DimBlur Dbl ON Dbl.ProjectKey = fa.projectKey
--	INNER JOIN [shp].[utm_vl_WGS84] utm WITH (INDEX(SI_utm_vl_WGS84__geom_1)) ON utm.geom_1.STIntersects(duL.PointData) = 1
	INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
	
	--INNER JOIN [shp].[utm10_vl_WGS84] utm10 ON dL.PointData.STWithin(utm10.geom) = 1
	
WHERE 1=1

AND fa.ProtocolID IN ('29')  ---Vlinders transecten * ,'15','28' removed other protocols
AND fwp.VisitStartDate < CONVERT(datetime, '2020-12-31', 120)

AND (CASE
			WHEN FCO.AttributeUnit = 'temperature' AND FCO.AttributeValue = 'onbekend' THEN ''
			WHEN FCO.AttributeUnit = 'temperature' AND FCO.AttributeValue = '' THEN ''

			WHEN FCO.AttributeValue = 'windstil (0 Bft)' THEN '0'
			WHEN FCO.AttributeValue = 'zeer zwakke wind (1 Bft)' THEN '1'
			WHEN FCO.AttributeValue = 'zwakke wind (2 Bft)' THEN '2'
			WHEN FCO.AttributeValue = 'vrij matige wind (3 Bft)' THEN '3'
			WHEN FCO.AttributeValue = 'matige wind (4 Bft)' THEN '4'
			WHEN FCO.AttributeValue = 'vrij krachtige wind (5 Bft)' THEN '5'

			WHEN FCO.AttributeValue = 'heldere hemel (0/8)' THEN 'clear (0/8)'
			WHEN FCO.AttributeValue = 'unclouded' THEN 'clear (0/8)'
			WHEN FCO.AttributeValue = 'lichtbewolkt (1 tot 2/8)' THEN 'mostly clear (1/8 - 2/8)'
			WHEN FCO.AttributeValue = 'halfbewolkt (3 tot 5/8)' THEN 'partly cloudy (3/8 - 5/8)'
			WHEN FCO.AttributeValue = 'half clouded' THEN 'partly cloudy (3/8 - 5/8)'
			WHEN FCO.AttributeValue = 'partially clouded' THEN 'partly cloudy (3/8 - 5/8)'
			WHEN FCO.AttributeValue = 'zwaarbewolkt (6 tot 7/8)' THEN 'mostly cloudy (6/8 - 7/8)'
			WHEN FCO.AttributeValue = 'heavily clouded' THEN 'mostly cloudy (6/8 - 7/8)'
			WHEN FCO.AttributeValue = 'betrokken (8/8)' THEN 'cloudy (8/8)'
			WHEN FCO.AttributeValue = 'onbekend' THEN ''
			WHEN FCO.AttributeValue = '' THEN ''

			ELSE FCO.AttributeValue
			END)  <> ''




GO


