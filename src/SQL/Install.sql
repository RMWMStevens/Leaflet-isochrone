/**************************************************************************************************
Creation Date:  27-MAY-2023
Created by:     Tom Vloet
Description:    DDL for database db-arnhemisochroon. Meant to calculate the shortest routes between
                GPS coordinates. Take into consideration the experience of the citizens of Arnhem in
                order to make improvements on government policy regarding walking in the city.
**************************************************************************************************/

PRINT('Drop procedures');
GO

DROP PROCEDURE IF EXISTS [KortsteRoutePck_BerekenVoorAlleKnooppenten]
GO
DROP PROCEDURE IF EXISTS [KortsteRoutePck_BerekenVoorKnooppunt]
GO
DROP PROCEDURE IF EXISTS [KortsteRoutePck_DefaultsKlaarzetten]
GO

PRINT('Drop functions');
GO

DROP FUNCTION IF EXISTS [IsochroonPck_IsochroonExists];
GO
DROP FUNCTION IF EXISTS [IsochroonPck_GetIsochronen];
GO
DROP FUNCTION IF EXISTS [IsochroonFactorPck_GetFactoren];
GO
DROP FUNCTION IF EXISTS [LijnstukIsochroonPck_GetRow];
GO
DROP FUNCTION IF EXISTS [LijnstukIsochroonPck_GetLengte];
GO
DROP FUNCTION IF EXISTS [UtilityPck_GetLijnstukLengte];
GO
DROP FUNCTION IF EXISTS [UtilityPck_GetAfstandTussenKnooppuntenUsingKnooppuntId];
GO
DROP FUNCTION IF EXISTS [UtilityPck_GetAfstandTussenKnooppuntenUsingGps];
GO
DROP FUNCTION IF EXISTS [KortsteRoutePck_GetGpsVanKnooppuntenAsJson];
GO
DROP FUNCTION IF EXISTS [KortsteRoutePck_GetGpsVanKnooppunten];
GO
DROP FUNCTION IF EXISTS [KortsteRoutePck_GetLijnstukken];
GO
DROP FUNCTION IF EXISTS [KortsteRoutePck_GetRow];
GO
DROP FUNCTION IF EXISTS [LijnstukPck_GetId];
GO
DROP FUNCTION IF EXISTS [LijnstukPck_GetRowById];
GO
DROP FUNCTION IF EXISTS [LijnstukPck_GetRowByKnooppunten];
GO
DROP FUNCTION IF EXISTS [KnooppuntPck_GetLatitude];
GO
DROP FUNCTION IF EXISTS [KnooppuntPck_GetLongitude];
GO
DROP FUNCTION IF EXISTS [KnooppuntPck_GetRow];
GO
DROP FUNCTION IF EXISTS [WaarnemingPck_GetWaarnemingen];
GO
DROP FUNCTION IF EXISTS [LijnstukWaarnemingPck_GetWaarnemingenByLijnstukId];
GO
DROP FUNCTION IF EXISTS [LijnstukWaarnemingPck_GetWaarnemingenByKnooppunten];
GO

PRINT('Drop views');
GO

DROP VIEW IF EXISTS [V_StandaardLijnstuk];
GO
DROP VIEW IF EXISTS [V_LijnstukIsochroon];
GO
DROP VIEW IF EXISTS [V_IsochroonFactor];
GO
DROP VIEW IF EXISTS [V_LijnstukFactor];
GO

PRINT('Drop tables');
GO

DROP TABLE IF EXISTS [LijnstukIsochroon];
GO
DROP TABLE IF EXISTS [LijnstukFactor];
GO
DROP TABLE IF EXISTS [LijnstukWaarneming];
GO
DROP TABLE IF EXISTS [KortsteRoute];
GO
DROP TABLE IF EXISTS [IsochroonFactor];
GO
DROP TABLE IF EXISTS [Factor];
GO
DROP TABLE IF EXISTS [Waarneming];
GO
DROP TABLE IF EXISTS [Isochroon];
GO
DROP TABLE IF EXISTS [Lijnstuk];
GO
DROP TABLE IF EXISTS [Knooppunt];
GO

