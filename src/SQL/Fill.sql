
PRINT('Empty tables');

DELETE FROM [KortsteRoute];
GO
DELETE FROM [LijnstukFactor];
GO
DELETE FROM [LijnstukIsochroon]
GO
DELETE FROM [LijnstukWaarneming]
GO
DELETE FROM [Lijnstuk];
GO
DELETE FROM [Knooppunt];
GO
DELETE FROM [IsochroonFactor];
GO
DELETE FROM [Waarneming];
GO
DELETE FROM [Factor];
GO
DELETE FROM [Isochroon];
GO

PRINT('Fill Knooppunt');

SET IDENTITY_INSERT [Knooppunt] ON
INSERT INTO [Knooppunt]
( KnooppuntId
, Latitude
, Longitude )
VALUES
  (0, 51.980009084800002,5.919960600520000)
, (1, 51.980777785999997,5.919664899580000)
, (2, 51.980730583600000,5.916044697210000)
, (3, 51.980854084500002,5.916722997820000)
, (4, 51.981330188199998,5.919453899100000)
, (5, 51.980984485100002,5.917456398500000)
, (6, 51.981994687099998,5.916010396260000)
, (7, 51.982399890000003,5.918249998290000)
, (8, 51.982036792999999,5.923472702860000)
, (9, 51.982590091600002,5.918969699210000)
, (10,51.981554189699999,5.920658300200000)
, (11,51.981778291300003,5.921931701520000)
, (12,51.982821392399998,5.919813099120000)
, (13,51.982002386200001,5.915167096110000)
, (14,51.982000886400002,5.915630196340000)
, (15,51.981994786800001,5.916050596400000)
, (16,51.982030687200002,5.916708096590000)
, (17,51.983139894499999,5.921059999490000)
, (18,51.982336489200001,5.917974497480000)
, (19,51.982442290100003,5.918413398470000)
, (20,51.983389896100000,5.922090000610000)
, (21,51.983132093099996,5.918712897920000)
, (22,51.983579897500000,5.922900000430000)
, (23,51.98381450891543, 5.9183496014521095)
, (24,51.983194795300001,5.921318199330000)
, (25,51.98330502726899, 5.921741888510445)
, (26,51.983439998500003,5.924345401350000)
, (27,51.983558193900002,5.918496597570000)
, (28,51.984143195100003,5.918193896470000)
, (29,51.983717198800001,5.923449100830000)
, (30,51.982578, 5.920003) --manual vanaf hier
, (31,51.982327, 5.920163)
, (32,51.982005, 5.920360)
, (33,51.981753, 5.920526)
, (34,51.982814, 5.921254)
, (35,51.982587, 5.921401)
, (36,51.982197, 5.921658)
, (37,51.982351, 5.922190)
, (38,51.982021, 5.921798)
, (39,51.982210650985536, 5.92328437529273)
, (40,51.98245018873365, 5.922997378947663)
, (41,51.98258069496766, 5.922863268506043)
, (42,51.98277397566313, 5.922686242717446)
, (43,51.982873093640116, 5.922576272155317)
, (44,51.98323487239484, 5.922270500348423)
, (45,51.9827190720263, 5.92319885177249)
, (46,51.982833057820656, 5.9234563438203995)
, (47,51.98296025901679, 5.923727246912471)
, (48,51.98317336150991, 5.924100073940175)
, (49,51.98316675369592, 5.923448297193903)
, (50,51.983389766880094, 5.923153254222338)
, (51,51.98210838457828, 5.918421658913742)
, (52,51.981791200864905, 5.918587955861351)
, (53,51.98169042848579, 5.9179361791150775)
, (54,51.98155331160592, 5.917236122609823)
, (55,51.98125641265954, 5.917328717242921)
, (56,51.981087216034844, 5.91801019878121)
, (57,51.98117365992772, 5.9184426254175095)
, (58,51.981253094709224, 5.918920570647105)
, (59,51.98237918439965, 5.919015401049801)
, (60,51.98215256696546, 5.919121611100822)
, (61,51.98175773591341, 5.919261960096815)
, (62,51.981540460536316, 5.9193454108511885)
, (63,51.98144467213213, 5.920043362615041)
, (64,51.98161288578182, 5.9210258057235094)
, (65,51.981701664951956, 5.92151133738532)
, (66,51.98186520506788, 5.922417916035107)
, (67,51.98196332885086, 5.922983105235182)
, (68,51.980271053449755, 5.919871315996973)
, (69,51.98055723014259, 5.91977207576612)
, (70,51.98100455121374, 5.919614193580671)
, (71,51.98064891743417, 5.919163101622246)
, (72,51.98050444040472, 5.918734564261742)
, (73,51.980337735560965, 5.918161677474544)
, (74,51.98021270652101, 5.917936131495331)
, (75,51.9802960592531, 5.917485039536905)
, (76,51.98040997440276, 5.917092589533076)
, (77,51.98055445173688, 5.916591877459225)
, (78,51.98062113342624, 5.916325733203754)
, (79,51.98271692973326, 5.9193869091556)
, (80,51.982911861794456, 5.920164749716995)
, (81,51.983037410808436, 5.920663640559821)
, (82,51.98349334900498, 5.922476813730521)
, (83,51.98359572026097, 5.923882277428177)
, (84,51.98223976980166, 5.91757122022992)
, (85,51.98212529274045, 5.91706672248757)
, (86,51.98289119069143, 5.918831246440849)
, (87,51.98327427184398, 5.919312891403988)
, (88,51.98343339689474, 5.919890227434749)
, (89,51.9835650184231, 5.920410148832616)
, (90,51.98371039100491, 5.920933259932311)
, (91,51.98347268694369, 5.921124642041956)
, (92,51.9839186265901, 5.921577579890482)
, (93,51.983645562755854, 5.921848704545813)
, (94,51.98414061250914, 5.922218709957793)
, (95,51.98397363205309, 5.922445178787537)
, (96,51.98379093507628, 5.922662078511801)
, (97,51.98409150067522, 5.920563254636663)
, (98,51.98395398725293, 5.920072040555243)
, (99,51.98383611826923, 5.919622292597578)
, (100,51.983781112637345, 5.919389444364177)
, (101,51.98018958593744, 5.920447305870897)
, (102,51.98035906975053, 5.920975083462254)
, (103,51.9805202176994, 5.921394598983588)
, (104,51.980709149039164, 5.921263782315647)
, (105,51.98091474988584, 5.921114921969365)
, (106,51.98116758206571, 5.920875843231401)
, (107,51.981373180808255, 5.920749537483041)
, (108,51.98064524588922, 5.9217780272642635)
, (109,51.98078972246454, 5.92225167382061)
, (110,51.98094809048289, 5.9227298312965395)
, (111,51.981064782348696, 5.923289185324986)
, (112,51.98125093302919, 5.923591416937132)
, (113,51.98143986128702, 5.923943268664702)
, (114,51.981820493739576, 5.923695168087569)
;
GO

