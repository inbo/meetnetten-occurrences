USE [S0008_00_Meetnetten]
GO

/****** Object:  View [ipt].[vwGBIF_INBO_meetnetten_42_lentevuurspin_events_2022]    Script Date: 17/08/2022 15:57:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











ALTER VIEW [ipt].[vwGBIF_INBO_meetnetten_42_lentevuurspin_events_2022]
AS

SELECT --fa.*   --unieke kolomnamen 
	DISTINCT 
	---RECORD ---
	 
--	  [occurrenceID] = N'INBO:MEETNETTEN:OCC:' + Right( N'0000' + CONVERT(nvarchar(20) ,fa.FieldworkObservationID),7)

      [type] = N'Event'
   	, [language] = N'en'
	, [license] = N'http://creativecommons.org/publicdomain/zero/1.0/'
	, [rightsHolder] = N'INBO'
	, [accessRights] = N'https://www.inbo.be/en/norms-data-use'
	, [datasetID] = N''
	, [institutionCode] = N'INBO'
	, [datasetName] = N'Meetnetten.be - Area counts for Eresus sandaliatus in Flanders, Belgium'
	
	, [informationWithheld] = N'original locations available upon request'
	, [dataGeneralizations] = N'coordinates are generalized from a ' + duL.GeoType + N' to a ' + dbl.BlurHokType + N' grid'
	
	 ---EVENT---	
--	, fA.FieldworkSampleID
	, [eventID] = N'INBO:MEETNET:EVENT:' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkSampleID),6)  
	, [parentEventID] = N'INBO:MEETNET:VISITID:' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkVisitID),6)
--	, [basisOfRecord] = N'HumanObservation'
	, [samplingProtocol] =  CASE Protocolname
							WHEN 'Sprinkhanen - Wegvangst' THEN 'grasshopper, capture and count'
							WHEN 'Sprinkhanen - Gebiedstelling' THEN 'grasshoppers site counts'
							WHEN 'Vlinders - Transecten (algemene monitoring)' THEN 'Flemish butterfly monitoring scheme'
							WHEN 'Lentevuurspin - Gebiedstelling' THEN 'area count'
							ELSE ProtocolName
							END
--	, fa.ProtocolID
	, [eventDate] = CONVERT(VARCHAR(10), fwp.VisitStartDate, 20)
	, [eventRemarks] = 'data collected in the '  + dbl.ProjectName + ' project'


	---LOCATION
	, [locationID] = N'INBO:MEETNET:LOCATION:' + Right( N'00' + CONVERT(nvarchar(20) ,duL.LocationID),6) 
	, [continent] = N'Europe'
	, [countryCode] = N'BE'
--	, [locality0] = locationName
--	, [parentLocality0] = parentLocationName
	, [locality] = LTRIM (CONCAT (dul.ParentLocationName,'  ',dul.LocationName))
	
	
	-- USE FOR UNBLURRED DATA
	--, [decimalLatitude_unblur] = CASE dL.GeoType
	--					WHEN 'LINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
	--					WHEN 'MULTILINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
	--					WHEN 'POINT'  THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
	--					WHEN 'POLYGON'THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY)
	--					ELSE NULL
	--					END
	--, [decimalLongitude_unblur] =  CASE dL.GeoType
	--						WHEN 'LINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
	--						WHEN 'MULTILINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
	--						WHEN 'POINT'  THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
	--						WHEN 'POLYGON'THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX)
	--						ELSE NULL
	--						END
	-- USE FOR BLURRED DATA IN GBIF
	, [decimalLatitude] =  CASE      --is blurred
							
							WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone = '1' THEN utm.Centroid_5_Lat
							WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone <> '1' THEN utm.Centroid_1_Lat
							WHEN dbl.BlurHokType = 'UTM 5Km' THEN utm.Centroid_5_Lat
							WHEN dbl.BlurHokType = 'UTM 10Km' THEN utm.Centroid_10_Lat
							ELSE 'checkthis'
							END
	, [decimalLongitude] =  CASE ---is blurred
							
							WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone = '1' THEN utm.Centroid_5_Long
							WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone <> '1' THEN utm.Centroid_1_Long
							WHEN dbl.BlurHokType = 'UTM 5Km' THEN utm.Centroid_5_Long
							WHEN dbl.BlurHokType = 'UTM 10Km' THEN utm.Centroid_10_Long
							ELSE 'checkthis'
							END
	, [geodeticDatum] = N'WGS84'
	, [coordinateUncertaintyInMeters] =  CASE      --is blurred
							
							WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone = '1' THEN '3536'
							WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone <> '1' THEN '707'
							WHEN dbl.BlurHokType = 'UTM 5Km' THEN '3536'
							WHEN dbl.BlurHokType = 'UTM 10Km' THEN '7071'
							ELSE 'checkthis'
							END
	, [georeferenceRemarks] = 'coordinates are centroid of used grid square'

	

FROM dbo.FactAantal fA


	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
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

	INNER JOIN ( SELECT *
					, CASE 
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'LINESTRING' THEN 'LINESTRING'
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'MULTILINESTRING' THEN 'MULTILINESTRING'
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POINT'  THEN 'POINT'  
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POLYGON' THEN 'POLYGON'
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'MULTIPOLYGON' THEN 'MULTIPOLYGON'
						ELSE 'Something else'
						END as GeoType
					, geometry::STGeomFromText ( CASE 
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'LINESTRING' 
							THEN --geometry::STGeomFromText(
							'POINT(' + CONVERT(nvarchar(500), CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)) + ' ' + CONVERT(nvarchar(500),CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)) + ')' 
							--, 0 )
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'MULTILINESTRING' 
							THEN --geometry::STGeomFromText(
							'POINT(' + CONVERT(nvarchar(500), CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)) + ' ' + CONVERT(nvarchar(500),CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)) + ')'
							--, 0 )
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POINT'  
							THEN --geometry::STGeomFromText(
							'POINT(' + CONVERT(nvarchar(500), CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)) + ' ' + CONVERT(nvarchar(500),CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)) + ')'
							--, 0 )
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POLYGON'  
							THEN --geometry::STGeomFromText(
							'POINT(' + CONVERT(nvarchar(500), CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX)) + ' ' + CONVERT(nvarchar(500),CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY)) + ')'
							--, 0 )
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'MULTIPOLYGON'  
							THEN --geometry::STGeomFromText(
							'POINT(' + CONVERT(nvarchar(500), CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX)) + ' ' + CONVERT(nvarchar(500),CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY)) + ')'
							--, 0 )
						END, 4326) as PointData
						
				FROM dbo.DimLocation dL) duL ON duL.LocationKey = ParentLocation.ParentLocationKey

--	INNER JOIN dbo.DimSpecies dSP ON dsp.SpeciesKey = fa.SpeciesKey
	INNER JOIN (SELECT DISTINCT(FieldworkSampleID), VisitStartDate FROM dbo.FactWerkpakket ) FWp ON FWp.FieldworkSampleID = fa.FieldworkSampleID
--	INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
	INNER JOIN dbo.DimBlur Dbl ON Dbl.ProjectKey = fa.projectKey
	INNER JOIN [shp].[utm_vl_WGS84] utm WITH (INDEX(SI_utm_vl_WGS84__geom_1)) ON utm.geom_1.STIntersects(duL.PointData) = 1
	
	
	--INNER JOIN [shp].[utm10_vl_WGS84] utm10 ON dL.PointData.STWithin(utm10.geom) = 1
	
WHERE 1=1

AND fa.ProtocolID IN ('42')  ---gebiedstelling area count lentevuurspin
AND fwp.VisitStartDate < CONVERT(datetime, '2021-12-31', 120)
























































GO