PRINT('Drop types');
GO

DROP TYPE IF EXISTS [FactorScoreType];
GO
DROP TYPE IF EXISTS [WaarnemingWaardeType];
GO
DROP TYPE IF EXISTS [PercentageType];
GO
DROP TYPE IF EXISTS [FactorCodeType];
GO
DROP TYPE IF EXISTS [FactorOmschrijvingType];
GO
DROP TYPE IF EXISTS [WaarnemingCodeType];
GO
DROP TYPE IF EXISTS [WaarnemingOmschrijvingType];
GO
DROP TYPE IF EXISTS [IsochroonCodeType];
GO
DROP TYPE IF EXISTS [IsochroonOmschrijvingType];
GO
DROP TYPE IF EXISTS [MeterType];
GO
DROP TYPE IF EXISTS [GeografieType];
GO

PRINT('CREATE types');
GO

CREATE TYPE [FactorScoreType] FROM NUMERIC(3,2);
GO
CREATE TYPE [WaarnemingWaardeType] FROM NUMERIC(7,3);
GO
CREATE TYPE [PercentageType] FROM NUMERIC(4,2);
GO
CREATE TYPE [GeografieType] FROM DECIMAL(17,15);
GO
CREATE TYPE [MeterType] FROM NUMERIC(7,1);
GO
CREATE TYPE [IsochroonOmschrijvingType] FROM NVARCHAR(100);
GO
CREATE TYPE [IsochroonCodeType] FROM NVARCHAR(10);
GO
CREATE TYPE [FactorOmschrijvingType] FROM NVARCHAR(100);
GO
CREATE TYPE [FactorCodeType] FROM NVARCHAR(10);
GO
CREATE TYPE [WaarnemingOmschrijvingType] FROM NVARCHAR(100);
GO
CREATE TYPE [WaarnemingCodeType] FROM NVARCHAR(10);
GO

PRINT('CREATE tables');
GO

CREATE TABLE [Knooppunt]
( KnooppuntId INT IDENTITY NOT NULL PRIMARY KEY
, Latitude [GeografieType] NOT NULL
, Longitude [GeografieType] NOT NULL );
GO

CREATE TABLE [Lijnstuk]
( LijnstukId INT IDENTITY NOT NULL PRIMARY KEY
, KnooppuntId1 INT NOT NULL
, KnooppuntId2 INT NOT NULL
, CONSTRAINT uc_Knooppunten UNIQUE (KnooppuntId1, KnooppuntId2)
, FOREIGN KEY (KnooppuntId1) REFERENCES [Knooppunt](KnooppuntId)
, FOREIGN KEY (KnooppuntId2) REFERENCES [Knooppunt](KnooppuntId));
GO

CREATE TABLE [Isochroon]
( IsochroonCode [IsochroonCodeType] PRIMARY KEY NOT NULL
, IsochroonOmschrijving [IsochroonOmschrijvingType] );
GO

CREATE TABLE [LijnstukIsochroon]
( LijnstukIsochroonId INT IDENTITY NOT NULL PRIMARY KEY
, LijnstukId INT NOT NULL
, IsochroonCode [IsochroonCodeType] NOT NULL DEFAULT 'Standaard'
, Lengte [MeterType] NOT NULL
, CONSTRAINT uc_LijnstukIsochroon UNIQUE (LijnstukId, IsochroonCode)
, FOREIGN KEY (LijnstukId) REFERENCES [Lijnstuk](LijnstukId)
, FOREIGN KEY (IsochroonCode) REFERENCES [Isochroon](IsochroonCode));
GO

CREATE TABLE [Factor]
( FactorCode [FactorCodeType] PRIMARY KEY NOT NULL
, FactorOmschrijving [FactorOmschrijvingType] );
GO