SET IDENTITY_INSERT [Knooppunt] OFF

PRINT('Fill Isochroon');

INSERT INTO [Isochroon]
( IsochroonCode
, IsochroonOmschrijving )
VALUES
  ( 'Standaard'
  , 'Standaard isochroon op basis van werkelijke afstand.' )
, ( 'GroenFocus'
  , 'Isochroon met extra nadurk op groen.' )
, ( 'Comfort'
  , 'Isochroon met extra nadurk op comfort.' )
, ( 'Sport'
  , 'Isochroon met extra nadurk op sport mogelijkheden.' )
, ( 'Sport-'
  , 'Isochroon met extra nadurk op sport mogelijkheden maar weinig groen.' )
, ( 'Sport+'
  , 'Isochroon met extra nadurk op sport mogelijkheden maar veel groen.' )
, ( 'Toerist'
  , 'Isochroon met extra nadurk op bezienswaardigheden.' )
, ( 'Gemiddeld'
  , 'Isochroon met alle factoren ingewogen.' );
GO

PRINT('Fill Lijnstuk');

INSERT INTO [Lijnstuk]
( KnooppuntId1
, KnooppuntId2 )
VALUES
  ( 3,  5 )
, ( 2,  3 )
, ( 9,  19 )
, ( 7,  19 )
, ( 7,  18 )
, ( 15, 16 )
, ( 6,  15 )
, ( 6,  14 )
, ( 13, 14 )
, ( 17, 24 )
, ( 24, 25 )
, ( 20, 25 )
, ( 22, 29 )
, ( 27, 28 )
, ( 12, 30 ) --manual vanaf hier
, ( 30, 31 )
, ( 31, 32 )
, ( 32, 33 )
, ( 10, 33 )
, ( 17, 34 )
, ( 34, 35 )
, ( 35, 36 )
, ( 36, 37 )
, ( 36, 38 )
, ( 38, 11 )
, ( 8,  39 )
, ( 39, 40 )
, ( 40, 41 )
, ( 41, 42 )
, ( 42, 43 )
, ( 43, 44 )
, ( 20, 44 )
, ( 41, 45 )
, ( 45, 46 )
, ( 46, 47 )
, ( 47, 48 )
, ( 26, 48 )
, ( 47, 49 )
, ( 49, 50 )
, ( 22, 50 )
, (  7, 51 )
, ( 51, 52 )
, ( 52, 53 )
, ( 53, 54 )
, ( 54, 55 )
, (  5, 55 )
, (  5, 56 )
, ( 56, 57 )
, ( 57, 58 )
, (  4, 58 )
, (  9, 59 )
, ( 59, 60 )
, ( 60, 61 )
, ( 61, 62 )
, (  4, 62 )
, (  4, 63 )
, ( 10, 63 )
, ( 10, 64 )
, ( 64, 65 )
, ( 11, 65 )
, ( 11, 66 )
, ( 66, 67 )
, (  8, 67 )
, (  0, 68 )
, ( 68, 69 )
, (  1, 69 )
, (  1, 70 )
, (  4, 70 )
, (  1, 71 )
, ( 71, 72 )
, ( 72, 73 )
, ( 73, 74 )
, ( 74, 75 )
, ( 75, 76 )
, ( 76, 77 )
, ( 77, 78 )
, (  2, 78 )
, (  9, 79 )
, ( 12, 79 )
, ( 12, 80 )
, ( 80, 81 )
, ( 17, 81 )
, ( 20, 82 )
, ( 22, 82 )
, ( 26, 83 )
, ( 29, 83 )
, ( 18, 84 )
, ( 84, 85 )
, ( 16, 85 )
, (  9, 86 )
, ( 21, 86 )
, ( 21, 27 )
, ( 23, 27 )
, ( 23, 28 )
, ( 21, 87 )
, ( 87, 88 )
, ( 88, 89 )
, ( 89, 90 )
, ( 90, 91 )
, ( 24, 91 )
, ( 90, 92 )
, ( 92, 93 )
, ( 20, 93 )
, ( 92, 94 )
, ( 94, 95 )
, ( 95, 96 )
, ( 22, 96 )
, ( 90, 97 )
, ( 97, 98 )
, ( 98, 99 )
, ( 88, 99 )
, ( 99, 100)
, (  0, 101)
, (101, 102)
, (102, 103)
, (103, 104)
, (104, 105)
, (105, 106)
, (106, 107)
, ( 10, 107)
, (103, 108)
, (108, 109)
, (109, 110)
, (110, 111)
, (111, 112)
, (112, 113)
, (113, 114)
, (  8, 114)
;
GO

