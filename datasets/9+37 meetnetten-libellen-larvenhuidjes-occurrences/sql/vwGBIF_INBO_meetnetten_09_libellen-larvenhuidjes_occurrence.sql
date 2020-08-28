USE [S0008_00_Meetnetten]
GO

/****** Object:  View [ipt].[vwGBIF_INBO_meetnetten_09_37_libellen_larvehuidjes_occurrences]    Script Date: 28/08/2020 11:38:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







/* Generieke query inclusief soorten */


ALTER VIEW [ipt].[vwGBIF_INBO_meetnetten_09_37_libellen_larvehuidjes_occurrences]
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
						ELSE SpeciesLifestageName
						END
	, [occurrenceStatus] = case
						  when Aantal > '0' then 'present'
						  Else 'absent'
						  END
	, [occurrenceRemarks] = case 
						  when SpeciesScientificName IN ('Gomphus flavipes') AND fa.ProjectKey = 23  then 'target species'
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
	, [sex] = CASE Geslacht
				WHEN 'U' THEN 'unknown'
				WHEN 'M' THEN 'male'
				WHEN 'F' THEN 'female'
				ELSE Geslacht
				END
	, [behaviour] = SpeciesActivityName
		
	----Taxon

	, [scientificName] = SpeciesScientificName
	, [vernacularName] = SpeciesName
	, [kingdom] = N'Animalia'
	, [phylum] = N'Arthropoda'
	, [class] = N'Insecta'
	, [order] = N'Odonata'
	, [nomenclaturalCode] = N'ICZN'
	, [taxonRank] =	 case  SpeciesScientificName
						  when  'Pieris spec.' THEN  N'genus'
						  Else 'species'
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
AND fa.ProtocolID IN ('9') ---dragonfly exuvia
AND fwp.VisitStartDate > CONVERT(datetime, '2016-01-01', 120)
AND fwp.VisitStartDate < CONVERT(datetime, '2019-12-31', 120)

--AND SpeciesScientificName like 'Pieris spec.'





















GO


