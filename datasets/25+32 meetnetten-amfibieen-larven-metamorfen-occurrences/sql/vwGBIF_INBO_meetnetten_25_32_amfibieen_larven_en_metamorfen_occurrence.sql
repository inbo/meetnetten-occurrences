USE [S0008_00_Meetnetten]
GO

/****** Object:  View [ipt].[vwGBIF_INBO_meetnetten_25_32_amfibieen_larven_en_metamorfen_occurrences]    Script Date: 28/08/2020 11:51:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








/* Generieke query inclusief soorten */


ALTER VIEW [ipt].[vwGBIF_INBO_meetnetten_25_32_amfibieen_larven_en_metamorfen_occurrences]
AS

SELECT --fa.*   --unieke kolomnamen
	

	 [occurrenceID] = N'INBO:MEETNET:OCC:' + Right( N'0000' + CONVERT(nvarchar(20) ,FieldworkObservationID),7)

	---RECORD ---

/**      [type] = N'Event'
   	, [language] = N'en'
	, [license] = N'http://creativecommons.org/publicdomain/zero/1.0/'
	, [rightsHolder] = N'INBO'
	, [accessRights] = N'https://www.inbo.be/en/norms-data-use'
	, [datasetID] = N'meetnettendatasetDOI'
	, [datasetName] = N'Meetnetten - vlinders transecten, Belgium'
	, [institutionCode] = N'INBO'

	**/
	
	 ---EVENT---	
	
	, [eventID ] = N'INBO:MEETNET:EVENT:' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkSampleID),6)  
	, [basisOfRecord] = N'HumanObservation'
--	, [samplingProtocol] = Protocolname
	, [lifeStage] = CASE SpeciesLifestageName
					WHEN 'exuvium' THEN 'exuviae'
					WHEN 'imago (not fully colored)' THEN 'imago'
					WHEN 'Larva' THEN 'larva'
					WHEN 'metamorf' THEN 'metamorph'
					ELSE SpeciesLifestageName
					END
	, [occurrenceStatus] = case
						  when Aantal > '0' then 'present'
						  Else 'absent'
						  END
	, [occurrenceRemarks] = case 
						  when SpeciesScientificName IN ('Triturus cristatus') AND fa.ProjectKey = 185  then 'target species'
						  when SpeciesScientificName IN ('Hyla arborea') AND fa.ProjectKey = 13  then 'target species'
						  when SpeciesScientificName IN ('Pelobates fuscus') AND fa.ProjectKey = 152  then 'target species'
						  Else 'casual observation'
						  END
--	, [protocol] = ProtocolSubjectDescription
	
--	, [samplingEffort] =
						
--	,[eventDate] = SampleDate
--	,[dynamicProperties] = 
	

	--, CONVERT(decimal(10,5), dL.LocationGeom.STCentroid().STY) as decimalLatitude
	--, CONVERT(decimal(10,5), dL.LocationGeom.STCentroid().STX) as decimalLongitude

	---LOCATION
--	, [locationID] = N'INBO:MEETNET:LOCATION:' + Right( N'000000000' + CONVERT(nvarchar(20) ,dL.LocationID),10) 
--	, [continent] = N'Europe'
--	, [waterbody] = dL.Location
--	, [countryCode] = N'BE'
--	, [locality] = locationName
--	, [georeferenceRemarks] = N'coordinates are centroid of location' 
	
--	, CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY) as decimalLatitude
--	, CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX) as decimalLongitude
--	, [geodeticDatum] = N'WGS84'

	
		
	---- OCCURRENCE ---
		
	, [recordedBy] = 'https://meetnetten.be'
	, [individualCount] = Aantal
/**	, [sex] = CASE Geslacht
				WHEN 'U' THEN 'unknown'
				WHEN 'M' THEN 'male'
				WHEN 'F' THEN 'female'
				ELSE Geslacht
				END  **/
	, [behaviour] = SpeciesActivityName
		
	----Taxon

	, [scientificName] = SpeciesScientificName
	, [vernacularName] = SpeciesName
	, [kingdom] = N'Animalia'
	, [phylum] = N'Chordata'
	, [class] = N'Amphibia'
--	, [order] = N''
	, [nomenclaturalCode] = N'ICZN'
	, [taxonRank] =	 case  SpeciesScientificName
						  when  'Pieris spec.' THEN  N'genus'
						  when 'Pelophylax esculenta synklepton' THEN 'speciesAggregate'
						  when 'Lissotriton spec.' then N'genus'
						  Else  'species'
						  END
	
--	, fa.ProjectKey
--	, [occurrenceRemarks] = 'data collected in the '  + Dbl.ProjectName + ' monitoring scheme'


	
FROM dbo.FactAantal fA
	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	INNER JOIN dbo.DimLocation dL ON dL.LocationKey = fA.LocationKey
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
	INNER JOIN dbo.DimSpecies dSP ON dsp.SpeciesKey = fa.SpeciesKey
	INNER JOIN dbo.DimBlur Dbl ON Dbl.ProjectKey = fa.projectKey
	INNER JOIN (SELECT DISTINCT(FieldworkSampleID), VisitStartDate FROM dbo.FactWerkpakket ) FWp ON FWp.FieldworkSampleID = fa.FieldworkSampleID

	--INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
WHERE 1=1
--AND ProjectName = '***'
--AND fa.ProjectKey = '16'
AND fa.ProtocolID IN ('25','32') ---amphibia larvae -- larvae & metamorphs
AND fwp.VisitStartDate > CONVERT(datetime, '2016-01-01', 120)
AND fwp.VisitStartDate < CONVERT(datetime, '2019-12-31', 120)

--AND SpeciesScientificName like 'Pieris spec.'
























GO


