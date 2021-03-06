-- -*-Sql-*- mode (to keep my emacs happy)
--
-- API Package Body for Bioentry_Assoc.
--
-- Scaffold auto-generated by gen-api.pl. gen-api.pl is
-- Copyright 2002-2003 Genomics Institute of the Novartis Research Foundation
-- Copyright 2002-2008 Hilmar Lapp
-- 
--  This file is part of BioSQL.
--
--  BioSQL is free software: you can redistribute it and/or modify it
--  under the terms of the GNU Lesser General Public License as
--  published by the Free Software Foundation, either version 3 of the
--  License, or (at your option) any later version.
--
--  BioSQL is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Lesser General Public License for more details.
--
--  You should have received a copy of the GNU Lesser General Public License
--  along with BioSQL. If not, see <http://www.gnu.org/licenses/>.
--

CREATE OR REPLACE
PACKAGE BODY EntA IS

EntA_cached	SG_BIOENTRY_ASSOC.OID%TYPE DEFAULT NULL;
cache_key		VARCHAR2(1024) DEFAULT NULL;

CURSOR EntA_c (
		EntA_SUBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.SUBJ_ENT_OID%TYPE,
		EntA_OBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.OBJ_ENT_OID%TYPE,
		EntA_TRM_OID	IN SG_BIOENTRY_ASSOC.TRM_OID%TYPE)
RETURN SG_BIOENTRY_ASSOC%ROWTYPE IS
	SELECT t.* FROM SG_BIOENTRY_ASSOC t
	WHERE
		t.SUBJ_ENT_OID = EntA_SUBJ_ENT_OID
	AND	t.OBJ_ENT_OID = EntA_OBJ_ENT_OID
	AND	t.TRM_OID = EntA_TRM_OID
	;

FUNCTION get_oid(
		EntA_OID	IN SG_BIOENTRY_ASSOC.OID%TYPE DEFAULT NULL,
		TRM_OID	IN SG_BIOENTRY_ASSOC.TRM_OID%TYPE,
		OBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.OBJ_ENT_OID%TYPE,
		SUBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.SUBJ_ENT_OID%TYPE,
		EntA_RANK	IN SG_BIOENTRY_ASSOC.RANK%TYPE DEFAULT NULL,
		Trm_NAME	IN SG_TERM.NAME%TYPE DEFAULT NULL,
		ONT_OID	IN SG_TERM.ONT_OID%TYPE DEFAULT NULL,
		ONT_NAME	IN SG_ONTOLOGY.NAME%TYPE DEFAULT NULL,
		Trm_IDENTIFIER	IN SG_TERM.IDENTIFIER%TYPE DEFAULT NULL,
		Subj_Ent_IDENTIFIER	IN SG_BIOENTRY.IDENTIFIER%TYPE DEFAULT NULL,
		Subj_Ent_ACCESSION	IN SG_BIOENTRY.ACCESSION%TYPE DEFAULT NULL,
		Subj_DB_OID	IN SG_BIOENTRY.DB_OID%TYPE DEFAULT NULL,
		Subj_Ent_VERSION	IN SG_BIOENTRY.VERSION%TYPE DEFAULT NULL,
		Obj_Ent_IDENTIFIER	IN SG_BIOENTRY.IDENTIFIER%TYPE DEFAULT NULL,
		Obj_Ent_ACCESSION	IN SG_BIOENTRY.ACCESSION%TYPE DEFAULT NULL,
		Obj_DB_OID	IN SG_BIOENTRY.DB_OID%TYPE DEFAULT NULL,
		Obj_Ent_VERSION	IN SG_BIOENTRY.VERSION%TYPE DEFAULT NULL,
		do_DML		IN NUMBER DEFAULT BSStd.DML_NO)
RETURN SG_BIOENTRY_ASSOC.OID%TYPE
IS
	pk	SG_BIOENTRY_ASSOC.OID%TYPE DEFAULT NULL;
	EntA_row EntA_c%ROWTYPE;
	TRM_OID_	SG_TERM.OID%TYPE DEFAULT TRM_OID;
	OBJ_ENT_OID_	SG_BIOENTRY.OID%TYPE DEFAULT OBJ_ENT_OID;
	SUBJ_ENT_OID_	SG_BIOENTRY.OID%TYPE DEFAULT SUBJ_ENT_OID;
	key_str	VARCHAR2(1024) DEFAULT Trm_NAME || '|' || ONT_OID || '|' || ONT_NAME || '|' || Trm_IDENTIFIER || '|' || Subj_Ent_IDENTIFIER || '|' || Subj_Ent_ACCESSION || '|' || Subj_DB_OID || '|' || Subj_Ent_VERSION || '|' || Obj_Ent_IDENTIFIER || '|' || Obj_Ent_ACCESSION || '|' || Obj_DB_OID || '|' || Obj_Ent_VERSION;
