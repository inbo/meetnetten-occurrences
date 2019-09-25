SELECT eventID, count (*) as tel FROM [iptdev].[vwGBIF_INBO_meetnetten_29_vlinders-transecten(algemene monitoring)_events]
Group BY eventID
ORDER BY tel DESC

SELECT eventID, count (*) as tel FROM [iptdev].[vwGBIF_INBO_meetnetten_1_vlinders_transecten_events]
Group BY eventID
ORDER BY tel DESC


SELECT eventID, count (*) as tel FROM [iptdev].[vwGBIF_INBO_meetnetten_15_vlinders-eitellingen_events]
Group BY eventID
ORDER BY tel DESC

SELECT eventID, count (*) as tel FROM [iptdev].[vwGBIF_INBO_meetnetten_28_vlinders-gebiedstelling(v1)_events]
Group BY eventID
ORDER BY tel DESC


