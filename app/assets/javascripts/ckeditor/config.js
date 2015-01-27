CKEDITOR.on( 'dialogDefinition', function( ev )
   {
      // Take the dialog name and its definition from the event
      // data.
      var dialogName = ev.data.name;
      var dialogDefinition = ev.data.definition;

      // Check if the definition is from the dialog we're
      // interested on (the Link and Image dialog).
      if ( dialogName == 'link' || dialogName == 'image' )
      {
         // remove Upload tab
         dialogDefinition.removeContents( 'Upload' );
      }
   });