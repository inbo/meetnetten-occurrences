USE [S0008_00_Meetnetten]
GO

/****** Object:  View [ipt].[vwGBIF_INBO_meetnetten_29_vlinders_transecten_alg_occurrences]    Script Date: 1/03/2021 9:23:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











/* Generieke query inclusief soorten
   zonder	Bleek blauwtje
			Boswitje
			Oranje steppevlinder
			Phegeavlinder
			Zuidelijke luzernevlinder
	zonder deze kommavlinders: INBO:MEETNET:OCC:0529736 INBO:MEETNET:OCC:0529738 INBO:MEETNET:OCC:0617922 */



ALTER VIEW [ipt].[vwGBIF_INBO_meetnetten_29_vlinders_transecten_alg_occurrences]
AS

SELECT --fa.*   --unieke kolomnamen
	

	 [occurrenceID] = N'INBO:MEETNET:OCC:' + Right( N'0000' + CONVERT(nvarchar(20) ,FieldworkObservationID),7)

		
	 ---EVENT---	
	
	, [eventID ] = N'INBO:MEETNET:EVENT:' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkSampleID),6) 
--	, [eventID2] = N'INBO:MEETNET:EVENT:' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkVisitID),6) 
	, [basisOfRecord] = N'HumanObservation'
	--, [samplingProtocol] =  case Protocolname
	--						WHEN 'Vlinders - Transecten (algemene monitoring)' THEN 'Flemish butterfly monitoring scheme'
	--						ELSE ' '
	--						END
	
	, [occurrenceStatus] = case
						  when Aantal > '0' then 'present'
						  Else 'absent'
						  END
	
	

		
		
	---- OCCURRENCE ---
		
	, [recordedBy] = 'https://meetnetten.be'
	, [individualCount] = Aantal
	, [lifeStage] = SpeciesLifestageName
	

	
	
	
	----Taxon

	, [scientificName] = SpeciesScientificName
	, [vernacularName] = SpeciesName
	, [kingdom] = N'Animalia'
	, [phylum] = N'Arthropoda'
	, [class] = N'Insecta'
	, [order] = N'Lepidoptera'
	, [nomenclaturalCode] = N'ICZN'
	, [taxonRank] =	 case  SpeciesScientificName
						  when  'Pieris spec.' THEN  N'genus'
						  Else  'species'
						  END
	
--	, fa.ProjectKey
--	, [occurrenceRemarks] = 'data collected in the '  + Dbl.ProjectName + ' monitoring scheme'

	
FROM dbo.FactAantal fA
	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	--INNER JOIN dbo.DimLocation dL ON dL.LocationKey = fA.LocationKey
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
	INNER JOIN dbo.DimSpecies dSP ON dsp.SpeciesKey = fa.SpeciesKey
	--INNER JOIN dbo.DimBlur Dbl ON Dbl.ProjectKey = fa.projectKey
	LEFT JOIN (SELECT DISTINCT(FieldworkSampleID), VisitStartDate FROM dbo.FactWerkpakket ) FWp ON FWp.FieldworkSampleID = fa.FieldworkSampleID
--alle occ moeten voorkomen zowel die aan sectie als die aan track hangen..
/*	LEFT JOIN ( SELECT fa.FieldworkSampleID
					, COALESCE( dlp.LocationKey, dol.LocationKey) as ParentLocationKey
					, COUNT (*) as Nmbr
				FROM dbo.FactAantal fa
				LEFT OUTER JOIN dbo.DimLocation dol ON dol.LocationKey = fa.LocationKey
				LEFT OUTER JOIN dbo.DimLocation dlp ON dlp.LocationID = dol.ParentLocationID
				GROUP BY fa.FieldworkSampleID
					, COALESCE( dlp.LocationKey, dol.LocationKey)
				) ParentLocation ON  ParentLocation.FieldworkSampleID = fa.FieldworkSampleID */
								--AND ParentLocation.ParentLocationKey = fa.LocationKey

	--INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
WHERE 1=1

AND fa.ProtocolID IN ('29') ---Vlinders transecten algemeen
AND fwp.VisitStartDate < CONVERT(datetime, '2020-12-31', 120)
AND fA.FieldworkSampleID > 0
AND SpeciesName NOT IN ('Bleek blauwtje','Boswitje','Oranje steppevlinder','Phegeavlinder','Zuidelijke luzernevlinder')
--AND speciesName like 'kommavlinder'
AND fA.FieldworkSampleID NOT IN ('0529736','0529738','0617922')





GO


