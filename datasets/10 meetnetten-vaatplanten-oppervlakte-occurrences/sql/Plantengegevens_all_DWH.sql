/**
created by: Frederic Piesschaert
create date: 2021/06/16

deze query retourneert ALLE bezoeken en observaties, ook deze die afgekeurd zijn. 
Voor verdere verwerking is het logisch om de afgekeurde eruit te filteren. Let op: een afgekeurd bezoek betekent dat alle observaties van
dat bezoek afgekeurd zijn, de validatiestatus van de individuele observaties heeft voor die bezoeken geen betekenis meer.
Daarnaast kunnen er echter ook individueel afgekeurde observaties zijn in een voor de rest geldig bezoek.
Om dit te vereenvoudigen werd een extra veld 'bruikbaar' toegevoegd waar rechtstreeks op gefilterd kan worden
**/

--USE S0008_00_Meetnetten

SELECT * FROM (
SELECT p.name AS meetnet
	, v.id AS visit_id
	, s.id AS sample_id
	, pr.name AS protocol
	, l.name AS locatie
	, u.first_name + ' ' + u.last_name as teller
	, CASE 
		WHEN v.status = -1 THEN 'weersomstandigheden waren ongunstig'
		WHEN v.status = -2 THEN 'telmethode uit handleiding niet gevolgd'
		WHEN v.status = -3 THEN 'geen veldwerk mogelijk - locatie ontoegankelijk'
		WHEN v.status = -4 THEN 'geen veldwerk mogelijk - locatie is ongeschikt voor de soort'
		ELSE 'veldwerk is zonder problemen verlopen'
	  END AS omstandigheden
	, v.start_date AS startdatum
	, v.start_time AS starttijd
	, v.end_date AS einddatum
	, v.end_time AS eindtijd
	, REPLACE(v.notes, CHAR(10) + CHAR(13), ' ') AS bezoek_opmerkingen
	, v.analysis AS analyse
	, v.year_target AS jaardoel
	, o.id AS observation_id
	, REPLACE(o.notes, CHAR(10) + CHAR(13), ' ') AS opmerkingen
	, sp.name as soort
	, sc.name as schaal
	, scc.code AS code
	, scc.description AS code_betekenis
	, coalesce(o.geom.MakeValid().STCentroid().STX, s.geom.MakeValid().STCentroid().STX, l.geom.MakeValid().STCentroid().STX) as X
	, coalesce(o.geom.MakeValid().STCentroid().STY, s.geom.MakeValid().STCentroid().STY, l.geom.MakeValid().STCentroid().STY) as Y
	, CASE
		WHEN o.geom IS NOT NULL and o.is_bound_to_location = 0 THEN 'puntlocatie'
		WHEN s.geom IS NOT NULL and s.is_bound_to_location = 0 THEN 'samplecentroid'
		ELSE 'gebiedscentroid'
	  END AS precisie
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
	LEFT JOIN staging_Meetnetten.fieldwork_sample s ON s.visit_id = v.id
	LEFT JOIN staging_Meetnetten.fieldwork_observation o ON o.sample_id = s.id
	LEFT JOIN staging_Meetnetten.protocols_scale sc ON sc.id = o.scale_id
	LEFT JOIN staging_Meetnetten.protocols_scalecode scc ON scc.id = o.scale_code_id
	LEFT JOIN staging_Meetnetten.species_species sp ON sp.id = o.species_id
	LEFT JOIN staging_Meetnetten.fieldwork_comment fc ON fc.observation_id = o.id
WHERE 1 = 1
	AND p.group_id = 5 --planten
)tmp WHERE tmp.bruikbaar = 1
	--LIMIT 100
