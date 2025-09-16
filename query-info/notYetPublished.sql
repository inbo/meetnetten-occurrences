SELECT protocolName,fa.ProtocolID, fa.projectkey, dp.ProjectName, BlurHokType,
  Count(*) 

FROM dbo.FactAantal fA
	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	INNER JOIN dbo.DimLocation dL ON dL.LocationKey = fA.LocationKey
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
	INNER JOIN dbo.DimSpecies dSP ON dsp.SpeciesKey = fa.SpeciesKey
	LEFT JOIN dbo.DimBlur db ON db.ProjectKey  = dp.ProjectKey

	--INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
WHERE 1=1
--AND BlurHokType is NULL
AND protocolName not in ('Vlinders - Transecten','Amfibieën - Fuiken (v1)','Libellen - Populatietelling per locatie',
						'Vuursalamander - Transect (v1)','Padden en kikkers - Roepkoren','Libellen - Transect','Libellen - Larvenhuidjes',
						'Vaatplanten - Oppervlakte','Lentevuurspin - Transect','Sprinkhanen - Gebiedstelling','Sprinkhanen - Wegvangst','Vlinders - Eitellingen',
						'Amfibieën - Larven','Algemene Broedvogelmonitoring','Vlinders - Gebiedstelling (v1)','Vlinders - Transecten (algemene monitoring)','Amfibieën - Larven en metamorfen',
						'Rugstreeppad - Roepkoren','Rugstreeppad - Zichtwaarneming','Vaatplanten - Aantal individuen','Libellen - Larvenhuidjes Beekrombout','Vlinders - Gebiedstelling',
						'Lentevuurspin - Gebiedstelling','Amfibieën - Fuiken', 'Vuursalamander - Transect','Knoflookpad - Roepkoren')
Group by protocolName, fa.protocolID, fa.projectKey, dp.ProjectName, BlurHokType


ORDER BY ProtocolID ASC