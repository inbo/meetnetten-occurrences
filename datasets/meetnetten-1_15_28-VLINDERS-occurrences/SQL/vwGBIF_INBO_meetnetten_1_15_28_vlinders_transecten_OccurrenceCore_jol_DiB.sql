USE [S0008_00_Meetnetten]
GO

/****** Object:  View [iptdev].[vwGBIF_INBO_meetnetten_1_15_28_vlinders_transecten_OccurrenceCore_jol_DiB]    Script Date: 14/10/2019 15:22:17 ******/
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
   remove 'algemene vlindermonitoring' protocolID = 29
 */

/**ALTER VIEW [iptdev].[vwGBIF_INBO_meetnetten_1_15_28_vlinders_transecten_OccurrenceCore_jol_DiB]
AS**/

SELECT --fa.*   --unieke kolomnamen 
	
	---RECORD ---
	 TOP 500
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
	, [parentLocality] = parentLocationName
	/*
	, [georeferenceRemarks] = CASE SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText())))
									WHEN 'LINESTRING' THEN 'original coördinates are starting point of transect'
									WHEN 'Point' THEN ' original coördinates are a point'
									WHEN 'POLYGON' THEN 'original coordinates are centroid of location'
									WHEN 'MULTIPOLYGON' THEN  'original coordinates are centroid of location'
									ELSE 'Something else'
									END */
	, [georeferenceRemarks] = 'original geomerty is a' +  dL.GeoType
	, [decimalLatitude_unblur] = CASE dL.GeoType
						WHEN 'LINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
						WHEN 'MULTILINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
						WHEN 'POINT'  THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
						WHEN 'POLYGON'THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY)
						ELSE NULL
						END
	, [decimalLongitude_unblur] =  CASE dL.GeoType
							WHEN 'LINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
							WHEN 'MULTILINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
							WHEN 'POINT'  THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
							WHEN 'POLYGON'THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX)
							ELSE NULL
							END
	--, dL.PointData as PointData_unblur
	--, utm10.geom  as geom2
	--, utm10.CentroidLat as decimallatitudeCentroid10
	--, utm10.CentroidLong as decimallongitudeCentroid10
	--, utm1.CentroidLat as decimallatitudeCentroid1
	--, utm1.CentroidLong as decimallongitudeCentroid1
	--, utm5.CentroidLat as decimallatitudeCentroid5
	--, utm5.CentroidLong as decimallongitudeCentroid5
	/**These are the blurred decimal and longitudinale coordinates**/
	
	, [decimalLatitude] =  CASE dbl.BlurHokType     --is blurred
							WHEN 'UTM 1Km' THEN utm.Centroid_1_Lat
							WHEN 'UTM 5Km' THEN utm.Centroid_5_Lat
							WHEN 'UTM 10Km' THEN utm.Centroid_10_Lat
							ELSE 'checkthis'
							END
	, [decimalLongitude] =  CASE dbl.BlurHokType ---is blurred
							WHEN 'UTM 1Km' THEN utm.Centroid_1_Long
							WHEN 'UTM 5Km' THEN utm.Centroid_5_Long
							WHEN 'UTM 10Km' THEN utm.Centroid_10_Long
							ELSE 'checkthis'
							END


	/** This is the original unblurred dec lat long calculation, now included in FROM **/
/**
, [decimalLatitude] = CASE 
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'LINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'MULTILINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POINT'  THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POLYGON'THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY)
						END
, [decimalLongitude] =  CASE 
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'LINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'MULTILINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POINT'  THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POLYGON'THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX)
						END
						*/


--	, CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY) as decimalLatitude
--	, CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX) as decimalLongitude
--	, CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY) as decimalLatitude
--	, CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX) as decimalLongitude
--	, SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),1,10) as pointinfo3   **text uit kolom selecteren V1                          
--	, LEFT(CAST(dL.LocationGeom.MakeValid().STAsText() AS VARCHAR(MAX)),10) as pointInfo2   **text uit kolom selecteren V2
	
	, SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) as pointinfo   /***text uit kolom selecteren V3 beste optie***/
	, (dL.LocationGeom.MakeValid().STAsText()) as footprintWKT
	, [geodeticDatum] = N'WGS84'
	, dl.LocationGeom
	, dl.parentLocationGeom
	
---- OCCURRENCE ---
		
	, [recordedBy] = 'Meetnetten'
	, [individualCount] = Aantal
	, [sex] = Geslacht
	, [occurrenceStatus] = CASE Aantal
							When '0' then 'absent'
							Else 'present'
							End
	, [lifeStage] = SpeciesLifestageName

----Taxon

	, [scientificName] = SpeciesScientificName