CREATE TABLE [Waarneming]
( WaarnemingCode [WaarnemingCodeType] PRIMARY KEY NOT NULL
, WaarnemingOmschrijving [WaarnemingOmschrijvingType] );
GO

CREATE TABLE [IsochroonFactor]
( IsochroonCode [IsochroonCodeType] NOT NULL
, FactorCode [FactorCodeType] NOT NULL
, Weging [PercentageType] NOT NULL
, CONSTRAINT pk_IsochroonFactor PRIMARY KEY (IsochroonCode, FactorCode)
, CONSTRAINT fk_IsochroonFactorIsochroon FOREIGN KEY (IsochroonCode) REFERENCES [Isochroon] (IsochroonCode)
, CONSTRAINT fk_IsochroonFactorFactor FOREIGN KEY (FactorCode) REFERENCES [Factor] (FactorCode) );
GO

CREATE TABLE [LijnstukFactor]
( LijnstukFactorId INT IDENTITY NOT NULL PRIMARY KEY
, LijnstukId INT NOT NULL
, FactorCode [FactorCodeType] NOT NULL
, FactorScore [FactorScoreType] NOT NULL
, CONSTRAINT uc_LijnstukFactor UNIQUE (LijnstukId, FactorCode)
, CONSTRAINT fk_LijnstukFactorLijnstuk FOREIGN KEY (LijnstukId) REFERENCES [Lijnstuk] (LijnstukId)
, CONSTRAINT fk_LijnstukFactorFactor FOREIGN KEY (FactorCode) REFERENCES [Factor] (FactorCode)
, CONSTRAINT ck_FactorScoreThreshold check (FactorScore > 0 AND FactorScore < 2));
GO

CREATE TABLE [LijnstukWaarneming]
( LijnstukWaarnemingId INT IDENTITY NOT NULL PRIMARY KEY
, LijnstukId INT NOT NULL
, WaarnemingCode [WaarnemingCodeType] NOT NULL
, WaarnemingWaarde [WaarnemingWaardeType] NOT NULL
, CONSTRAINT uc_LijnstukWaarneming UNIQUE (LijnstukId, WaarnemingCode)
, CONSTRAINT fk_LijnstukWaarnemingLijnstuk FOREIGN KEY (LijnstukId) REFERENCES [Lijnstuk] (LijnstukId)
, CONSTRAINT fk_LijnstukWaarnemingWaarneming FOREIGN KEY (WaarnemingCode) REFERENCES [Waarneming] (WaarnemingCode) );
GO

CREATE TABLE [KortsteRoute]
( KortsteRouteId INT IDENTITY NOT NULL PRIMARY KEY
, IsochroonCode [IsochroonCodeType] NOT NULL
, KnooppuntId1 INT NOT NULL
, KnooppuntId2 INT NOT NULL
, KortsteRoute [MeterType] NOT NULL DEFAULT 999999.99
, VorigeKnooppuntId INT
, CONSTRAINT uc_KortsteRoute UNIQUE (IsochroonCode, KnooppuntId1, KnooppuntId2)
, CONSTRAINT fk_KortsteRouteIsochroon FOREIGN KEY (IsochroonCode) REFERENCES [Isochroon] (IsochroonCode)
, CONSTRAINT fk_KortsteRouteKnooppuntId1 FOREIGN KEY (KnooppuntId1) REFERENCES [Knooppunt] (KnooppuntId)
, CONSTRAINT fk_KortsteRouteKnooppuntId2 FOREIGN KEY (KnooppuntId2) REFERENCES [Knooppunt] (KnooppuntId)
, CONSTRAINT fk_KortsteRouteVorigeKnooppuntId FOREIGN KEY (VorigeKnooppuntId) REFERENCES [Knooppunt] (KnooppuntId) );
GO

PRINT('CREATE views');
GO

CREATE OR ALTER VIEW [V_StandaardLijnstuk] AS
SELECT  LijnstukId
      , Lengte
FROM    LijnstukIsochroon
WHERE   IsochroonCode = 'Standaard';
GO

