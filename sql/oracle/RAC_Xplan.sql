declare

------------------------
-- PROCEDURE: Display --
------------------------
/******************************************************************************
Wrapper around DBMS_Xplan.Display to view plans in a RAC environment.

PARAMETERS: Inst_Id : Instance identifier.
            SQL_Id  : SQL idendifier.
            Format  : DBMS_Xplan display format (see Oracle documentation for options.)
                    : Defaults to ADVANCED.

NOTES: Run as an anonymous block rather than a piplined function due to grants.

******************************************************************************/

    procedure Display(
                  Inst_Id in number
              ,   SQL_Id  in varchar2
              ,   Format  in varchar2 := 'ADVANCED'
              )

    is

    ---------------
    -- constants --
    ---------------

        Plan_View constant varchar2(30) := 'gv$sql_plan_statistics_all';

    ---------------
    -- variables --
    ---------------

        Child_No        number;
        Filter_Template varchar2(100) := q'[inst_id = %s and sql_id = '%s' and child_number = %s]';

    ---------------------------------------------------------------------------

    begin

        select
            child_number
        into
            Child_No
        from
            gv$sql_plan_statistics_all
        where
            inst_id = Display.Inst_Id
        and sql_id  = Display.SQL_Id
        and rownum < 2;

        Filter_Template := Sys.Utl_Lms.Format_Message(Filter_Template, to_char(Inst_Id), SQL_Id, to_char(Child_No));

        <<Plan_Loop>>
        for Current_Plan_Row in(
            select
                plan_table_output
            from
                table(
                    Sys.DBMS_Xplan.Display(
                                       Table_Name   => Plan_View
                                   ,   Format       => Display.Format
                                   ,   Filter_Preds => Filter_Template
                                   )
                )
        ) loop

            Sys.DBMS_Output.Put_Line(Current_Plan_Row.Plan_Table_Output);

        end loop Plan_Loop;

    end Display;

---------------------
-- PROCEDURE: Main --
---------------------

    procedure Main is

    begin

        Display(
            Inst_Id => &1
        ,   SQL_Id  => '&2'
        );

    end Main;

-------------------------------------------------------------------------------

begin

    Main;

end;
/