BEGIN
	-- initialize
	IF (do_DML > BSStd.DML_NO) THEN
		pk := EntA_OID;
	END IF;
	-- look up
	IF pk IS NULL THEN
		IF (key_str = cache_key) THEN
			pk := EntA_cached;
		ELSE
			-- reset cache
			cache_key := NULL;
			EntA_cached := NULL;
                	-- look up SG_TERM
                	IF (TRM_OID_ IS NULL) THEN
                		TRM_OID_ := Trm.get_oid(
                			Trm_NAME => Trm_NAME,
                			ONT_OID => ONT_OID,
                			ONT_NAME => ONT_NAME,
                			Trm_IDENTIFIER => Trm_IDENTIFIER);
                	END IF;
                	-- look up SG_BIOENTRY subject
                	IF (SUBJ_ENT_OID_ IS NULL) THEN
                		SUBJ_ENT_OID_ := Ent.get_oid(
                			Ent_IDENTIFIER => Subj_Ent_IDENTIFIER,
                			Ent_ACCESSION => Subj_Ent_ACCESSION,
                			DB_OID => Subj_DB_OID,
                			Ent_VERSION => Subj_Ent_VERSION);
                	END IF;
                	-- look up SG_BIOENTRY object
                	IF (OBJ_ENT_OID_ IS NULL) THEN
                		OBJ_ENT_OID_ := Ent.get_oid(
                			Ent_IDENTIFIER => Obj_Ent_IDENTIFIER,
                			Ent_ACCESSION => Obj_Ent_ACCESSION,
                			DB_OID => Obj_DB_OID,
                			Ent_VERSION => Obj_Ent_VERSION);
                	END IF;
			-- do the look up
			FOR EntA_row IN EntA_c(SUBJ_ENT_OID_, OBJ_ENT_OID_, TRM_OID_) LOOP
		        	pk := EntA_row.OID;
				-- cache result
			    	cache_key := key_str;
			    	EntA_cached := pk;
			END LOOP;
		END IF;
	END IF;
	-- insert if requested (no update)
	IF (pk IS NULL) AND 
	   ((do_DML = BSStd.DML_I) OR (do_DML = BSStd.DML_UI)) THEN
	    	-- look up foreign keys if not provided:
		-- look up SG_TERM successful?
		IF (TRM_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Trm <' || Trm_NAME || '|' || ONT_OID || '|' || ONT_NAME || '|' || Trm_IDENTIFIER || '>');
		END IF;
		-- look up SG_BIOENTRY subject successful?
		IF (SUBJ_ENT_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Ent <' || Subj_Ent_IDENTIFIER || '|' || Subj_Ent_ACCESSION || '|' || Subj_DB_OID || '|' || Subj_Ent_VERSION || '>');
		END IF;
		-- look up SG_BIOENTRY object successful?
		IF (OBJ_ENT_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Ent <' || Obj_Ent_IDENTIFIER || '|' || Obj_Ent_ACCESSION || '|' || Obj_DB_OID || '|' || Obj_Ent_VERSION || '>');
		END IF;
	    	-- insert the record and obtain the primary key
	    	pk := do_insert(
		        TRM_OID => TRM_OID_,
			OBJ_ENT_OID => OBJ_ENT_OID_,
			SUBJ_ENT_OID => SUBJ_ENT_OID_,
			RANK => EntA_RANK);
	ELSIF (do_DML = BSStd.DML_U) OR (do_DML = BSStd.DML_UI) THEN
	        -- update the record (note that not provided FKs will not
		-- be changed nor looked up)
		do_update(
			EntA_OID	=> pk,
		        EntA_TRM_OID => TRM_OID_,
			EntA_OBJ_ENT_OID => OBJ_ENT_OID_,
			EntA_SUBJ_ENT_OID => SUBJ_ENT_OID_,
			EntA_RANK => EntA_RANK);
	END IF;
	-- return the primary key
	RETURN pk;
END;

FUNCTION do_insert(
		TRM_OID	IN SG_BIOENTRY_ASSOC.TRM_OID%TYPE,
		OBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.OBJ_ENT_OID%TYPE,
		SUBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.SUBJ_ENT_OID%TYPE,
		RANK	IN SG_BIOENTRY_ASSOC.RANK%TYPE)
RETURN SG_BIOENTRY_ASSOC.OID%TYPE 
IS
	pk	SG_BIOENTRY_ASSOC.OID%TYPE;
BEGIN
	-- pre-generate the primary key value
	SELECT SG_Sequence_EntA.nextval INTO pk FROM DUAL;
	-- insert the record
	INSERT INTO SG_BIOENTRY_ASSOC (
		OID,
		TRM_OID,
		OBJ_ENT_OID,
		SUBJ_ENT_OID,
		RANK)
	VALUES (pk,
		TRM_OID,
		OBJ_ENT_OID,
		SUBJ_ENT_OID,
		RANK)
	;
	-- return the new pk value
	RETURN pk;
END;

PROCEDURE do_update(
		EntA_OID	IN SG_BIOENTRY_ASSOC.OID%TYPE,
		EntA_TRM_OID	IN SG_BIOENTRY_ASSOC.TRM_OID%TYPE,
		EntA_OBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.OBJ_ENT_OID%TYPE,
		EntA_SUBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.SUBJ_ENT_OID%TYPE,
		EntA_RANK	IN SG_BIOENTRY_ASSOC.RANK%TYPE)
IS
BEGIN
	-- update the record (and leave attributes passed as NULL untouched)
	UPDATE SG_BIOENTRY_ASSOC
	SET
		TRM_OID = NVL(EntA_TRM_OID, TRM_OID),
		OBJ_ENT_OID = NVL(EntA_OBJ_ENT_OID, OBJ_ENT_OID),
		SUBJ_ENT_OID = NVL(EntA_SUBJ_ENT_OID, SUBJ_ENT_OID),
		RANK = NVL(EntA_RANK, RANK)
	WHERE OID = EntA_OID
	;
END;

FUNCTION Platonic_Ent(Ent_Oid IN SG_Bioentry.Oid%TYPE)
RETURN SG_Bioentry.Oid%TYPE
IS
	CURSOR Ancestor_c (Ent_Oid IN SG_Bioentry.Oid%TYPE) IS
		SELECT Subj_Ent_Oid, Level
		FROM SG_Bioentry_Assoc
		START WITH Obj_Ent_Oid = Ent_Oid
		CONNECT BY PRIOR Subj_Ent_Oid = Obj_Ent_Oid
	;
	-- default is there is no parent
	Parent_Oid SG_Bioentry.Oid%TYPE DEFAULT Ent_Oid;
	lvl        INTEGER DEFAULT 0;
BEGIN
	-- if there is a hierarchy of parents, get the last (highest) one
	FOR parent_r IN Ancestor_c (Ent_Oid)
	LOOP
		IF parent_r.Level > lvl THEN 
		   Parent_Oid := parent_r.Subj_Ent_Oid;
		   lvl := parent_r.Level;
		END IF;
	END LOOP;
	RETURN Parent_Oid;
END;

FUNCTION Ent_Descendants(
			Ent_Oid		IN SG_Bioentry.Oid%TYPE,
		 	Trm_Oid		IN SG_Term.Oid%TYPE DEFAULT NULL,
			Trm_Name	IN SG_Term.Name%TYPE DEFAULT NULL,
			Trm_Identifier IN SG_Term.Identifier%TYPE DEFAULT NULL,
			Ont_Oid		IN SG_Ontology.Oid%TYPE DEFAULT NULL,
			Ont_Name	IN SG_Ontology.Name%TYPE DEFAULT NULL)
RETURN Oid_List_t
IS
	CURSOR Descendant_c (EntA_Ent_Oid IN SG_Bioentry.Oid%TYPE,
	       		     EntA_Trm_Oid IN SG_Term.Oid%TYPE)
	IS
		SELECT Obj_Ent_Oid
		FROM SG_Bioentry_Assoc ea
		WHERE ea.Trm_Oid = NVL(EntA_Trm_Oid, ea.Trm_Oid)
		START WITH Subj_Ent_Oid = EntA_Ent_Oid
		CONNECT BY PRIOR Obj_Ent_Oid = Subj_Ent_Oid
	;
	ans Oid_List_t;
	trm_oid_ SG_Term.Oid%TYPE DEFAULT Trm_Oid;
BEGIN
	-- look up the type term if not provided by oid (note that omitting
	-- the term is allowed)
	IF (trm_oid_ IS NULL) AND 
	   ((Trm_Name IS NOT NULL) OR (Trm_Identifier IS NOT NULL)) THEN
		trm_oid_ := Trm.get_oid(
				Trm_Name       => Trm_Name,
				Trm_Identifier => Trm_Identifier,
				Ont_Oid	       => Ont_Oid,
				Ont_Name       => Ont_Name,
				Cache_By_UK    => 1);
		IF (trm_oid_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Trm <' || Trm_NAME || '|' ||
				ONT_OID || '|' || ONT_NAME || '|' || 
				Trm_IDENTIFIER || '>');
		END IF;
	END IF;
	-- initialize the list
	ans := Oid_List_t();
	-- pull down all matching oids into the list
	OPEN Descendant_c(Ent_Oid, trm_oid_);
	FETCH Descendant_c BULK COLLECT INTO ans;
	-- done
	RETURN ans;
END;

END EntA;
/

