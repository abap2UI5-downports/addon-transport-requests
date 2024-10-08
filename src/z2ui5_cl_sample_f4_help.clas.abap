CLASS z2ui5_cl_sample_f4_help DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_arbgb TYPE string.

  PROTECTED SECTION.
    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS on_init.
    METHODS on_event.
    METHODS render_main.
    METHODS call_f4.

  PRIVATE SECTION.
    METHODS on_after_f4.

ENDCLASS.


CLASS z2ui5_cl_sample_f4_help IMPLEMENTATION.

  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN `CALL_POPUP_F4`.
        call_f4( ).

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.

  METHOD on_init.

    render_main( ).

  ENDMETHOD.

  METHOD render_main.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp2 TYPE xsdboolean.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_xml_view=>factory( ).
    
    
    temp2 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->shell( )->page(
                     title          = 'Layout'
                     navbuttonpress = client->_event( 'BACK' )
                     shownavbutton  = temp2
                     class          = 'sapUiContentPadding' ).

    
    CLEAR temp1.
    INSERT `ARBGB` INTO TABLE temp1.
    INSERT `T100` INTO TABLE temp1.
    page->simple_form( title    = 'F4-Help'
                       editable = abap_true
                    )->content( 'form'
                        )->text( `Table t100 field ARBGB is linked to table t100a field ARBGB via a foreign key link.`
                        )->label( `ARBGB`
                        )->input( value            = client->_bind_edit( mv_arbgb )
                                  showvaluehelp    = abap_true
                                  valuehelprequest = client->_event( val   = 'CALL_POPUP_F4'
                                                                     t_arg = temp1 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      on_init( ).
    ENDIF.

    on_event( ).
    on_after_f4( ).

  ENDMETHOD.

  METHOD call_f4.

    DATA lt_arg TYPE string_table.
    DATA temp3 TYPE string.
    DATA temp1 LIKE LINE OF lt_arg.
    DATA temp2 LIKE sy-tabix.
    DATA f4_field LIKE temp3.
    DATA temp4 TYPE string.
    DATA temp5 LIKE LINE OF lt_arg.
    DATA temp6 LIKE sy-tabix.
    DATA f4_table LIKE temp4.
    lt_arg = client->get( )-t_event_arg.
    
    CLEAR temp3.
    
    
    temp2 = sy-tabix.
    READ TABLE lt_arg INDEX 1 INTO temp1.
    sy-tabix = temp2.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    temp3 = temp1.
    
    f4_field = temp3.
    
    CLEAR temp4.
    
    
    temp6 = sy-tabix.
    READ TABLE lt_arg INDEX 2 INTO temp5.
    sy-tabix = temp6.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    temp4 = temp5.
    
    f4_table = temp4.

    client->nav_app_call( z2ui5_cl_pop_displ_f4_help=>factory( i_table = f4_table
                                                         i_fname = f4_field
                                                         i_value = mv_arbgb ) ).

  ENDMETHOD.

  METHOD on_after_f4.
        DATA temp5 TYPE REF TO z2ui5_cl_pop_displ_f4_help.
        DATA app LIKE temp5.

    IF client->get( )-check_on_navigated = abap_false.
      RETURN.
    ENDIF.

    TRY.
        
        temp5 ?= client->get_app( client->get( )-s_draft-id_prev_app ).
        
        app = temp5.

        IF app->mv_return_value IS NOT INITIAL.

          CASE app->mv_field.
            WHEN `ARBGB`.
              mv_arbgb = app->mv_return_value.

            WHEN OTHERS.

          ENDCASE.

          client->view_model_update( ).

        ENDIF.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