PRINT('Fill LijnstukIsochroon');

INSERT INTO [LijnstukIsochroon]
( LijnstukId
, Lengte )
SELECT  LijnstukId
      , [dbo].[UtilityPck_GetLijnstukLengte](LijnstukId) Lengte
FROM    Lijnstuk;
GO

PRINT('Fill Factor');

INSERT INTO [Factor]
( FactorCode
, FactorOmschrijving )
VALUES
  ( 'BomenAant'
  , 'Aantal bomen.' )
, ( 'BomenType'
  , 'Type bomen.' )
, ( 'BomenJaar'
  , 'Leeftijd van de bomen.' )
, ( 'StruikAant'
  , 'Aanntal struiken.' )
, ( 'GrnStrook'
  , 'Aantal vierkante meters groene stroken.' )
, ( 'BoomSchadu'
  , 'Schaduw van bomen.' )
, ( 'BoomBlad'
  , 'Mate van blad op de stoep.' )
, ( 'StoepBreed'
  , 'Breedte van de stoep.' )
, ( 'StoepRuim'
  , 'Vrije ruimte om te lopen.' )
, ( 'StoepMatri'
  , 'Loopgemakt op basis van de materie van de stoep.' )
, ( 'StoepKwali'
  , 'Kwaliteit van de stoep.' )