CREATE OR ALTER VIEW [V_LijnstukIsochroon] AS
SELECT  lsk.LijnstukId
      , lin.IsochroonCode
      , lin.Lengte
      , lsk.KnooppuntId1
      , lsk.KnooppuntId2
FROM    LijnstukIsochroon lin
JOIN    Lijnstuk lsk ON lsk.LijnstukId = lin.LijnstukId;
GO

CREATE OR ALTER VIEW [V_IsochroonFactor] AS
SELECT  isn.IsochroonCode
      , isn.IsochroonOmschrijving
      , ftr.FactorCode
      , ftr.FactorOmschrijving
      , ifr.Weging
FROM    IsochroonFactor ifr
JOIN    Isochroon isn ON isn.IsochroonCode = ifr.IsochroonCode
JOIN    Factor ftr ON ftr.FactorCode = ifr.FactorCode;
GO

CREATE OR ALTER VIEW [V_LijnstukFactor] AS
SELECT  lsk.LijnstukId
      , lsk.KnooppuntId1
      , lsk.KnooppuntId2
      , ftr.FactorCode
      , lfr.FactorScore
FROM    LijnstukFactor lfr
JOIN    Lijnstuk lsk ON lsk.LijnstukId = lfr.LijnstukId
JOIN    Factor ftr ON ftr.FactorCode = lfr.FactorCode;
GO

PRINT('CREATE functions');
GO

CREATE OR ALTER FUNCTION [dbo].[KnooppuntPck_GetRow]
( @KnooppuntId INT ) RETURNS TABLE AS
RETURN
( SELECT  *
  FROM    Knooppunt
  WHERE   KnooppuntId = @KnooppuntId );
GO

CREATE OR ALTER FUNCTION [dbo].[KnooppuntPck_GetLatitude]
( @KnooppuntId INT ) RETURNS [GeografieType] AS
BEGIN
  DECLARE @Latitude [GeografieType];
  SELECT  @Latitude = Latitude
  FROM    [KnooppuntPck_GetRow](@KnooppuntId);
  RETURN  @Latitude;
END
GO

CREATE OR ALTER FUNCTION [dbo].[KnooppuntPck_GetLongitude]
( @KnooppuntId INT ) RETURNS [GeografieType] AS
BEGIN
  DECLARE @Longitude [GeografieType];
  SELECT  @Longitude = Longitude
  FROM    [KnooppuntPck_GetRow](@KnooppuntId);
  RETURN  @Longitude;
END
GO

CREATE OR ALTER FUNCTION [dbo].[LijnstukPck_GetRowByKnooppunten]
( @KnooppuntId1 INT
, @KnooppuntId2 INT ) RETURNS TABLE AS
RETURN
( SELECT  *
  FROM    Lijnstuk
  WHERE   KnooppuntId1 = @KnooppuntId1
  AND     KnooppuntId2 = @KnooppuntId2
  UNION ALL
  SELECT  *
  FROM    Lijnstuk
  WHERE   KnooppuntId1 = @KnooppuntId2
  AND     KnooppuntId2 = @KnooppuntId1 );
GO

CREATE OR ALTER FUNCTION [dbo].[LijnstukPck_GetRowById]
( @LijnstukId1 INT ) RETURNS TABLE AS
RETURN
( SELECT  *
  FROM    Lijnstuk
  WHERE   LijnstukId = @LijnstukId1 );
GO

CREATE OR ALTER FUNCTION [dbo].[LijnstukIsochroonPck_GetRow]
( @KnooppuntId1 INT
, @KnooppuntId2 INT ) RETURNS TABLE AS
RETURN
( SELECT  *
  FROM    V_LijnstukIsochroon
  WHERE   KnooppuntId1 = @KnooppuntId1
  AND     KnooppuntId2 = @KnooppuntId2 );
GO

