USE [S0008_00_Meetnetten]
GO

/****** Object:  View [ipt].[vwGBIF_INBO_meetnetten_10_vaatplanten_oppervlakte_occurrences_meas]    Script Date: 30/11/2022 9:22:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

















/* Generieke query inclusief soorten 
   2021_06_22  aanpassen naar organismQuantity voor planten
*/


ALTER VIEW [ipt].[vwGBIF_INBO_meetnetten_10_vaatplanten_oppervlakte_occurrences_meas]
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
	, [datasetName] = N'Meetnetten - vascular plants in Flanders, Belgium'
	, [institutionCode] = N'INBO'

	**/
	
	 ---EVENT---	
	
	, [eventID ] = N'INBO:MEETNET:EVENT:' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkSampleID),6)  
	, [basisOfRecord] = N'HumanObservation'
	, [collectionCode] = 'meetnetten'
--	, [samplingProtocol] = Protocolname
	--, [lifeStage] = CASE SpeciesLifestageName
	--				WHEN 'exuvium' THEN 'exuviae'
	--				WHEN 'imago (not fully colored)' THEN 'imago'
	--				ELSE SpeciesLifestageName
	--				END
	, [occurrenceStatus] = case
						  when Aantal > '0' then 'present'
						  Else 'absent'
						  END
	, [occurrenceRemarks] = case 
						  when SpeciesScientificName IN ('Potamogeton acutifolius') AND fa.ProjectKey = 124  then 'target species'
						  when SpeciesScientificName IN ('Wahlenbergia hederacea') AND fa.ProjectKey = 88  then 'target species'
						  when SpeciesScientificName IN ('Gentiana uliginosa') AND fa.ProjectKey = 56  then 'target species'
						  when SpeciesScientificName IN ('Scirpus triqueter') AND fa.ProjectKey = 52  then 'target species'
						  when SpeciesScientificName IN ('Potamogeton coloratus') AND fa.ProjectKey = 136  then 'target species'
						  when SpeciesScientificName IN ('Eriophorum gracile') AND fa.ProjectKey = 120  then 'target species'
						  when SpeciesScientificName IN ('Carex diandra') AND fa.ProjectKey = 116  then 'target species'
						  when SpeciesScientificName IN ('Ranunculus ololeucos') AND fa.ProjectKey = 144  then 'target species'
						  when SpeciesScientificName IN ('Schoenoplectus pungens') AND fa.ProjectKey = 128  then 'target species'
						  when SpeciesScientificName IN ('Utricularia ochroleuca') AND fa.ProjectKey = 48  then 'target species'
						  when SpeciesScientificName IN ('Halimione pedunculata') AND fa.ProjectKey = 64  then 'target species'
						  when SpeciesScientificName IN ('Apium repens') AND fa.ProjectKey = 128  then 'target species'
						  when SpeciesScientificName IN ('Deschampsia setacea') AND fa.ProjectKey = 100  then 'target species'
						  when SpeciesScientificName IN ('Potamogeton compressus') AND fa.ProjectKey = 128  then 'target species'
						  when SpeciesScientificName IN ('Mentha pulegium') AND fa.ProjectKey = 108  then 'target species'
						  when SpeciesScientificName IN ('Gentianella uliginosa') AND fa.ProjectKey = 56  then 'target species'
						  when SpeciesScientificName IN ('Scirpus pungens') AND fa.ProjectKey = 128  then 'target species'
					      when SpeciesScientificName IN ('Potamogeton compressus') AND fa.ProjectKey = 104  then 'target species'
						  ELSE 'casual observation'
						  END
    , dP.ProjectName
	, dp.ProjectKey

	
		
	---- OCCURRENCE ---
		
	, [recordedBy] = 'https://meetnetten.be'
	--, [individualCount] = Aantal
	
	  , protocolName
	  	
	----,  TAXON ----- 

	, [organismQuantityType] = CASE sm.schaal 
								WHEN 'cover (Floron)' THEN 'Floron scale plant cover'
								ELSE sm.schaal
								END

	, [organismQuantity] = CASE sm.code_betekenis
							WHEN 'afwezig' THEN 'absent'
							ELSE code + '  (' + sm.code_betekenis + ')'
							END
--	, sm.code
--	, sm.code_betekenis
	    

	, [scientificName] = SpeciesScientificName
	, [vernacularName] = SpeciesName
	, [kingdom] = N'Plantae'
	, [nomenclaturalCode] = N'ICBN'
	, [taxonRank] =	 case  SpeciesScientificName
						  when  'Pieris spec.' THEN  N'genus'
						  Else 'species'
						  END
	
--	, fa.ProjectKey
--	, [occurrenceRemarks] = 'data collected in the '  + Dbl.ProjectName + ' monitoring scheme'
    , sm.validatiestatus_observatie
	, sm.validatie_bezoek
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
AND fa.ProtocolID IN ('10') ---vaatplanten
AND fwp.VisitStartDate > CONVERT(datetime, '2016-01-01', 120)
AND fwp.VisitStartDate < CONVERT(datetime, '2021-12-31', 120)
--AND ( sm.schaal IS NULL OR sm.code_betekenis IS NULL OR Aantal =0)

--AND SpeciesScientificName like 'Pieris spec.'




























GO


