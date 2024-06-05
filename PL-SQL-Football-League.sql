-- ***********************
-- - DBS311 - NDD
-- Name of the Student: 
-- Samaneh Hajigholam, Student ID: 119751220
-- Date: Nov 16, 2023
-- Date of Completion: Nov 26, 2023
-- ***********************
SET SERVEROUTPUT ON;

-- Q1 -> For each table in (Players, Teams, Rosters) create Stored Procedures to cover the 4 basic CRUD tasks. (if the PK using autonumber, the SP returns the new PK)

-- Q1 SOLUTION --
-- **********Players Table*************
--INSERT
CREATE OR REPLACE PROCEDURE spPlayersInsert (
   p_playerid IN players.playerid%TYPE,
   p_regnumber IN players.regnumber%TYPE,
   p_lname IN players.lastname%TYPE,
   p_fname IN players.firstname%TYPE,
   p_isactive IN players.isactive%TYPE,
   p_errorCode OUT NUMBER
) AS
BEGIN
    p_errorCode := 0;
    INSERT INTO players (
            playerid, 
            regnumber, 
            lastname, 
            firstname, 
            isactive
            )
        VALUES (
            p_playerid, 
            p_regnumber, 
            p_lname, 
            p_fname, 
            p_isactive
            );
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_errorCode := -2;
    WHEN OTHERS THEN
        p_errorCode := -10;
END spPlayersInsert;
--**** test ****
-- 1-Correct id
DECLARE
    tError NUMBER;
BEGIN
    spPlayersInsert(101, 55555, 'Smith', 'Sam', 0, tError);
    IF tError = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Insert Successful');
    ELSIF tError = -2 THEN
        DBMS_OUTPUT.PUT_LINE('Duplicate Value for the player ID');
    ELSIF tError = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;

--2-Duplicate playerid
DECLARE
    tError NUMBER;
BEGIN
    spPlayersInsert(1, 55586, 'Haj', 'Rihana', 0, tError);
    IF tError = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Insert Successful');
    ELSIF tError = -2 THEN
        DBMS_OUTPUT.PUT_LINE('Duplicate Value for the player ID');
    ELSIF tError = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
--3-violates a constraint
DECLARE
    tError NUMBER;
BEGIN
    spPlayersInsert(NULL, 55555, 'Smith', 'Sam', 0, tError);
    IF tError = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Insert Successful');
    ELSIF tError = -2 THEN
        DBMS_OUTPUT.PUT_LINE('Duplicate Value for the player ID');
    ELSIF tError = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
--UPDATE
CREATE OR REPLACE PROCEDURE spPlayersUpdate (
    p_playerid IN players.playerid%TYPE,
    p_regnumber IN players.regnumber%TYPE,
    p_lname IN players.lastname%TYPE,
    p_fname IN players.firstname%TYPE,
    p_isactive IN players.isactive%TYPE,
    p_errorCode OUT NUMBER
) AS
BEGIN
    p_errorCode := 0;
    UPDATE players
   SET regnumber = p_regnumber,
       lastname = p_lname,
       firstname = p_fname,
       isactive = p_isactive
   WHERE playerid = p_playerid;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_errorCode := -1;
    WHEN OTHERS THEN
        p_errorCode := -10;
END spPlayersUpdate;

--**** test ****
--Update existing player
DECLARE
    tErrorCode NUMBER;