, ( 'Verlicht'
  , 'Hoeveelheid licht in het donker.' )
, ( 'Architect'
  , 'Architectuur van de gebouwen.' )
, ( 'SocialVorz'
  , 'Mate van sociale voorzieningen.' )
, ( 'GroenPrio'
  , 'Hoe belangrijk is groen.' );
GO

PRINT('Fill IsochroonFactor');

INSERT INTO [IsochroonFactor]
( IsochroonCode
, FactorCode
, Weging )
VALUES
  ( 'GroenFocus'
  , 'BomenAant'
  , 0.15)
, ( 'GroenFocus'
  , 'BomenType'
  , 0.25 )
, ( 'GroenFocus'
  , 'BomenJaar'
  , 0.40 )
, ( 'GroenFocus'
  , 'StruikAant'
  , 0.15 )
, ( 'GroenFocus'
  , 'GrnStrook'
  , 0.05 )
, ( 'Comfort'
  , 'BoomSchadu'
  , 0.05)
, ( 'Comfort'
  , 'BoomBlad'
  , 0.05 )
, ( 'Comfort'
  , 'StoepBreed'
  , 0.175 )
, ( 'Comfort'
  , 'StoepRuim'
  , 0.35 )
, ( 'Comfort'
  , 'StoepMatri'
  , 0.13 )
, ( 'Comfort'
  , 'StoepKwali'
  , 0.17 )
, ( 'Comfort'
  , 'Verlicht'
  , 0.075 )
, ( 'Sport'
  , 'StoepRuim'
  , 0.30 )
, ( 'Sport'
  , 'StoepKwali'
  , 0.15 )
, ( 'Sport'
  , 'BoomBlad'
  , 0.05 )
, ( 'Sport'
  , 'GroenPrio'
  , 0.50 )
, ( 'Sport-'
  , 'StoepRuim'
  , 0.54 )
, ( 'Sport-'
  , 'StoepKwali'
  , 0.27 )
, ( 'Sport-'
  , 'BoomBlad'
  , 0.09 )
, ( 'Sport-'
  , 'GroenPrio'
  , 0.10 )
, ( 'Sport+'
  , 'StoepRuim'
  , 0.06 )
, ( 'Sport+'
  , 'StoepKwali'
  , 0.03 )
, ( 'Sport+'
  , 'BoomBlad'
  , 0.01 )
, ( 'Sport+'
  , 'GroenPrio'
  , 0.90 )
, ( 'Toerist'
  , 'Architect'
  , 0.45 )
, ( 'Toerist'
  , 'SocialVorz'
  , 0.175 )
, ( 'Toerist'
  , 'BomenJaar'
  , 0.175 )
