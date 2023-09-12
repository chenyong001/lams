CKEDITOR.dialog.add( 'html5audio', function( editor ) {
    return {
        title: editor.lang.html5audioCus.title,
        minWidth: 500,
        minHeight: 200,
        contents: [ {
            id: 'info',
            label: editor.lang.html5audioCus.infoLabel,
            elements: [ {
                type: 'vbox',
                padding: 0,
                children: [ {
                    type: 'hbox',
                    widths: [ '365px', '110px' ],
                    align: 'right',
                    children: [ {
                        type: 'text',
                        id: 'url',
                        label: editor.lang.html5audioCus.allowed,
                        required: true,
                        validate: CKEDITOR.dialog.validate.notEmpty( editor.lang.html5audioCus.urlMissing ),
                        setup: function( widget ) {
                            this.setValue( widget.data.url );
                        },
                        commit: function( widget ) {
                            widget.setData( 'url', this.getValue() );
                        }
                    },
                    {
                        type: 'button',
                        id: 'browse',
                        // v-align with the 'txtUrl' field.
                        // TODO: We need something better than a fixed size here.
                        style: 'display:inline-block;margin-top:14px;',
                        align: 'center',
                        label: editor.lang.common.browseServer,
                        hidden: true,
                        filebrowser: 'info:url'
                    } ]
                },
                {
                    type: 'hbox',
                    widths: [ '365px', '110px' ],
                    align: 'right',
                    children: [ {
                        type: 'text',
                        id: 'lrc',
                        label: editor.lang.html5audioCus.lrc,
                        required: false,
                        setup: function( widget ) {
                            this.setValue( widget.data.lrc );
                        },
                        commit: function( widget ) {
                            widget.setData( 'lrc', this.getValue() );
                        }
                    },
                    {
                        type: 'button',
                        id: 'browse',
                        // v-align with the 'txtUrl' field.
                        // TODO: We need something better than a fixed size here.
                        style: 'display:inline-block;margin-top:14px;',
                        align: 'center',
                        label: editor.lang.common.browseServer,
                        hidden: true,
                        filebrowser: 'info:lrc'
                    } ]
                },{
                    type: 'hbox',
                    widths: [ '365px', '110px' ],
                    align: 'right',
                    children: [ {
                        type: 'text',
                        id: 'cover',
                        label: editor.lang.html5audioCus.cover,
                        setup: function( widget ) {
                            this.setValue( widget.data.cover );
                        },
                        commit: function( widget ) {
                            widget.setData( 'cover', this.getValue() );
                        }
                    },
                    {
                        type: 'button',
                        id: 'browse',
                        // v-align with the 'txtUrl' field.
                        // TODO: We need something better than a fixed size here.
                        style: 'display:inline-block;margin-top:14px;',
                        align: 'center',
                        label: editor.lang.common.browseServer,
                        hidden: true,
                        filebrowser: 'info:cover'
                    } ]
                },
                {
                    type: 'hbox',
                    children: [ {
                        type: "text",
                        id: 'name',
                        label: editor.lang.html5audioCus.name,
                        'default': '',
                        setup: function( widget ) {
                            if ( widget.data.name ) {
                                this.setValue(widget.data.name);
                            }
                        },
                        commit: function( widget ) {
                            widget.setData( 'name', this.getValue() );
                        }
                    },
                    {
                        type: "text",
                        id: 'artist',
                        label: editor.lang.html5audioCus.artist,
                        'default': '',
                        setup: function( widget ) {
                            if ( widget.data.name ) {
                                this.setValue(widget.data.artist);
                            }
                        },
                        commit: function( widget ) {
                            widget.setData( 'artist', this.getValue() );
                        }
                    }]
                }
                ]
            },
            {
                type: 'hbox',
                id: 'alignment',
                children: [ {
                    type: 'radio',
                    id: 'align',
                    label: editor.lang.common.align,
                    items: [
                        [editor.lang.common.alignCenter, 'center'],
                        [editor.lang.common.alignLeft, 'left'],
                        [editor.lang.common.alignRight, 'right'],
                        [editor.lang.common.alignNone, 'none']
                    ],
                    'default': 'center',
                    setup: function( widget ) {
                        if ( widget.data.align ) {
                            this.setValue( widget.data.align );
                        }
                    },
                    commit: function( widget ) {
                        widget.setData( 'align', this.getValue() );
                    }
                } ]
            } ]
        } ]
    };
} );