CREATE OR ALTER FUNCTION [dbo].[LijnstukIsochroonPck_GetLengte]
( @KnooppuntId1 INT
, @KnooppuntId2 INT ) RETURNS [MeterType] AS
BEGIN
  DECLARE @Lengte [MeterType];
  SELECT  @Lengte = Lengte
  FROM    [LijnstukIsochroonPck_GetRow](@KnooppuntId1, @KnooppuntId2);
  RETURN  @Lengte;
END
GO

CREATE OR ALTER FUNCTION [dbo].[LijnstukPck_GetId]
( @KnooppuntId1 INT
, @KnooppuntId2 INT ) RETURNS INT AS
BEGIN
  DECLARE @LijnstukId INT;
  SELECT  @LijnstukId = LijnstukId
  FROM    [LijnstukPck_GetRowByKnooppunten](@KnooppuntId1, @KnooppuntId2);
  RETURN  @LijnstukId;
END
GO

CREATE OR ALTER FUNCTION [dbo].[WaarnemingPck_GetWaarnemingen]
( ) RETURNS TABLE AS
RETURN
( SELECT  *
  FROM    Waarneming );
GO

CREATE OR ALTER FUNCTION [dbo].[LijnstukWaarnemingPck_GetWaarnemingenByLijnstukId]
( @LijnstukId INT ) RETURNS TABLE AS
RETURN
( SELECT  WaarnemingCode
        , WaarnemingWaarde
  FROM    LijnstukWaarneming
  WHERE   LijnstukId = @LijnstukId );
GO

CREATE OR ALTER FUNCTION [dbo].[LijnstukWaarnemingPck_GetWaarnemingenByKnooppunten]
( @KnooppuntId1 INT
, @KnooppuntId2 INT ) RETURNS TABLE AS
RETURN
( SELECT  lwg.WaarnemingCode
        , lwg.WaarnemingWaarde
  FROM    LijnstukWaarneming lwg
  CROSS APPLY [dbo].[LijnstukPck_GetRowByKnooppunten](@KnooppuntId1, @KnooppuntId2) lsk 
  WHERE   lsk.lijnstukId = lwg.LijnstukId);
GO

CREATE OR ALTER FUNCTION [dbo].[KortsteRoutePck_GetRow]
( @IsochroonCode [IsochroonCodeType]
, @KnooppuntId1 INT
, @KnooppuntId2 INT ) RETURNS TABLE AS
RETURN
( SELECT  *
  FROM    KortsteRoute
  WHERE   IsochroonCode = @IsochroonCode
  AND     KnooppuntId1 = @KnooppuntId1
  AND     KnooppuntId2 = @KnooppuntId2 );
GO

CREATE OR ALTER FUNCTION [dbo].[KortsteRoutePck_GetGpsVanKnooppunten]
( @IsochroonCode [IsochroonCodeType]
, @KnooppuntId1 INT
, @KortsteRoute [MeterType]) RETURNS TABLE AS
RETURN
( SELECT  kpt.Latitude
        , kpt.Longitude
  FROM    KortsteRoute kre
  JOIN    Knooppunt kpt ON kpt.KnooppuntId = kre.KnooppuntId2
  WHERE   IsochroonCode = @IsochroonCode
  AND     kre.KnooppuntId1 = @KnooppuntId1
  AND     kre.KortsteRoute <= @KortsteRoute );
GO

CREATE OR ALTER FUNCTION [dbo].[KortsteRoutePck_GetLijnstukken]
( @IsochroonCode [IsochroonCodeType]
, @KnooppuntId1 INT
, @KortsteRoute [MeterType]) RETURNS TABLE AS
RETURN
( SELECT  lsk.LijnstukId
        , lsk.KnooppuntId1
        , lsk.KnooppuntId2
        , kpt1.Latitude KnooppuntId1Latitude
        , kpt1.Longitude KnooppuntId1Longitude
        , kpt2.Latitude KnooppuntId2Latitude
        , kpt2.Longitude KnooppuntId2Longitude
  FROM    KortsteRoute kre
  CROSS APPLY [dbo].[LijnstukPck_GetRowByKnooppunten](kre.VorigeKnooppuntId, kre.KnooppuntId2) lsk
  JOIN    Knooppunt kpt1 ON kpt1.KnooppuntId = lsk.KnooppuntId1
  JOIN    Knooppunt kpt2 ON kpt2.KnooppuntId = lsk.KnooppuntId2
  WHERE   IsochroonCode = @IsochroonCode
  AND     kre.KnooppuntId1 = @KnooppuntId1
  AND     kre.KortsteRoute <= @KortsteRoute );