, ( 'Toerist'
  , 'BomenType'
  , 0.08 )
, ( 'Toerist'
  , 'StoepBreed'
  , 0.12 )
, ( 'Gemiddeld'
  , 'BomenAant'
  , 0.1 )
, ( 'Gemiddeld'
  , 'BomenType'
  , 0.08 )
, ( 'Gemiddeld'
  , 'BomenJaar'
  , 0.16 )
, ( 'Gemiddeld'
  , 'StruikAant'
  , 0.07 )
, ( 'Gemiddeld'
  , 'GrnStrook'
  , 0.03 )
, ( 'Gemiddeld'
  , 'BoomSchadu'
  , 0.05 )
, ( 'Gemiddeld'
  , 'BoomBlad'
  , 0.04 )
, ( 'Gemiddeld'
  , 'StoepBreed'
  , 0.08 )
, ( 'Gemiddeld'
  , 'StoepRuim'
  , 0.08 )
, ( 'Gemiddeld'
  , 'StoepMatri'
  , 0.07 )
, ( 'Gemiddeld'
  , 'StoepKwali'
  , 0.05 )
, ( 'Gemiddeld'
  , 'Verlicht'
  , 0.02 )
, ( 'Gemiddeld'
  , 'Architect'
  , 0.1 )
, ( 'Gemiddeld'
  , 'SocialVorz'
  , 0.07 );
GO

PRINT('Fill Waarneming');

INSERT INTO [Waarneming]
( WaarnemingCode
, WaarnemingOmschrijving )
VALUES
  ( 'BomenAant'
  , 'Aantal bomen per 100 meter' )
, ( 'StoepBreed'
  , 'Gemiddelde breedte van de stoep in cm' )
, ( 'GrnStrook'
  , 'Aantal vierkante meters groene stroken per 100 meter' );
GO

PRINT('Fill LijnstukWaarneming');

INSERT INTO [LijnstukWaarneming]
( LijnstukId
, WaarnemingCode
, WaarnemingWaarde )
SELECT  LijnstukId
      , 'BomenAant'
      , round(rand(checksum(newid()))*(15-0)+0,2)
FROM    Lijnstuk
UNION ALL
SELECT  LijnstukId
      , 'StoepBreed'
      , round(rand(checksum(newid()))*(100-5)+5,0) * 10
FROM    Lijnstuk
UNION ALL
SELECT  LijnstukId
      , 'GrnStrook'
      , round(rand(checksum(newid()))*(200-0)+0,0)
FROM    Lijnstuk
GO
PRINT('Fill LijnstukFactor with random scores for GroenFocus isochroon');

INSERT INTO [LijnstukFactor]
  ( LijnstukId
  , FactorCode
  , FactorScore )
SELECT  ltk.LijnstukId
      , ftr.FactorCode
      , round(rand(checksum(newid()))*(1.99-0.01)+0.01,2) FactorScore
FROM    Lijnstuk ltk
CROSS JOIN Factor ftr;

PRINT('Fill LijnstukIsochroon');

with LijnstukWegingsFactor ( IsochroonCode, LijnstukId, WegingsFactor )
  AS  (
        SELECT  ifr.IsochroonCode
              , lfr.LijnstukId
              , sum(lfr.FactorScore * ifr.Weging) WegingsFactor
        FROM    V_LijnstukFactor lfr
        JOIN    IsochroonFactor ifr on lfr.FactorCode = ifr.FactorCode
        GROUP BY
                ifr.IsochroonCode
              , lfr.LijnstukId
      )
INSERT INTO [LijnstukIsochroon]
( LijnstukId
, IsochroonCode
, lengte )
SELECT  lwr.LijnstukId
      , lwr.IsochroonCode
      , lwr.WegingsFactor * slk.Lengte lengte
FROM    LijnstukWegingsFactor lwr
JOIN    V_StandaardLijnstuk slk on lwr.LijnstukId = slk.LijnstukId;