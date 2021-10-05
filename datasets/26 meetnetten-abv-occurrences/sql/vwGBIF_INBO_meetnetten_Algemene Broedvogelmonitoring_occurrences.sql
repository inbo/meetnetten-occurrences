USE [S0008_00_Meetnetten]
GO

/****** Object:  View [ipt].[vwGBIF_INBO_meetnetten_26_algemene-broedvogelmonitoring_occurrences]    Script Date: 5/10/2021 15:40:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/**2021_07_08 rework query
	occurrenceStatus, DISTINCT, collectionCode**/

/**ALTER VIEW [ipt].[vwGBIF_INBO_meetnetten_26_algemene-broedvogelmonitoring_occurrences]
AS**/

SELECT --fa.*   --unieke kolomnamen
	
	DISTINCT
	 [occurrenceID] = N'INBO:MEETNETTEN:AB:OCC:' + Right( N'0000' + CONVERT(nvarchar(20) ,FieldworkObservationID),7)

	---RECORD ---

/**      [type] = N'Event'
   	, [language] = N'en'
	, [license] = N'http://creativecommons.org/publicdomain/zero/1.0/'
	, [rightsHolder] = N'INBO'
	, [accessRights] = N'https://www.inbo.be/en/norms-data-use'
	, [datasetID] = N'meetnettendatasetDOI'
	, [datasetName] = N'Meetnetten - Generiek Vuursalamander, Belgium'
	, [institutionCode] = N'INBO'

	**/
	
	 ---EVENT---	
	
	, [eventID ] = N'INBO:MEETNET:AB:EVENT:' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkSampleID),6)  
	, [basisOfRecord] = N'HumanObservation'
--	, [samplingProtocol] = Protocolname
	, [lifeStage] = SpeciesLifestageName
--	, [protocol] = ProtocolSubjectDescription
	, [collectionCode] = 'ABV'
	
--	, [samplingEffort] =
						
--	,[eventDate] = SampleDate
--	,[dynamicProperties] = 
	

	--, CONVERT(decimal(10,5), dL.LocationGeom.STCentroid().STY) as decimalLatitude
	--, CONVERT(decimal(10,5), dL.LocationGeom.STCentroid().STX) as decimalLongitude

	---LOCATION
/**	, [locationID] = N'INBO:MEETNET:LOCATION:' + Right( N'000000000' + CONVERT(nvarchar(20) ,dL.LocationID),10) 
	, [continent] = N'Europe'
--	, [waterbody] = dL.Location
	, [countryCode] = N'BE'
	, [locality] = locationName
	, [georeferenceRemarks] = N'coordinates are centroid of location' 
	
	, CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY) as decimalLatitude
	, CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX) as decimalLongitude
	, [geodeticDatum] = N'WGS84'  **/

	
		
	---- OCCURRENCE ---
		
	, [recordedBy] = 'https::/meetnetten.be'
	, [individualCount] = Aantal
	, [occurrenceStatus] = case 
							WHEN aantal >= 1 THEN 'present'
							ELSE 'absent'
							END
							

	
	
	
	----Taxon

	, [scientificName] = SpeciesScientificName
	, [vernacularName] = SpeciesName

	, [kingdom] = N'Animalia'
	, [phylum] = N'Chordata'
	, [class] = N'Aves'
	, [nomenclaturalCode] = N'ICZN'
	, [taxonID] = SpeciesEuringCode
	, [taxonRank] = 'species'
	
--	, fa.ProjectKey
--SELECT *
FROM dbo.FactAantal fA
	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	INNER JOIN dbo.DimLocation dL ON dL.LocationKey = fA.LocationKey
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
	INNER JOIN dbo.DimSpecies dSP ON dsp.SpeciesKey = fa.SpeciesKey
	INNER JOIN (SELECT DISTINCT(FieldworkSampleID), VisitStartDate FROM dbo.FactWerkpakket ) FWp ON FWp.FieldworkSampleID = fa.FieldworkSampleID


	--INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
WHERE 1=1
---AND ProjectName = 'Vuursalamander'
--AND fa.ProjectKey = '16'
AND fa.ProtocolID =  '26'
AND fwp.VisitStartDate > CONVERT(datetime, '2016-08-01', 120)
AND fwp.VisitStartDate < CONVERT(datetime, '2020-12-31', 120)












GO