GO

CREATE OR ALTER FUNCTION [dbo].[KortsteRoutePck_GetGpsVanKnooppuntenAsJson]
( @IsochroonCode [IsochroonCodeType]
, @KnooppuntId1 INT
, @KortsteRoute [MeterType] ) RETURNS NVARCHAR(max) AS
BEGIN
  DECLARE @GpsJson NVARCHAR(max);
  SELECT  @GpsJson =
    (
      SELECT  Latitude
            , Longitude
      FROM    [dbo].[KortsteRoutePck_GetGpsVanKnooppunten](@IsochroonCode,@KnooppuntId1,@KortsteRoute)
      FOR JSON PATH
    );
  RETURN  @GpsJson;
END
GO

CREATE OR ALTER FUNCTION [dbo].[UtilityPck_GetAfstandTussenKnooppuntenUsingGps]
( @Latitude1 [GeografieType]
, @Longitude1 [GeografieType]
, @Latitude2 [GeografieType]
, @Longitude2 [GeografieType] )
RETURNS [MeterType]
AS
BEGIN
  DECLARE @EarthRadius FLOAT = 6378160; -- Earth's radius in meters
  DECLARE @DegreesLatitude FLOAT = RADIANS(@Latitude2 - @Latitude1);
  DECLARE @DegreesLongitude FLOAT = RADIANS(@Longitude2 - @Longitude1);
  DECLARE @a FLOAT = SQUARE(SIN(@DegreesLatitude / 2)) + COS(RADIANS(@Latitude1)) * COS(RADIANS(@Latitude2)) * SQUARE(SIN(@DegreesLongitude / 2));
  DECLARE @CentralAngle FLOAT = 2 * ATN2(SQRT(@a), SQRT(1 - @a));
  DECLARE @Afstand [MeterType] = @EarthRadius * @CentralAngle;
  RETURN @Afstand;
END;
GO

CREATE OR ALTER FUNCTION [dbo].[UtilityPck_GetAfstandTussenKnooppuntenUsingKnooppuntId]
( @KnooppuntId1 INT
, @KnooppuntId2 INT )
RETURNS [MeterType]
AS
BEGIN
    DECLARE @Afstand [MeterType];
    DECLARE @Latitude1 [GeografieType];
    DECLARE @Longitude1 [GeografieType];
    DECLARE @Latitude2 [GeografieType];
    DECLARE @Longitude2 [GeografieType];

    SELECT  @Latitude1 = Latitude
          , @Longitude1 = Longitude
    FROM    Knooppunt
    WHERE   KnooppuntId = @KnooppuntId1;

    SELECT  @Latitude2 = Latitude
          , @Longitude2 = Longitude
    FROM    Knooppunt
    WHERE   KnooppuntId = @KnooppuntId2

    SELECT @Afstand = [dbo].[UtilityPck_GetAfstandTussenKnooppuntenUsingGps] (
                  @Latitude1 , @Longitude1
                , @Latitude2 , @Longitude2 )
    RETURN @Afstand;
END;
GO

CREATE OR ALTER FUNCTION [dbo].[UtilityPck_GetLijnstukLengte]
( @LijnstukId INT )
RETURNS [MeterType]
AS
BEGIN
    DECLARE @Afstand [MeterType];
    DECLARE @KnooppuntId1 INT;
    DECLARE @KnooppuntId2 INT;

    SELECT  @KnooppuntId1 = KnooppuntId1
          , @knooppuntId2 = KnooppuntId2
    FROM    [dbo].[LijnstukPck_GetRowById](@LijnstukId);

    SELECT  @Afstand = [dbo].[UtilityPck_GetAfstandTussenKnooppuntenUsingKnooppuntId] (
      @KnooppuntId1
    , @KnooppuntId2 )
    RETURN @Afstand;