BEGIN
    spPlayersUpdate(1302, 43211, 'Smith', 'Micheal', 1, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Update Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;

--Try to update a non-existing player
DECLARE
    tErrorCode NUMBER;
BEGIN
    spPlayersUpdate(999, 43211, 'Smith', 'Micheal', 1, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Update Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;

-- violates a constraint
DECLARE
    tErrorCode NUMBER;
BEGIN
    spPlayersUpdate(null, 43211, 'Smith', 'Micheal', 1, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Update Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;

--DELETE
CREATE OR REPLACE PROCEDURE spPlayersDelete (
   p_playerid IN players.playerid%TYPE,
   p_errorCode OUT NUMBER
) AS
BEGIN
    p_errorCode := 0;
   DELETE FROM players WHERE playerid = p_playerid;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_errorCode := -1;
    WHEN TOO_MANY_ROWS THEN
        p_errorCode := -3;
    WHEN OTHERS THEN
        p_errorCode := -10;
END spPlayersDelete;

--**** test ****
-- Delete an existing player
DECLARE
    tErrorCode NUMBER;
BEGIN
    spPlayersDelete(1302, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Delete Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE(' No Data Found');
    ELSIF tErrorCode = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Deleted');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;

-- delete a non-existing player
DECLARE
    tErrorCode NUMBER;
BEGIN
    spPlayersDelete(999, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Delete Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Deleted');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;

--SELECT
CREATE OR REPLACE PROCEDURE spPlayersSelect (
    p_playerid IN OUT players.playerid%TYPE,
    p_regnumber OUT players.regnumber%TYPE,
    p_lname OUT players.lastname%TYPE,
    p_fname OUT players.firstname%TYPE,
    p_isactive OUT players.isactive%TYPE,
    p_errorCode OUT NUMBER
) AS
BEGIN
    p_errorCode := 0;
   SELECT 
        regnumber, 
        lastname, 
        firstname, 
        isactive
   INTO 
        p_regnumber, 
        p_lname, 
        p_fname, 
        p_isactive
   FROM players
   WHERE playerid = p_playerid;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_errorCode := -1;
    WHEN TOO_MANY_ROWS THEN
        p_errorCode := -3;
    WHEN OTHERS THEN
        p_errorCode := -10;
END spPlayersSelect;

--**** test ****
--Select an existing player
DECLARE
    tPlayerID players.playerid%TYPE := 1302;
    tRegNumber players.regnumber%TYPE;
    tLastName players.lastname%TYPE;
    tFirstName players.firstname%TYPE;
    tIsActive players.isactive%TYPE;
    tErrorCode NUMBER;
BEGIN
    spPlayersSelect(tPlayerID, tRegNumber, tLastName, tFirstName, tIsActive, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Select Successful');
        DBMS_OUTPUT.PUT_LINE(
            'Player ID: ' || tPlayerID || 
            ', RegNumber: ' || tRegNumber || 
            ', LastName: ' || tLastName || 
            ', FirstName: ' || tFirstName || 
            ', IsActive: ' || tIsActive
        );
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Returned');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
--select a non-existing player
DECLARE
    tPlayerID players.playerid%TYPE := 999;
    tRegNumber players.regnumber%TYPE;
    tLastName players.lastname%TYPE;
    tFirstName players.firstname%TYPE;
    tIsActive players.isactive%TYPE;
    tErrorCode NUMBER;
BEGIN
    spPlayersSelect(tPlayerID, tRegNumber, tLastName, tFirstName, tIsActive, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Select Successful');
        DBMS_OUTPUT.PUT_LINE(
            'Player ID: ' || tPlayerID || 
            ', RegNumber: ' || tRegNumber || 
            ', LastName: ' || tLastName || 
            ', FirstName: ' || tFirstName || 
            ', IsActive: ' || tIsActive
        );
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Returned');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;

-- **********Teams Table*************
--INSERT
CREATE OR REPLACE PROCEDURE spTeamsInsert(
    p_teamid IN teams.teamid%TYPE,
    p_name IN teams.teamname%TYPE,
    p_active IN teams.isactive%TYPE,
    p_jcolour IN teams.jerseycolour%TYPE,
    p_errorCode OUT NUMBER
) AS
BEGIN
    p_errorCode := 0;
    INSERT INTO teams (
        teamid,
        teamname,
        isactive,
        jerseycolour
        )
        VALUES (
            p_teamid,
            p_name,
            p_active,
            p_jcolour
        );
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_errorCode := -2;
    WHEN OTHERS THEN
        p_errorCode := -10;
END spTeamsInsert;
--**** test ****
-- 1-Correct id
DECLARE
    tError NUMBER;
BEGIN
    spTeamsInsert(1, 'Manchester', 0, 'Red', tError);
    IF tError = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Insert Successful');
    ELSIF tError = -2 THEN
        DBMS_OUTPUT.PUT_LINE('Duplicate Value for the the team ID');
    ELSIF tError = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
--2-Duplicate teamid
DECLARE
    tError NUMBER;
BEGIN
    spTeamsInsert(400, 'Chelsea', 0, 'Blue', tError);
    IF tError = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Insert Successful');
    ELSIF tError = -2 THEN
        DBMS_OUTPUT.PUT_LINE('Duplicate Value for the the team ID');
    ELSIF tError = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
--3-violates a constraint
DECLARE
    tError NUMBER;
BEGIN
    spTeamsInsert(NULL, 'Chelsea', 0, 'Blue', tError);
    IF tError = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Insert Successful');
    ELSIF tError = -2 THEN
        DBMS_OUTPUT.PUT_LINE('Duplicate Value for the the team ID');
    ELSIF tError = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
--UPDATE
CREATE OR REPLACE PROCEDURE spTeamsUpdate (
    p_teamid IN teams.teamid%TYPE,
    p_name IN teams.teamname%TYPE,
    p_active IN teams.isactive%TYPE,
    p_jcolour IN teams.jerseycolour%TYPE,
    p_errorCode OUT NUMBER
) AS
BEGIN
    p_errorCode := 0;
   UPDATE teams
   SET teamname = p_name,
       isactive = p_active,
       jerseycolour = p_jcolour
   WHERE teamid = p_teamid;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_errorCode := -1;
    WHEN OTHERS THEN
        p_errorCode := -10;
END spTeamsUpdate;
--**** test ****
--Update existing team
DECLARE
    tErrorCode NUMBER;
BEGIN
    spTeamsUpdate(210,'Rangers', 0, 'Red', tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Update Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
--update a non-existing team
DECLARE
    tErrorCode NUMBER;
BEGIN
    spTeamsUpdate(500, 'Rangers', 0, 'Red', tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Update Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
-- violates a constraint
DECLARE
    tErrorCode NUMBER;
BEGIN
    spTeamsUpdate(null, 'Rangers', 0, 'Red', tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Update Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
--DELETE
CREATE OR REPLACE PROCEDURE spTeamsDelete (
   p_teamid IN teams.teamid%TYPE,
   p_errorCode OUT NUMBER
) AS
BEGIN
    p_errorCode := 0;
   DELETE FROM teams WHERE teamid = p_teamid;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_errorCode := -1;
    WHEN TOO_MANY_ROWS THEN
        p_errorCode := -3;
    WHEN OTHERS THEN
        p_errorCode := -10;
END spTeamsDelete;
--**** test ****
-- Delete an existing team
DECLARE
    tErrorCode NUMBER;
BEGIN
    spTeamsDelete(210, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Delete Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE(' No Data Found');
    ELSIF tErrorCode = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Deleted');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
-- delete a non-existing team
DECLARE
    tErrorCode NUMBER;
BEGIN
    spTeamsDelete(500, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Delete Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Deleted');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
--SELECT
CREATE OR REPLACE PROCEDURE spTeamsSelect (
    p_teamid IN OUT teams.teamid%TYPE,
    p_name OUT teams.teamname%TYPE,
    p_active OUT teams.isactive%TYPE,
    p_jcolour OUT teams.jerseycolour%TYPE,
    p_errorCode OUT NUMBER
) AS
BEGIN
    p_errorCode := 0;
   SELECT teamname, isactive, jerseycolour
   INTO p_name, p_active, p_jcolour
   FROM teams
   WHERE teamid = p_teamid;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_errorCode := -1;
    WHEN TOO_MANY_ROWS THEN
        p_errorCode := -3;
    WHEN OTHERS THEN
        p_errorCode := -10;
END spTeamsSelect;
--Select an existing team
DECLARE
    tTeamID teams.teamid%TYPE := 210;
    tName teams.teamname%TYPE;
    tActive teams.isactive%TYPE;
    tJColour teams.jerseycolour%TYPE;
    tErrorCode NUMBER;
BEGIN
    spTeamsSelect(tTeamID, tName, tActive, tJColour, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Select Successful');
        DBMS_OUTPUT.PUT_LINE(
            'Team ID: ' || tTeamID || 
            ', Name: ' || tName || 
            ', IsActive: ' || tActive || 
            ', Jersey Colour: ' || tJColour
        );
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Returned');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;

--select a non-existing team
DECLARE
    tTeamID teams.teamid%TYPE := 999;
    tName teams.teamname%TYPE;
    tActive teams.isactive%TYPE;
    tJColour teams.jerseycolour%TYPE;
    tErrorCode NUMBER;
BEGIN
    spTeamsSelect(tTeamID, tName, tActive, tJColour, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Select Successful');
        DBMS_OUTPUT.PUT_LINE(
            'Team ID: ' || tTeamID || 
            ', Name: ' || tName || 
            ', IsActive: ' || tActive || 
            ', Jersey Colour: ' || tJColour
        );
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Returned');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;

-- **********Rosters Table*************
--INSERT
CREATE OR REPLACE PROCEDURE spRostersInsert (
    p_rosterid IN OUT rosters.rosterid%TYPE,
    p_playerid IN rosters.playerid%TYPE,
    p_teamid IN rosters.teamid%TYPE,
    p_isactive IN rosters.isactive%TYPE,
    p_jerseynumber IN rosters.jerseynumber%TYPE,
    p_errorCode OUT NUMBER
) AS
playerExist NUMBER;
teamExist NUMBER;
BEGIN
    p_errorCode := 0;
    -- check if playerid not exist
    SELECT COUNT(*)
    INTO playerExist
    FROM players
    WHERE playerid = p_playerid;
    -- check if teamid not exist
    SELECT COUNT(*)
    INTO teamExist
    FROM teams
    WHERE teamid = p_teamid;
    IF playerExist = 0 OR teamExist = 0 THEN
        p_errorCode := -4;
        RETURN;
    END IF;
    -- ROSTERID GENERATED BY DEAULT ON NULL
    INSERT INTO rosters(rosterid, playerid, teamid, isactive,jerseynumber)
    VALUES (p_rosterid, p_playerid, p_teamid, p_isactive,p_jerseynumber) 
    RETURNING rosterid INTO p_rosterid; -- RETURN NEW AUTOMATICALLY GENERATED ID TO OUT NUMBER1
EXCEPTION
    WHEN OTHERS THEN
        p_errorCode := -10;
END spRostersInsert;
--**** test ****
-- 1-Correct player and team id
DECLARE
    tRosterid NUMBER := null;
    tError NUMBER;
BEGIN
    spRostersInsert(tRosterid, 1302, 400, 0, 15, tError);
    IF tError = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Insert Successful, ROSTERID: ' || tRosterid);
    ELSIF tError = -4 THEN
        DBMS_OUTPUT.PUT_LINE('player id or team id not found');
    ELSIF tError = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;

--2-non existing playerid or teamid
DECLARE
    tRosterid NUMBER := null;
    tError NUMBER;
BEGIN
    spRostersInsert(tRosterid, 50, 42, 0, 15, tError);
    IF tError = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Insert Successful');
    ELSIF tError = -2 THEN
        DBMS_OUTPUT.PUT_LINE('player id or team id not found');
    ELSIF tError = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;

--UPDATE
CREATE OR REPLACE PROCEDURE spRostersUpdate (
    p_rosterid IN rosters.rosterid%TYPE,
    p_playerid IN rosters.playerid%TYPE,
    p_teamid IN rosters.teamid%TYPE,
    p_isactive IN rosters.isactive%TYPE,
    p_jnum IN rosters.jerseynumber%TYPE,
    p_errorCode OUT NUMBER
) AS
BEGIN
    p_errorCode := 0;
   UPDATE rosters
   SET  playerid = p_playerid,
        teamid = p_teamid,
        isactive = p_isactive,
        jerseynumber = p_jnum
   WHERE rosterid = p_rosterid;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_errorCode := -1;
    WHEN OTHERS THEN
        p_errorCode := -10;
END spRostersUpdate;

--**** test ****
--Update existing roster
DECLARE
    tErrorCode NUMBER;
BEGIN
    spRostersUpdate(1,1302, 210, 0, 44, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Update Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
--update a non-existing roster
DECLARE
    tErrorCode NUMBER;
BEGIN
    spRostersUpdate(240, 22, 20, 0, 44, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Update Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
-- violates a constraint
DECLARE
    tErrorCode NUMBER;
BEGIN
    spRostersUpdate(null, 22, 20, 0, 44, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Update Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
--DELETE
CREATE OR REPLACE PROCEDURE spRostersDelete (
   p_rosterid IN rosters.rosterid%TYPE,
   p_errorCode OUT NUMBER
) AS
BEGIN
    p_errorCode := 0;
   DELETE FROM rosters WHERE rosterid = p_rosterid;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_errorCode := -1;
    WHEN TOO_MANY_ROWS THEN
        p_errorCode := -3;
    WHEN OTHERS THEN
        p_errorCode := -10;
END spRostersDelete;
--**** test ****
-- Delete an existing roster
DECLARE
    tErrorCode NUMBER;
BEGIN
    spRostersDelete(1, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Delete Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE(' No Data Found');
    ELSIF tErrorCode = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Deleted');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
-- delete a non-existing roster
DECLARE
    tErrorCode NUMBER;
BEGIN
    spRostersDelete(240, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Delete Successful');
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Deleted');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;
--SELECT
CREATE OR REPLACE PROCEDURE spRostersSelect (
    p_rosterid IN OUT rosters.rosterid%TYPE,
    p_playerid OUT rosters.playerid%TYPE,
    p_teamid OUT rosters.teamid%TYPE,
    p_isactive OUT rosters.isactive%TYPE,
    p_jnum OUT rosters.jerseynumber%TYPE,
    p_errorCode OUT NUMBER
) AS
BEGIN
    p_errorCode := 0;
   SELECT 
        playerid, 
        teamid, 
        isactive, 
        jerseynumber
   INTO 
        p_playerid, 
        p_teamid, 
        p_isactive, 
        p_jnum
   FROM rosters
   WHERE rosterid = p_rosterid;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_errorCode := -1;
    WHEN TOO_MANY_ROWS THEN
        p_errorCode := -3;
    WHEN OTHERS THEN
        p_errorCode := -10;
END spRostersSelect;

--**** test ****
--Select an existing roster
DECLARE
    tRosterID rosters.rosterid%TYPE := 1;
    tPlayerID rosters.playerid%TYPE;
    tTeamID rosters.teamid%TYPE;
    tIsActive rosters.isactive%TYPE;
    tJNum rosters.jerseynumber%TYPE;
    tErrorCode NUMBER;
BEGIN
    spRostersSelect(tRosterID, tPlayerID, tTeamID, tIsActive, tJNum, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Select Successful');
        DBMS_OUTPUT.PUT_LINE(
            'Roster ID: ' || tRosterID || 
            ', Player ID: ' || tPlayerID || 
            ', Team ID: ' || tTeamID || 
            ', IsActive: ' || tIsActive || 
            ', Jersey Number: ' || tJNum
        );
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Returned');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;

--select a non-existing roster
DECLARE
    tRosterID rosters.rosterid%TYPE := 999;
    tPlayerID rosters.playerid%TYPE;
    tTeamID rosters.teamid%TYPE;
    tIsActive rosters.isactive%TYPE;
    tJNum rosters.jerseynumber%TYPE;
    tErrorCode NUMBER;
BEGIN
    spRostersSelect(tRosterID, tPlayerID, tTeamID, tIsActive, tJNum, tErrorCode);
    IF tErrorCode = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Select Successful');
        DBMS_OUTPUT.PUT_LINE(
            'Roster ID: ' || tRosterID || 
            ', Player ID: ' || tPlayerID || 
            ', Team ID: ' || tTeamID || 
            ', IsActive: ' || tIsActive || 
            ', Jersey Number: ' || tJNum
        );
    ELSIF tErrorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No Data Found');
    ELSIF tErrorCode = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Returned');
    ELSIF tErrorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
END;

-- Q2 -> For each table in (Players, Teams, Rosters), create an additional Stored Procedure that outputs the contents of the table to the script window 

-- Q2 SOLUTION --
-- **********Players Table*************
CREATE OR REPLACE PROCEDURE spPlayersSelectAll AS
BEGIN
    FOR player_rec IN (SELECT * FROM Players) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Player ID: ' || player_rec.playerid || 
            ', RegNumber: ' || player_rec.regnumber || 
            ', LastName: ' || player_rec.lastname || 
            ', FirstName: ' || player_rec.firstname || 
            ', IsActive: ' || player_rec.isactive
        );
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found in the Players table.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
END spPlayersSelectAll;
--**** test ****
BEGIN
    spPlayersSelectAll;
END;
-- ********** Teams Table *************
CREATE OR REPLACE PROCEDURE spTeamsSelectAll AS
BEGIN
    FOR team_rec IN (SELECT * FROM Teams) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Team ID: ' || team_rec.teamid || 
            ', TeamName: ' || team_rec.teamname || 
            ', IsActive: ' || team_rec.isactive || 
            ', JerseyColour: ' || team_rec.jerseycolour
        );
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found in the Teams table.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
END spTeamsSelectAll;
--**** test ****
BEGIN
    spTeamsSelectAll;
END;
-- **********Rosters Table*************
CREATE OR REPLACE PROCEDURE spRostersSelectAll AS
BEGIN
    FOR roster_rec IN (SELECT * FROM Rosters) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Roster ID: ' || roster_rec.rosterid || 
            ', Player ID: ' || roster_rec.playerid || 
            ', Team ID: ' || roster_rec.teamid || 
            ', IsActive: ' || roster_rec.isactive || 
            ', JerseyNumber: ' || roster_rec.jerseynumber
        );
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found in the Rosters table.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
END spRostersSelectAll;
--**** test ****
BEGIN
    spRostersSelectAll;
END;

-- Q3 -> Repeat Step 2 but returning the table in the output of the SP.  Use a non-saved procedure to show receiving the data and outputting it to the script window.  

-- Q3 SOLUTION --
-- **********Players Table*************
CREATE OR REPLACE FUNCTION fnPlayersSelectAll RETURN SYS_REFCURSOR AS
    players_cursor SYS_REFCURSOR; -- using SYS_REFCURSOR as the return type to return a cursor in a function or procedure
BEGIN
    OPEN players_cursor FOR
        SELECT * FROM Players;

    RETURN players_cursor; -- the cursor is implicitly closed when the function completes
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found.'); --no return needed
    WHEN OTHERS THEN
        IF players_cursor IS NOT NULL THEN
            CLOSE players_cursor; -- just for safety, otherwise, it gets closed automatically
        END IF;
        DBMS_OUTPUT.PUT_LINE('An error occurred');
        RETURN NULL; -- return NULL not -10 due to the return type
END fnPlayersSelectAll;
--**** test ****
DECLARE
    player_rec Players%ROWTYPE;
    players_cursor SYS_REFCURSOR; -- declaring the cursor here
BEGIN
    players_cursor := fnPlayersSelectAll;
    LOOP
        BEGIN
            FETCH players_cursor INTO player_rec;
            EXIT WHEN players_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(
                'Player ID: ' || player_rec.playerid || 
                ', RegNumber: ' || player_rec.regnumber || 
                ', LastName: ' || player_rec.lastname || 
                ', FirstName: ' || player_rec.firstname || 
                ', IsActive: ' || player_rec.isactive
            );
        -- if something happens during fetching the data
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('An error occurred while fetching');
        END;
    END LOOP;

    IF players_cursor IS NOT NULL THEN --check if it is still open
        CLOSE players_cursor;
    END IF;
END;
-- ********** Teams Table *************
CREATE OR REPLACE FUNCTION fnTeamsSelectAll RETURN SYS_REFCURSOR AS
    teams_cursor SYS_REFCURSOR;
BEGIN
    OPEN teams_cursor FOR
        SELECT * FROM Teams;

    RETURN teams_cursor; -- the cursor is implicitly closed when the function completes
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found.'); -- no return needed
    WHEN OTHERS THEN
        IF teams_cursor IS NOT NULL THEN
            CLOSE teams_cursor; -- just for safety, otherwise, it gets closed automatically
        END IF;
        DBMS_OUTPUT.PUT_LINE('An error occurred');
        RETURN NULL; -- return NULL not -10 due to the return type
END fnTeamsSelectAll;

--**** test ****
DECLARE
    team_rec Teams%ROWTYPE;
    teams_cursor SYS_REFCURSOR; -- declaring the cursor here
BEGIN
    teams_cursor := fnTeamsSelectAll;
    LOOP
        BEGIN
            FETCH teams_cursor INTO team_rec;
            EXIT WHEN teams_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(
                'Team ID: ' || team_rec.teamid || 
                ', TeamName: ' || team_rec.teamname || 
                ', IsActive: ' || team_rec.isactive || 
                ', JerseyColour: ' || team_rec.jerseycolour
            );
        -- if something happens during fetching the data
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('An error occurred while fetching');
        END;
    END LOOP;

    IF teams_cursor IS NOT NULL THEN -- check if it is still open
        CLOSE teams_cursor;
    END IF;
END;
-- **********Rosters Table*************
CREATE OR REPLACE FUNCTION fnRostersSelectAll RETURN SYS_REFCURSOR AS
    rosters_cursor SYS_REFCURSOR;
BEGIN
    OPEN rosters_cursor FOR
        SELECT * FROM Rosters;

    RETURN rosters_cursor; -- the cursor is implicitly closed when the function completes
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found.'); -- no return needed
    WHEN OTHERS THEN
        IF rosters_cursor IS NOT NULL THEN
            CLOSE rosters_cursor; -- just for safety, otherwise, it gets closed automatically
        END IF;
        DBMS_OUTPUT.PUT_LINE('An error occurred');
        RETURN NULL; -- return NULL not -10 due to the return type
END fnRostersSelectAll;

--**** test ****
DECLARE
    roster_rec Rosters%ROWTYPE;
    rosters_cursor SYS_REFCURSOR; -- declaring the cursor here
BEGIN
    rosters_cursor := fnRostersSelectAll;

    LOOP
        BEGIN
            FETCH rosters_cursor INTO roster_rec;
            EXIT WHEN rosters_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(
                'Roster ID: ' || roster_rec.rosterid || 
                ', Player ID: ' || roster_rec.playerid || 
                ', Team ID: ' || roster_rec.teamid || 
                ', IsActive: ' || roster_rec.isactive || 
                ', JerseyNumber: ' || roster_rec.jerseynumber
            );
        -- if something happens during fetching the data
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('An error occurred while fetching');
        END;
    END LOOP;

    IF rosters_cursor IS NOT NULL THEN -- check if it is still open
        CLOSE rosters_cursor;
    END IF;
END;

-- Q4 -> Create a view which stores the “players on teams” information, called vwPlayerRosters which includes all fields from players, rosters, and teams in a single output table.

-- Q4 SOLUTION --
CREATE OR REPLACE VIEW vwPlayerRosters AS
SELECT
    p.playerid,
    p.regnumber,
    p.lastname,
    p.firstname,
    p.isactive AS player_isactive,
    r.rosterid,
    r.teamid,
    r.isactive AS roster_isactive,
    r.jerseynumber,
    t.teamname,
    t.isactive AS team_isactive,
    t.jerseycolour
FROM players p
JOIN rosters r ON p.playerid = r.playerid
JOIN teams t ON r.teamid = t.teamid;
--**** test ****
SELECT * FROM vwPlayerRosters;

-- Q5 -> Using the vwPlayerRosters view, create an SP, named spTeamRosterByID, that outputs, the team rosters, with names, for a team given a specific input parameter of teamID

-- Q5 SOLUTION --
CREATE OR REPLACE PROCEDURE spTeamRosterByID (
    p_teamID IN teams.teamid%TYPE,
    isCursor OUT SYS_REFCURSOR,
    p_errorCode OUT NUMBER
) AS
BEGIN
    p_errorCode := 0;
    OPEN isCursor FOR
        SELECT * FROM vwPlayerRosters WHERE teamid = p_teamID;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_errorCode := -1;
    WHEN INVALID_CURSOR THEN
        p_errorCode := -5;
    WHEN OTHERS THEN
        p_errorCode := -10;
END spTeamRosterByID;
--**** test ****
DECLARE
    isCursor SYS_REFCURSOR;
    t_errorCode NUMBER;
    team_roster vwPlayerRosters%ROWTYPE;
BEGIN
    spTeamRosterByID(210, isCursor, t_errorCode);
    IF t_errorCode = 0 THEN
        LOOP
            FETCH isCursor INTO team_roster;
            EXIT WHEN isCursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Player ID: ' || team_roster.playerid ||
                ', Last Name: ' || team_roster.lastname ||
                ', First Name: ' || team_roster.firstname ||
                ', Jersey Number: ' || team_roster.jerseynumber);
        END LOOP;
    ELSIF t_errorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE(' No Data Found');
    ELSIF t_errorCode = -5 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Cursor');
    ELSIF t_errorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
    CLOSE isCursor;
END;

-- Q6 -> 6.	Repeat task 4, by creating another similar stored procedure that receives a string parameter and returns the team roster, with names, for a team found through a search string.  The entered parameter may be any part of the name.

-- Q6 SOLUTION --
CREATE OR REPLACE PROCEDURE spTeamRosterByName (
    p_teamName IN teams.teamname%TYPE,
    isCursor OUT SYS_REFCURSOR,
    p_errorCode OUT NUMBER
) AS
BEGIN
    p_errorCode := 0;
    OPEN isCursor FOR
        SELECT * FROM vwPlayerRosters WHERE UPPER(teamname) LIKE UPPER('%' || p_teamName || '%');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_errorCode := -1;
    WHEN INVALID_CURSOR THEN
        p_errorCode := -5;
    WHEN OTHERS THEN
        p_errorCode := -10;
END spTeamRosterByName;
--**** test ****
DECLARE
    isCursor SYS_REFCURSOR;
    t_errorCode NUMBER;
    team_roster vwPlayerRosters%ROWTYPE;
BEGIN
    spTeamRosterByName('bos', isCursor, t_errorCode);
    IF t_errorCode = 0 THEN
        LOOP
            FETCH isCursor INTO team_roster;
            EXIT WHEN isCursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(
                'Team ID: ' || team_roster.teamid ||
                ', Player ID: ' || team_roster.playerid ||
                ', Last Name: ' || team_roster.lastname ||
                ', First Name: ' || team_roster.firstname ||
                ', Jersey Number: ' || team_roster.jerseynumber
            );
        END LOOP;
    ELSIF t_errorCode = -1 THEN
        DBMS_OUTPUT.PUT_LINE(' No Data Found');
    ELSIF t_errorCode = -5 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Cursor');
    ELSIF t_errorCode = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    END IF;
    CLOSE isCursor;
END;

-- Q7 -> Create a view that returns the number of players currently registered on each team.

-- Q7 SOLUTION --
CREATE OR REPLACE VIEW vwTeamsNumPlayers AS
SELECT 
    t.teamid,
    teamname,
    COUNT(r.playerid) AS NumOfRegistered --no need for NVL, NULL will show up as 0
FROM teams t
LEFT JOIN rosters r ON r.teamid = t.teamid --to get the teams even wo any players in it
GROUP BY 
    t.teamid,
    teamname;
--**** test ****
SELECT * FROM vwTeamsNumPlayers;

-- Q8 -> Using vwTeamsNumPlayers create a user defined function, that given the team PK, will return the number of players currently registered, 

-- Q8 SOLUTION --
CREATE OR REPLACE FUNCTION fncNumPlayersByTeamID(
    p_teamid IN teams.teamid%TYPE
) RETURN NUMBER IS
    
    numPlayers NUMBER;
BEGIN
    SELECT NumOfRegistered INTO numPlayers 
    FROM vwTeamsNumPlayers
    WHERE teamid = p_teamid;
    
    RETURN numPlayers;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;
    WHEN TOO_MANY_ROWS THEN
        RETURN -3;
    WHEN OTHERS THEN
        RETURN -10; 
END fncNumPlayersByTeamID;
--**** test ****
-- with existing teamid
DECLARE
    regNum NUMBER;
BEGIN
    regNum := fncNumPlayersByTeamID(222); -- existing team
    IF regNum = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No data found for the specified team search.');
    ELSIF regNum = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Returned');
    ELSIF regNum = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Number of Players Registerd: ' || regNum);
    END IF;
END;
-- with non existing teamid
DECLARE
    regNum NUMBER;
BEGIN
    regNum := fncNumPlayersByTeamID(450); -- non existing team
    IF regNum = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No data found for the specified team search.');
    ELSIF regNum = -3 THEN
        DBMS_OUTPUT.PUT_LINE('Too Many Rows Returned');
    ELSIF regNum = -10 THEN
        DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occurred');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Number of Players Registerd: ' || regNum);
    END IF;
END;

-- Q9 -> Create a view that shows all games, but includes the written names for teams and locations, in addition to the PK/FK values.  Do not worry about division here.

-- Q9 SOLUTION --
CREATE OR REPLACE VIEW vwSchedule AS
SELECT
    g.gameid,
    g.gamenum,
    g.gamedatetime,
    g.hometeam,
    ht.teamname AS hometeamname,
    g.homescore,
    g.visitteam,
    vt.teamname AS visitteamname,
    g.visitscore,
    g.locationid,
    l.locationname,
    g.isplayed
FROM
    games g
JOIN
    teams ht ON g.hometeam = ht.teamid
JOIN
    teams vt ON g.visitteam = vt.teamid
JOIN
    sllocations l ON g.locationid = l.locationid;
--**** test ****
SELECT * FROM vwSchedule;

-- Q10 -> 10.	Create a stored procedure, spSchedUpcomingGames, using DBMS_OUTPUT, that displays the games to be played in the next n days, where n is an input parameter.  Make sure your code will work on any day of the year.

-- Q10 SOLUTION --
CREATE OR REPLACE PROCEDURE spSchedUpcomingGames (
    p_days IN NUMBER
) AS
BEGIN
    FOR i IN (
        SELECT
            g.gameid,
            g.gamenum,
            g.gamedatetime,
            g.hometeam AS hometeam,
            g.hometeamname AS hometeamname, --using aliases from view
            g.visitteam AS visitteam,
            g.visitteamname AS visitteamname,
            g.locationname
        FROM
            vwSchedule g
        WHERE
            g.gamedatetime BETWEEN SYSDATE AND SYSDATE + p_days
            AND g.isplayed = 0
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Game ID: ' || i.gameid ||
            ', Game Number: ' || i.gamenum ||
            ', Date: ' || TO_CHAR(i.gamedatetime, 'DD-MON-YYYY') ||
            ', Home Team: ' || i.hometeam ||
            ', hometeam Name: ' || i.hometeamname ||
            ', Visit Team: ' || i.visitteam ||
            ', visitteam Name: ' || i.visitteamname ||
            ', Location: ' || i.locationname
        );
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No upcoming games found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
END spSchedUpcomingGames;

--**** test ****
DECLARE
    v_days NUMBER := 7;
BEGIN
    spSchedUpcomingGames(v_days);
END;

-- Q11 -> Create a stored procedure that displays the games that have been played in the past n days, where n is an input parameter.  Make sure your code will work on any day of the year.

-- Q11 SOLUTION --
CREATE OR REPLACE PROCEDURE spSchedPastGames (
    p_days IN NUMBER
) AS
BEGIN
    FOR i IN (
        SELECT
            g.gameid,
            g.gamenum,
            g.gamedatetime,
            g.hometeam AS hometeam,
            g.hometeamname AS hometeamname,
            g.visitteam AS visitteam,
            g.visitteamname AS visitteamname,
            g.locationname
        FROM
            vwSchedule g
        WHERE
            g.gamedatetime BETWEEN SYSDATE - p_days AND SYSDATE
            AND g.isplayed = 1
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Game ID: ' || i.gameid ||
            ', Game Number: ' || i.gamenum ||
            ', Date: ' || TO_CHAR(i.gamedatetime, 'DD-MON-YYYY') ||
            ', Home Team: ' || i.hometeam ||
            ', hometeam Name: ' || i.hometeamname ||
            ', Visit Team: ' || i.visitteam ||
            ', visitteam Name: ' || i.visitteamname ||
            ', Location: ' || i.locationname
        );
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No past games found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
END spSchedPastGames;
--**** test ****
DECLARE
    v_days NUMBER := 300;
BEGIN
    spSchedPastGames(v_days);
END;

-- Q12 -> create a Stored Procedure that replaces a temporary static table, named tempStandings, with the output of the SELECT code provided. 

-- Q12 SOLUTION --
CREATE TABLE tempstandings AS (
    SELECT
        TheTeamID,
        (SELECT teamname FROM teams WHERE teamid = t.TheTeamID) AS teamname,
        SUM(GamesPlayed) AS GP,
        SUM(Wins) AS W,
        SUM(Losses) AS L,
        SUM(Ties) AS T,
        SUM(Wins) * 3 + SUM(Ties) AS Pts,
        SUM(GoalsFor) AS GF,
        SUM(GoalsAgainst) AS GA,
        SUM(GoalsFor) - SUM(GoalsAgainst) AS GD
    FROM (
        SELECT
            hometeam AS TheTeamID,
            COUNT(gameID) AS GamesPlayed,
            SUM(homescore) AS GoalsFor,
            SUM(visitscore) AS GoalsAgainst,
            SUM(
                CASE
                    WHEN homescore > visitscore THEN 1
                    ELSE 0
                    END) AS Wins,
            SUM(
                CASE
                    WHEN homescore < visitscore THEN 1
                    ELSE 0
                    END) AS Losses,
            SUM(
                CASE
                    WHEN homescore = visitscore THEN 1
                    ELSE 0
                    END) AS Ties
        FROM games
        WHERE isPlayed = 1
        GROUP BY hometeam
        
        UNION ALL
        -- perspective of the visiting team     
        SELECT
            visitteam AS TheTeamID,
            COUNT(gameID) AS GamesPlayed,
            SUM(visitscore) AS GoalsFor,
            SUM(homescore) AS GoalsAgainst,
            SUM(
                CASE
                    WHEN homescore < visitscore THEN 1
                    ELSE 0
                    END) AS Wins,
            SUM(
                CASE
                    WHEN homescore > visitscore THEN 1
                    ELSE 0
                    END) AS Losses,
            SUM(
                CASE
                    WHEN homescore = visitscore THEN 1
                    ELSE 0
                    END) AS Ties
        FROM games
        WHERE isPlayed = 1
        GROUP BY visitteam) t
    GROUP BY TheTeamID
   );
--**** test ****
SELECT * FROM tempstandings;

-- Q13 -> 13.	Following up with Step 12, create a Trigger in the system to automate the execution of the spRunStandings SP when any row in the games table is updated.  Essentially meaning that software can run SELECT * FROM tempStandings; and always have up to date standings.

-- Q13 SOLUTION --
CREATE OR REPLACE TRIGGER trgUpdateStandings
AFTER INSERT OR UPDATE OF homescore,isPlayed,visitScore ON games 
BEGIN
    DELETE FROM tempStandings;

    INSERT INTO tempStandings (
    SELECT 
        TheTeamID,
        (SELECT teamname FROM teams WHERE teamid = t.TheTeamID) AS teamname,
        SUM(GamesPlayed) AS GP,
        SUM(Wins) AS W,
        SUM(Losses) AS L,
        SUM(Ties) AS T,
        SUM(Wins)*3 + SUM(Ties) AS Pts,
        SUM(GoalsFor) AS GF,
        SUM(GoalsAgainst) AS GA,
        SUM(GoalsFor) - SUM(GoalsAgainst) AS GD
    FROM (
    -- from the home team perspective
        SELECT
            hometeam AS TheTeamID,
            COUNT(gameID) AS GamesPlayed,
            SUM(homescore) AS GoalsFor,
            SUM(visitscore) AS GoalsAgainst,
            SUM(
                CASE
                    WHEN homescore > visitscore THEN 1
                    ELSE 0
                    END
                ) As Wins, 
            SUM(
                CASE
                    WHEN homescore < visitscore THEN 1
                    ELSE 0
                    END
                ) As Losses,
            SUM(
                CASE
                    WHEN homescore = visitscore THEN 1
                    ELSE 0
                    END
                ) As Ties    
        FROM games
        WHERE isPlayed = 1
        GROUP BY hometeam
        
        UNION ALL
        -- from the perspective of the visiting team
        SELECT
            visitteam AS TheTeamID,
            COUNT(gameID) AS GamesPlayed,
            SUM(visitscore) AS GoalsFor,
            SUM(homescore) AS GoalsAgainst,
            SUM(
                CASE
                    WHEN homescore < visitscore THEN 1
                    ELSE 0
                    END
                ) As Wins, 
            SUM(
                CASE
                    WHEN homescore > visitscore THEN 1
                    ELSE 0
                    END
                ) As Losses,
            SUM(
                CASE
                    WHEN homescore = visitscore THEN 1
                    ELSE 0
                    END
                ) As Ties    
        FROM games
        WHERE isPlayed = 1
        GROUP BY visitteam ) t
    GROUP BY TheTeamID
    );
END;