---	, [vervaging] =  Dbl.BlurDistance  based on NP specieslist, not to use
	, [vernacularName] = SpeciesName
	, [kingdom] = N'Animalia'
	, [phylum] = N'Arthropoda'
	, [class] = N''
	, [nomenclaturalCode] = N'ICZN'
	, fa.ProjectKey
	, [Meetnet] = Dbl.ProjectName 
	
	/**original calculated blur to Use, now included in FROM
	Zo wordt het een beetje te gecompliceerd**/
	--, [BlurToUse2] = case 
	--			WHEN  ProjectName =  'Bruin dikkopje'  THEN 'UTM 5Km'
	--			WHEN	ProjectName = 'Kommavlinder' 				THEN 'UTM 1Km'
	--			WHEN	ProjectName = 'Kommavlinder' AND ParentLocationName in ('Groot Schietveld 2','Klein Schietveld') THEN 'UTM 5Km'
	--			WHEN	ProjectName = 'Veldparelmoervlinder'		THEN 'UTM 1Km'
	--			WHEN	ProjectName = 'Veldparelmoervlinder' AND ParentLocationName in ('Groot Schietveld 2','Klein Schietveld') THEN 'UTM 5Km'
	--			WHEN	ProjectName = 'Bruine eikenpage'			THEN 'UTM 1Km'
				
	--			WHEN	ProjectName = 'Heivlinder' AND ParentLocationName in ('Groot Schietveld 2','Groot Schietveld','Klein Schietveld') THEN 'UTM 5Km'
	--			WHEN	ProjectName = 'Heivlinder'				    THEN 'UTM 1Km'
	--			WHEN	ProjectName = 'Gentiaanblauwtje'			THEN 'UTM 5Km'
	--			WHEN	ProjectName = 'Klaverblauwtje'			    THEN 'UTM 5Km'
	--			WHEN	ProjectName = 'Grote weerschijnvlinder'	    THEN 'UTM 5Km'
	--			WHEN	ProjectName = 'Aardbeivlinder'			    THEN 'UTM 5Km'
	--			WHEN	ProjectName = 'Oranje zandoogje'			THEN 'UTM 1Km'
	--			WHEN	ProjectName = 'Oranje zandoogje' AND ParentLocationName in ('Groot Schietveld 2','Groot Schietveld','Klein Schietveld') THEN 'UTM 5Km'
	--			WHEN	ProjectName = 'Argusvlinder'				THEN 'UTM 1Km'
	--			END
	
	, [BlurToUse] = dbl.BlurHokType
	, [parentLocality2] = parentLocationName
FROM dbo.FactAantal fA
	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	INNER JOIN ( SELECT *
					, CASE 
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'LINESTRING' THEN 'LINESTRING'
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'MULTILINESTRING' THEN 'MULTILINESTRING'
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POINT'  THEN 'POINT'  
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POLYGON' THEN 'POLYGON'
						ELSE 'Something else'
						END as GeoType
					/*, CASE 
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'LINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'MULTILINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POINT'  THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POLYGON'THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY)
						END as STY
					, CASE 
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'LINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'MULTILINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POINT'  THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POLYGON'THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX)
						END as STX
					*/
				
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
						END, 4326) as PointData
						
				FROM dbo.DimLocation dL) dL ON dL.LocationKey = fA.LocationKey
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
	INNER JOIN dbo.DimSpecies dSP ON dsp.SpeciesKey = fa.SpeciesKey
	INNER JOIN (SELECT DISTINCT(FieldworkSampleID), VisitStartDate FROM dbo.FactWerkpakket ) FWp ON FWp.FieldworkSampleID = fa.FieldworkSampleID
--	INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
	INNER JOIN dbo.DimBlur Dbl ON Dbl.ProjectKey = fa.projectKey
	--INNER JOIN (SELECT N'Bruin dikkopje' as	project , N'UTM 5Km' as HokType UNION
	--			SELECT N'Kommavlinder'				, N'UTM 1Km' UNION
	--			SELECT N'Veldparelmoervlinder'		, N'UTM 1Km' UNION
	--			SELECT N'Bruine eikenpage'			, N'UTM 1Km' UNION
	--			SELECT N'Heivlinder'				, N'UTM 1Km' UNION
	--			SELECT N'Gentiaanblauwtje'			, N'UTM 5Km' UNION
	--			SELECT N'Klaverblauwtje'			, N'UTM 5Km' UNION
	--			SELECT N'Grote weerschijnvlinder'	, N'UTM 5Km' UNION
	--			SELECT N'Aardbeivlinder'			, N'UTM 5Km' UNION
	--			SELECT N'Oranje zandoogje'			, N'UTM 1Km' UNION
	--			SELECT N'Argusvlinder'				, N'UTM 1Km' ) as Blur ON Blur.project = dP.ProjectName
	--INNER JOIN [shp].[utm10_vl_WGS84] utm10 ON utm10.geom.STIntersects(dL.PointData) = 1
	--INNER JOIN [shp].[utm5_vl_WGS84] utm5 ON utm5.geom.STIntersects(dL.PointData) = 1
	--INNER JOIN [shp].[utm1_vl_WGS84] utm1 ON utm1.geom.STIntersects(dL.PointData) = 1
	INNER JOIN [shp].[utm_vl_WGS84] utm WITH (INDEX(SI_utm_vl_WGS84__geom_1)) ON utm.geom_1.STIntersects(dL.PointData) = 1
	
	
	--INNER JOIN [shp].[utm10_vl_WGS84] utm10 ON dL.PointData.STWithin(utm10.geom) = 1
	
WHERE 1=1
--AND ProjectName = '***'
--AND fa.ProjectKey = '16'
AND fa.ProtocolID IN ('1','15','28')  ---Vlinders transecten 
AND Aantal > '0'
AND fwp.VisitStartDate > CONVERT(datetime, '2015-01-01', 120)
--AND projectName = 'Argusvlinder'
--AND fa.FieldworkObservationID =  491520
--ORDER BY speciesName Asc
--ORDER BY fa.FieldworkObservationID
--AND ParentLocationName in ('Groot Schietveld 2','Klein Schietveld')
--AND projectname = 'kommavlinder'
--AND ProjectName = 'heivlinder'





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


