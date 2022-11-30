USE [S0008_00_Meetnetten]
GO

/****** Object:  View [ipt].[vwGBIF_INBO_meetnetten_35_vaatplanten_individuen_occurrences_meas]    Script Date: 30/11/2022 11:21:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











/* Generieke query inclusief soorten */


ALTER VIEW [ipt].[vwGBIF_INBO_meetnetten_35_vaatplanten_individuen_occurrences_meas]
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
	, [datasetName] = N'Meetnetten - vascular plants, surface in Flanders, Belgium count'
	, [institutionCode] = N'INBO'

	**/
	
	 ---EVENT---	
	
	, [eventID ] = N'INBO:MEETNET:EVENT:' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkSampleID),6)  
	, [basisOfRecord] = N'HumanObservation'
	, [collectionCode] = 'meetnetten'
--	, [samplingProtocol] = Protocolname
	, [lifeStage] = CASE SpeciesLifestageName
					WHEN 'exuvium' THEN 'exuviae'
					WHEN 'imago (not fully colored)' THEN 'imago'
					ELSE SpeciesLifestageName
					END
	, [occurrenceStatus] = case
						  when Aantal > '0' then 'present'
						  Else 'absent'
						  END
	, [occurrenceRemarks] = case 
						  when SpeciesName IN ('Koprus') AND fa.ProjectKey = 92  then 'target species'
						  when SpeciesName IN ('Krabbenscheer') AND fa.ProjectKey = 96  then 'target species'
						  when SpeciesName IN ('Purperorchis') AND fa.ProjectKey = 112  then 'target species'
						  when SpeciesName IN ('Honingorchis') AND fa.ProjectKey = 92  then 'target species'
						  when SpeciesName IN ('Kleine schorseneer') AND fa.ProjectKey = 80  then 'target species'
						  when SpeciesName IN ('Veenmosorchis') AND fa.ProjectKey = 132  then 'target species'
						  when SpeciesName IN ('Grote bremraap') AND fa.ProjectKey = 68  then 'target species'
						  when SpeciesName IN ('Kleine wolfsklauw') AND fa.ProjectKey = 84  then 'target species'
						  when SpeciesName IN ('Welriekende nachtorchis') AND fa.ProjectKey = 140  then 'target species'
						  when SpeciesName IN ('Duingentiaan') AND fa.ProjectKey = 56  then 'target species'
						  when SpeciesName IN ('Harlekijn') AND fa.ProjectKey = 72  then 'target species'
						  when SpeciesName IN ('Honingorchis') AND fa.ProjectKey = 76  then 'target species'
						  when SpeciesName IN ('Fijn goudscherm') AND fa.ProjectKey = 60  then 'target species'
						  Else 'casual observation'
						  END
--	, [protocol] = ProtocolSubjectDescription
	, fa.projectKey
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
--	, [individualCount] = Aantal
	--, [sex] = CASE Geslacht
	--			WHEN 'U' THEN 'unknown'
	--			WHEN 'M' THEN 'male'
	--			WHEN 'F' THEN 'female'
	--			ELSE Geslacht
	--			END
	--, [behaviour] = SpeciesActivityName
	  , protocolName	
	----Taxon


	, [organismQuantityType] = CASE sm.schaal 
								WHEN 'Floron class (count)' THEN 'Floron scale plant count'
								ELSE sm.schaal
								END
	, [organismQuantity] = CASE sm.code_betekenis
							WHEN 'afwezig' THEN 'absent'
							ELSE code + ' (' + sm.code_betekenis + ')'
							END
--	, sm.code
--  , sm.code_betekenis
	



	, [scientificName] = SpeciesScientificName
	, [vernacularName] = SpeciesName
	, [kingdom] = N'Plantae'
	--	, [order] = N''
	, [nomenclaturalCode] = N'ICBN'
	, [taxonRank] =	 case  SpeciesScientificName
						  when  'Pieris spec.' THEN  N'genus'
						  Else 'species'
						  END
	
