--
-- SQL script to create the trigger(s) enabling the load API for
-- SGLD_Seqfeatures.
--
-- Scaffold auto-generated by gen-api.pl.
--
--
-- $Id: Seqfeatures.trg,v 1.1.1.2 2003-01-29 08:54:36 lapp Exp $
--

--
-- (c) Hilmar Lapp, hlapp at gnf.org, 2002.
-- (c) GNF, Genomics Institute of the Novartis Research Foundation, 2002.
--
-- You may distribute this module under the same terms as Perl.
-- Refer to the Perl Artistic License (see the license accompanying this
-- software package, or see http://www.perl.com/language/misc/Artistic.html)
-- for the terms under which you may use, modify, and redistribute this module.
-- 
-- THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
-- WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
-- MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
--

CREATE OR REPLACE TRIGGER BIUR_Seqfeatures
       INSTEAD OF INSERT OR UPDATE
       ON SGLD_Seqfeatures
       REFERENCING NEW AS new OLD AS old
       FOR EACH ROW
DECLARE
	pk		SG_SEQFEATURE.OID%TYPE DEFAULT :new.Fea_Oid;
	do_DML		INTEGER DEFAULT BSStd.DML_NO;
BEGIN
	IF INSERTING THEN
		do_DML := BSStd.DML_I;
	ELSE
		-- this is an update
		do_DML := BSStd.DML_UI;
	END IF;
	-- do insert or update (depending on whether it exists or not)
	pk := Fea.get_oid(
			Fea_OID => pk,
		        Fea_RANK => Fea_RANK,
			Fea_ENT_OID => ENT_OID_,
			Fea_ONT_OID => ONT_OID_,
			Fea_FSRC_OID => FSRC_OID_,
			do_DML             => do_DML);
END;
/
