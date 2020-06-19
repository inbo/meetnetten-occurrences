USE [S0008_00_Meetnetten]
GO

/****** Object:  View [iptdev].[vwGBIF_INBO_meetnetten_09_37_libellen_larvehuidjes_Meas]    Script Date: 19/06/2020 13:45:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [ipt].[vwGBIF_INBO_meetnetten_09_37_libellen_larvehuidjes_Meas]
AS

SELECT --fa.*   --unieke kolomnamen 
	
	


	 [parentEventID] = N'visitID :' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkVisitID),6)
	
	 ---EVENT---	
	
	, [eventID] = N'INBO:MEETNET:EVENT:' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkSampleID),6)  
	, [eventDate] = fwp.VisitStartDate
	

	--- Properties---

--	, [measurementID] =  Fco.AttributeID 
	, [measurementType] = case FCo.AttributeName
							WHEN 'wind-force' THEN 'wind force'
							ELSE FCo.AttributeName
							END
	, [measurementValue] = CASE
			WHEN FCO.AttributeUnit = 'temperature'     AND FCO.AttributeValue = 'onbekend' THEN ''
			WHEN FCO.AttributeUnit = 'temperature'     AND FCO.AttributeValue = '' THEN ''
			WHEN FCO.AttributeUnit = 'transect length' AND FCO.AttributeValue = '' THEN ''
			
			
			
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
			WHEN FCO.AttributeValue = 'onbekend' THEN 'unknown'
			WHEN FCO.AttributeValue = '' THEN 'unknown'

			ELSE FCO.AttributeValue
			END
	, [measurementUnit] = CASE FCO.AttributeUnit
							WHEN 'temperature' THEN ' °C'
							WHEN 'wind-force' THEN 'Beaufort'
							WHEN 'cloudiness' THEN 'okta'
							WHEN 'transect length' THEN 'm'
							ELSE FCO.AttributeUnit
							END

	



FROM (SELECT DISTINCT(FieldworkSampleID),FieldworkVisitID,ProjectKey, LocationKey, ProtocolKey, LocationID, ProtocolID, SpeciesActivityID, SpeciesActivityKey, SpeciesLifestageID, SpeciesLifestageKey FROM dbo.FactAantal WHERE FieldworkSampleID > 0) fA
	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
--	INNER JOIN dbo.DimSpecies dSP ON dsp.SpeciesKey = fa.SpeciesKey
	INNER JOIN (SELECT DISTINCT(FieldworkSampleID), VisitStartDate FROM dbo.FactWerkpakket ) FWp ON FWp.FieldworkSampleID = fa.FieldworkSampleID
	INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
--	LEFT OUTER JOIN dbo.DimModel DMo ON DMo.AttributeID = FCo.AttributeID
	
	
WHERE 1=1
--AND ProjectName = '***'
--AND fa.ProjectKey = '16'
AND fa.ProtocolID IN ('9')  ---Libellen larvehuidjes
--AND Aantal > '0'
AND fwp.VisitStartDate > CONVERT(datetime, '2016-01-01', 120)
AND fwp.VisitStartDate < CONVERT(datetime, '2019-12-31', 120)
--AND projectName = 'Argusvlinder'
--AND fa.FieldworkObservationID =  491520
--ORDER BY speciesName Asc
--ORDER BY fa.FieldworkObservationID
--AND ParentLocationName in ('Groot Schietveld 2','Klein Schietveld')
--AND projectname = 'kommavlinder'
--AND ProjectName = 'heivlinder'
--AND fA.FieldworkSampleID = '190441'
--AND SpeciesLifestageName = 'imago'





--SELECT fa.FieldworkSampleID, count(*) as tel


/***FROM (SELECT DISTINCT(FieldworkSampleID),FieldworkVisitID,ProjectKey, LocationKey, ProtocolKey, LocationID, ProtocolID, SpeciesActivityID, SpeciesActivityKey, SpeciesLifestageID, SpeciesLifestageKey FROM dbo.FactAantal WHERE FieldworkSampleID > 0) fA
	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	INNER JOIN dbo.DimLocation dL ON dL.LocationKey = fA.LocationKey
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
	--	INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
	INNER JOIN (SELECT DISTINCT(FieldworkSampleID), VisitStartDate FROM dbo.FactWerkpakket ) FWp ON FWp.FieldworkSampleID = fa.FieldworkSampleID

	--INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
WHERE 1=1
--AND ProjectName = 'Vuursalamander'
--AND ProtocolName = 'Vlinders - Transecten'
--AND fa.ProjectKey = '16'
  AND fa.ProtocolID =  '1'
--  AND fa.FieldworkSampleID in ('196717','196456','197026','54759','194584')
  --AND ParentLocationGeom IS NULL
--ORDER BY FA.FieldworkSampleID DesC

--- Verification by counts ---
--  GROUP BY fa.FieldworkSampleID
--  ORDER BY tel DESC  **/













































GO


