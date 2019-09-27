USE [S0008_00_Meetnetten]
GO

/****** Object:  View [iptdev].[vwGBIF_INBO_meetnetten_1_15_19_28_vlinders_transecten_OccurrenceCore]    Script Date: 27/09/2019 13:29:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














/*

SELECT * FROM [iptdev].[vwGBIF_INBO_meetnetten_generiek_events];

*/

/* generieke query events, test met vuursalamander
   We creëren meerdere datasets uit meetnetten op basis van protocol
   Vlinders transecten 
   Add lat long start transect
   Add visitstartDate
   Changing into occ core
   VisitStart=date > 2015-01-01 (na vlinderdatabank)
 */

ALTER VIEW [iptdev].[vwGBIF_INBO_meetnetten_1_15_19_28_vlinders_transecten_OccurrenceCore]
AS

SELECT --fa.*   --unieke kolomnamen 
	
	---RECORD ---
	 --TOP 1000
	  [occurrenceID] = N'INBO:MEETNETTEN:OCC:' + Right( N'0000' + CONVERT(nvarchar(20) ,fa.FieldworkObservationID),7)

    , [type] = N'Event'
   	, [language] = N'en'
	, [license] = N'http://creativecommons.org/publicdomain/zero/1.0/'
	, [rightsHolder] = N'INBO'
	, [accessRights] = N'https://www.inbo.be/en/norms-data-use'
	, [datasetID] = N'meetnettendatasetDOI'
	, [datasetName] = N'Meetnetten - Butterflies; transects, egg counts and area counts in Flanders, Belgium'
	, [institutionCode] = N'INBO'
	
	 ---EVENT---	
	
	, [eventID] = N'INBO:MEETNET:EVENT:' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkSampleID),6)  
	, [basisOfRecord] = N'HumanObservation'
	, [samplingProtocol] =  CASE Protocolname
							WHEN 'Vlinders - Transecten' THEN 'Butterflies Transects'
							WHEN 'Vlinders - Eitellingen' THEN 'Butterflies Egg Counts'
							WHEN 'Vlinders - Transecten (algemene monitoring)' THEN 'Butterflies Transects Monitoring'
							WHEN 'Vlinders - Gebiedstelling (v1)' THEN 'Butterflies Area Counts'
							ELSE ProtocolName
							END
	
--	, [protocol] = ProtocolSubjectDescription
	, fa.ProtocolID
	, [eventDate] = fwp.VisitStartDate
--	, [individualCount] = Aantal
--	, [samplingEffort] =
						
--	,[eventDate] = SampleDate
--	,[dynamicProperties] = 
	

	--, CONVERT(decimal(10,5), dL.LocationGeom.STCentroid().STY) as decimalLatitude
	--, CONVERT(decimal(10,5), dL.LocationGeom.STCentroid().STX) as decimalLongitude

	---LOCATION
	, [locationID] = N'INBO:MEETNET:LOCATION:' + Right( N'000000000' + CONVERT(nvarchar(20) ,dL.LocationID),10) 
	, [continent] = N'Europe'
--	, [waterbody] = dL.Location
	, [countryCode] = N'BE'
	, [locality] = locationName
	, [georeferenceRemarks] = CASE SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText())))
									WHEN 'LINESTRING' THEN 'coördinates are starting point of transect'
									WHEN 'Point' THEN 'coördinates are a point'
									WHEN 'POLYGON' THEN 'coordinates are centroid of location'
									WHEN 'MULTIPOLYGON' THEN  'coordinates are centroid of location'
									ELSE 'Something else'
									END

--	, CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY) as decimalLatitude
--	, CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX) as decimalLongitude
	, CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY) as decimalLatitude
	, CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX) as decimalLongitude
--	, SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),1,10) as pointinfo3   **text uit kolom selecteren V1                          
--	, LEFT(CAST(dL.LocationGeom.MakeValid().STAsText() AS VARCHAR(MAX)),10) as pointInfo2   **text uit kolom selecteren V2
	, SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) as pointinfo   /***text uit kolom selecteren V3 beste optie***/
	, (dL.LocationGeom.MakeValid().STAsText()) as footprintWKT
	, [geodeticDatum] = N'WGS84'
	, dl.LocationGeom
	, dl.parentLocationGeom
	
---- OCCURRENCE ---
		
	, [recordedBy] = 'to complete'
	, [individualCount] = Aantal
	, [sex] = Geslacht
	, [occurrenceStatus] = CASE Aantal
							When '0' then 'absent'
							Else 'present'
							End
	, [lifeStage] = SpeciesLifestageName

----Taxon

	, [scientificName] = SpeciesScientificName

	, [vervaging] =  Dbl.BlurDistance


	, [vernacularName] = SpeciesName
	, [kingdom] = N'Animalia'
	, [phylum] = N'Arthropoda'
	, [class] = N''
	, [nomenclaturalCode] = N'ICZN'
	
	, fa.ProjectKey
	
FROM dbo.FactAantal fA
	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	INNER JOIN dbo.DimLocation dL ON dL.LocationKey = fA.LocationKey
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
	INNER JOIN dbo.DimSpecies dSP ON dsp.SpeciesKey = fa.SpeciesKey
	INNER JOIN (SELECT DISTINCT(FieldworkSampleID), VisitStartDate FROM dbo.FactWerkpakket ) FWp ON FWp.FieldworkSampleID = fa.FieldworkSampleID
--	INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
	INNER JOIN dbo.DimBlur Dbl ON Dbl.SpeciesKey = fa.speciesKey

WHERE 1=1
--AND ProjectName = '***'
--AND fa.ProjectKey = '16'
AND fa.ProtocolID IN ('1','29','15','28')  ---Vlinders transecten 
AND Aantal > '0'
AND fwp.VisitStartDate > CONVERT(datetime, '2015-01-01', 120)






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