END;
GO

CREATE OR ALTER FUNCTION [dbo].[IsochroonFactorPck_GetFactoren]
( @IsochroonCode [IsochroonCodeType] )
RETURNS TABLE AS
RETURN
  (
    SELECT  FactorCode
          , FactorOmschrijving
          , Weging
    FROM    V_IsochroonFactor
    WHERE   IsochroonCode = @IsochroonCode
  );
GO

CREATE OR ALTER FUNCTION [dbo].[IsochroonPck_GetIsochronen]
( )
RETURNS TABLE AS
RETURN
  (
    SELECT  IsochroonCode
          , IsochroonOmschrijving
    FROM    Isochroon
  );
GO

CREATE OR ALTER FUNCTION [dbo].[IsochroonPck_IsochroonExists]
( @IsochroonCode [IsochroonCodeType] )
RETURNS BIT AS
BEGIN
    IF EXISTS ( 
                SELECT  1
                FROM    Isochroon
                WHERE   IsochroonCode = @IsochroonCode
              )
        RETURN 1;
    RETURN 0;
END;
GO

PRINT('CREATE procedures');
GO

CREATE OR ALTER PROCEDURE [dbo].[KortsteRoutePck_DefaultsKlaarzetten]
( @IsochroonCode [IsochroonCodeType] )
AS

BEGIN
  SET NOCOUNT ON
  DELETE FROM [KortsteRoute]
  WHERE IsochroonCode = @IsochroonCode;

  INSERT INTO [KortsteRoute]
    ( IsochroonCode
    , KnooppuntId1
    , KnooppuntId2
    , KortsteRoute )
  SELECT  @IsochroonCode IsochroonCode
        , kp1.KnooppuntId KnooppuntId1
        , kp2.KnooppuntId KnooppuntId2
        , CASE
            WHEN kp1.KnooppuntId = kp2.KnooppuntId
              THEN 0
              ELSE 999999.9
          END KortsteRoute
  FROM    Knooppunt kp1
  CROSS JOIN Knooppunt kp2;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[KortsteRoutePck_BerekenVoorKnooppunt]
( @IsochroonCode [IsochroonCodeType]
, @StartingPoint INT )
AS