--	, fa.ProjectKey
--	, [occurrenceRemarks] = 'data collected in the '  + Dbl.ProjectName + ' monitoring scheme'


	
    , sm.validatiestatus_observatie
	, sm.validatie_bezoek
	, bruikbaar
	--4645
--SELECT *	
FROM dbo.FactAantal fA
	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	INNER JOIN dbo.DimLocation dL ON dL.LocationKey = fA.LocationKey
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
	INNER JOIN dbo.DimSpecies dSP ON dsp.SpeciesKey = fa.SpeciesKey
	INNER JOIN dbo.DimBlur Dbl ON Dbl.ProjectKey = fa.projectKey
	INNER JOIN (SELECT DISTINCT(FieldworkSampleID), VisitStartDate FROM dbo.FactWerkpakket ) FWp ON FWp.FieldworkSampleID = fa.FieldworkSampleID
	INNER JOIN (SELECT *
						FROM ( SELECT   p.[name] AS meetnet
									, pr.id as Protocol_ID
									, o.id AS observation_id
									, sc.[name] as schaal
									, scc.code AS code
									, scc.[description] AS code_betekenis
									, o.reference AS referentie
									, CASE 
										WHEN v.validation_status = -1 THEN 'afgekeurd'
										WHEN v.validation_status = 100 THEN 'goedgekeurd'
										WHEN v.validation_status = 10 THEN 'open'
										ELSE NULL
									  END AS validatie_bezoek
									, CASE WHEN o.validation_status_id = 1 THEN 'open'
										WHEN o.validation_status_id = 2 THEN 'in behandeling'
										WHEN o.validation_status_id = 3 THEN 'in behandeling'
										WHEN o.validation_status_id = 4 THEN 'goedgekeurd'
										WHEN o.validation_status_id = 5 THEN 'afgekeurd'
										WHEN o.validation_status_id = 6 THEN 'niet te beoordelen'
										WHEN o.validation_status_id = 7 THEN 'gevalideerd via bezoek'
										ELSE 'open'
									  END AS validatiestatus_observatie
									, REPLACE(fc.notes, CHAR(10) + CHAR(13), ' ') AS validatie_opmerkingen
									, CASE WHEN v.validation_status = -1 THEN 0 
										WHEN o.validation_status_id = 5 THEN 0
										ELSE 1 
									  END AS bruikbaar
								FROM staging_Meetnetten.projects_project p
									INNER JOIN staging_Meetnetten.fieldwork_visit v ON v.project_id = p.id
									INNER JOIN staging_Meetnetten.locations_location l ON l.id = v.location_id
									INNER JOIN staging_Meetnetten.protocols_protocol pr ON pr.id = v.protocol_id
									INNER JOIN staging_Meetnetten.accounts_user u ON u.id = v.user_id
									
									INNER JOIN staging_Meetnetten.fieldwork_sample s ON s.visit_id = v.id
									INNER JOIN staging_Meetnetten.fieldwork_observation o ON o.sample_id = s.id

									LEFT JOIN staging_Meetnetten.protocols_scale sc ON sc.id = o.scale_id
									LEFT JOIN staging_Meetnetten.protocols_scalecode scc ON scc.id = o.scale_code_id
									LEFT JOIN staging_Meetnetten.species_species sp ON sp.id = o.species_id
									LEFT JOIN staging_Meetnetten.fieldwork_comment fc ON fc.observation_id = o.id
								WHERE 1 = 1
								AND p.group_id = 5 --planten
								)tmp 
							WHERE tmp.bruikbaar = 1
						) SM ON sm.observation_id = fa.FieldworkObservationID 
							AND sm.Protocol_ID = fa.ProtocolID
	--LIMIT 100


	--INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
WHERE 1=1
--AND ProjectName = '***'
--AND fa.ProjectKey = '16'
AND fa.ProtocolID IN ('35') ---vaatplanten
AND fwp.VisitStartDate > CONVERT(datetime, '2016-01-01', 120)
AND fwp.VisitStartDate < CONVERT(datetime, '2021-12-31', 120)
--AND ( sm.schaal IS NULL OR sm.code_betekenis IS NULL OR Aantal =0)

--AND SpeciesScientificName like 'Pieris spec.'








GO


