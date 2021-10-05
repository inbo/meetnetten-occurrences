USE [S0008_00_Meetnetten]
GO

/****** Object:  View [ipt].[vwGBIF_INBO_meetnetten_26_algemene-broedvogelmonitoring_events]    Script Date: 5/10/2021 15:39:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO















/*

SELECT * FROM [iptdev].[vwGBIF_INBO_meetnetten_generiek_events];

*/

/* generieke query events, test met vuursalamander
   We creëren meerdere datasets uit meetnetten op basis van protocol
   23/08/2019 Distinct in FROM gebruiken
   05/092019 fix decimalLat & long coalesce
   06/09/2019 Add eventDate FROM factWerkpakket
 */

ALTER VIEW [ipt].[vwGBIF_INBO_meetnetten_26_algemene-broedvogelmonitoring_events]
AS

SELECT --fa.*   --unieke kolomnamen
	
	---RECORD ---
	  DISTINCT
      [type] = N'Event'
   	, [language] = N'en'
	, [license] = N'http://creativecommons.org/publicdomain/zero/1.0/'
	, [rightsHolder] = N'INBO'
	, [accessRights] = N'https://www.inbo.be/en/norms-data-use'
	, [datasetID] = N'meetnettendatasetDOI'
	, [datasetName] = N'Meetnetten - Algemene broedvogelmonitoring, Belgium, post 2016'
	, [institutionCode] = N'INBO'
	
	 ---EVENT---	
	
	, [eventID] = N'INBO:MEETNET:AB:EVENT:' + Right( N'000000000' + CONVERT(nvarchar(20) ,(fA.FieldworkSampleID)),6)  
	, [basisOfRecord] = N'HumanObservation'
	, [samplingProtocol] = 'https://publicaties.vlaanderen.be/view-file/29977'
	, [samplingEffort] = '6 times 5 minutes count/UMT1km'
--	, [lifeStage] = SpeciesLifestageName
	, [protocol] = ProtocolSubjectDescription
	

						
	,[eventDate] = VisitStartDate
--	,[dynamicProperties] = 
	

	--, CONVERT(decimal(10,5), dL.LocationGeom.STCentroid().STY) as decimalLatitude
	--, CONVERT(decimal(10,5), dL.LocationGeom.STCentroid().STX) as decimalLongitude

	---LOCATION
	, [locationID] = N'INBO:MEETNET:LOCATION:' + Right( N'000000000' + CONVERT(nvarchar(20) ,dL.LocationID),10) 
	, [continent] = N'Europe'
--	, [waterbody] = dL.Location
	, [countryCode] = N'BE'
--	, [locality1] = locationName
--	, [locality2] = ParentLocationName
	, [locality] = RegionName
	
	, [verbatimLocality] = COALESCE (parentLocationName, locationName)
	
	,[georeferenceRemarks] = 'coordinates are centroid of used grid square' 
	
	, COALESCE (CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY),CONVERT(decimal(10,5), dL.ParentLocationGeom.MakeValid().STCentroid().STY)) as decimalLatitude
	, COALESCE (CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX), CONVERT(decimal(10,5), dL.ParentLocationGeom.MakeValid().STCentroid().STX)) as decimalLongitude
	
	--, CONVERT(decimal(10,5), dL.ParentLocationGeom.MakeValid().STCentroid().STY) as decimalLatitude2
	--, CONVERT(decimal(10,5), dL.ParentLocationGeom.MakeValid().STCentroid().STX) as decimalLongitude2
	, [geodeticDatum] = N'WGS84'
	,[coordinateUncertaintyInMeters] = '707'
	
	, fa.ProjectKey
	

FROM (SELECT DISTINCT(FieldworkSampleID),FieldworkVisitID,ProjectKey, LocationKey, ProtocolKey, LocationID, ProtocolID, SpeciesActivityID, SpeciesActivityKey, SpeciesLifestageID, SpeciesLifestageKey FROM dbo.FactAantal WHERE FieldworkSampleID > 0) fA
	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	INNER JOIN dbo.DimLocation dL ON dL.LocationKey = fA.LocationKey
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
	--INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
	INNER JOIN (SELECT DISTINCT(FieldworkSampleID), VisitStartDate FROM dbo.FactWerkpakket ) FWp ON FWp.FieldworkSampleID = fa.FieldworkSampleID
WHERE 1=1

AND fa.ProtocolID =  '26'
AND fwp.VisitStartDate > CONVERT(datetime, '2016-08-01', 120)
AND fwp.VisitStartDate < CONVERT(datetime, '2020-12-31', 120)














GO