BEGIN
  SET NOCOUNT ON
  /* Bewaar bezochte knooppunten in deze tabel variabele */
  DECLARE @Bezocht TABLE
  ( KnooppuntId INT NOT NULL PRIMARY KEY );
  /* Bewaar nog niet bezochte knooppunten in deze tabel variabele */
  DECLARE @NietBezocht TABLE
  ( KnooppuntId INT NOT NULL PRIMARY KEY );
  DECLARE @Bezoeken INT;
  DECLARE @Naaste INT;
  DECLARE @Afstand [MeterType];

  DELETE FROM @Bezocht;
  DELETE FROM @NietBezocht;

  INSERT INTO @NietBezocht ( KnooppuntId )
  SELECT  KnooppuntId
  FROM    Knooppunt;

  WHILE EXISTS (SELECT 1 FROM @NietBezocht)
  BEGIN

    /* Begin bij het bezoeken van de nog niet bezochte knooppunt met de kortste afstand vanaf het start knooppunt */
    SELECT  TOP 1
            @Bezoeken = kre.KnooppuntId2
    FROM    KortsteRoute kre
    WHERE   kre.IsochroonCode = @IsochroonCode
    AND     kre.KnooppuntId1 = @StartingPoint
    AND     NOT EXISTS  (
                          SELECT  1
                          FROM    @Bezocht bzt
                          WHERE   bzt.KnooppuntId = kre.KnooppuntId2
                        )
    ORDER BY KortsteRoute ASC

    DECLARE c_neighbours CURSOR for
    /* Bekijk niet bezochte naaste punten van punt wat nu bezocht wordt */
    SELECT  isnull( CASE
                      WHEN lin.KnooppuntId1 = @Bezoeken
                      THEN NULL
                      ELSE lin.KnooppuntId1
                    END
                  , CASE
                      WHEN lin.KnooppuntId2 = @Bezoeken
                      THEN NULL
                      ELSE lin.KnooppuntId2
                    END) Neighbour
          , lin.Lengte
    FROM    V_LijnstukIsochroon lin
    WHERE ( KnooppuntId1 = @Bezoeken
    OR      KnooppuntId2 = @Bezoeken )
    AND     lin.IsochroonCode = @IsochroonCode
    AND     NOT EXISTS  (
                          SELECT  1
                          FROM    @Bezocht bzt
                          WHERE   bzt.KnooppuntId = lin.KnooppuntId1
                          OR      bzt.KnooppuntId = lin.KnooppuntId2
                        )
    ORDER BY lengte ASC;

    OPEN c_neighbours
    FETCH NEXT FROM c_neighbours INTO @Naaste, @Afstand

    WHILE @@FETCH_STATUS = 0
    BEGIN
      /* Bereken de afstand van startpunt tot deze naaste punt van het punt wat we nu boeken */
      SELECT  @Afstand = @Afstand + KortsteRoute
      FROM    KortsteRoute
      WHERE   IsochroonCode = @IsochroonCode
      AND     KnooppuntId1 = @StartingPoint
      AND     KnooppuntId2 = @Bezoeken

      /* Als de nieuw berekende afstand korter is dan de huidige kortste afstand moet de kortste route worden bijgewerkt  */
      if @Afstand < (
                      SELECT  KortsteRoute
                      FROM    KortsteRoute
                      WHERE   IsochroonCode = @IsochroonCode
                      AND     KnooppuntId1 = @StartingPoint
                      AND     KnooppuntId2 = @Naaste
                     )
        update  KortsteRoute
        SET     KortsteRoute = @Afstand
        ,       VorigeKnooppuntId = @Bezoeken
        WHERE   IsochroonCode = @IsochroonCode
        AND     KnooppuntId1 = @StartingPoint
        AND     KnooppuntId2 = @Naaste

      FETCH NEXT FROM c_neighbours INTO @Naaste, @Afstand
    END

    DELETE FROM @NietBezocht
    WHERE KnooppuntId = @Bezoeken;

    INSERT INTO @Bezocht (KnooppuntId)
    VALUES (@Bezoeken);

    CLOSE c_neighbours
    DEALLOCATE c_neighbours

  END
END
GO

CREATE OR ALTER PROCEDURE [dbo].[KortsteRoutePck_BerekenVoorAlleKnooppenten]
( @IsochroonCode [IsochroonCodeType] )
AS 
DECLARE @StartPunt INT;
BEGIN
  SET NOCOUNT ON
  IF [dbo].[IsochroonPck_IsochroonExists](@IsochroonCode) = 0
  BEGIN
    DECLARE @errorMessage VARCHAR(100);
    SET @errorMessage = 'IsochroonCode "' + CAST(@IsochroonCode AS VARCHAR(10)) + '" bestaat niet.';
    THROW 50001, @errorMessage, 1;
  END;

  EXECUTE [dbo].[KortsteRoutePck_DefaultsKlaarzetten] @IsochroonCode

  DECLARE c_Knooppunten CURSOR for
  SELECT KnooppuntId
  FROM   Knooppunt
  ORDER BY KnooppuntId

  OPEN c_Knooppunten
  FETCH NEXT FROM c_Knooppunten INTO @StartPunt

  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXECUTE [dbo].[KortsteRoutePck_BerekenVoorKnooppunt] @IsochroonCode, @StartPunt
    FETCH NEXT FROM c_Knooppunten INTO @StartPunt
  END
  CLOSE c_Knooppunten
  DEALLOCATE c_Knooppunten
END
GO 