CKEDITOR.plugins.add( 'html5audio', {
    requires: 'widget',
    lang: 'bg,ca,de,de-ch,el,en,eu,es,fr,ru,uk,uz,zh-cn,fa,pl',
    icons: 'html5audio',
    hidpi: true,
    init: function( editor ) {
        editor.widgets.add( 'html5audio', {
            button: editor.lang.html5audio.button,
            template: '<div class="ckeditor-html5-audio"></div>',   // We add the audio element when needed in the data function, to avoid having an undefined src attribute.
                                                                    // See issue #9 on github: https://github.com/iametza/ckeditor-html5-audio/issues/9
            editables: {},
            /*
             * Allowed content rules (http://docs.ckeditor.com/#!/guide/dev_allowed_content_rules):
             *  - div-s with text-align,float,margin-left,margin-right inline style rules and required ckeditor-html5-audio class.
             *  - audio tags with src and controls attributes.
             */
            allowedContent: 'div(!ckeditor-html5-audio){text-align,float,margin-left,margin-right}; iframe[src,url,lrc,name,artist,cover];',
            requiredContent: 'div(ckeditor-html5-audio); iframe[src,url];',
            upcast: function( element ) {
                return element.name === 'div' && element.hasClass( 'ckeditor-html5-audio' );
            },
            dialog: 'html5audio',
            init: function() {
                // var audioElement = this.element.findOne( 'audio' );
                var iframeElement = this.element.findOne( 'iframe' );
                var src = '/lams/ckeditor/plugins/html5audio/iframe/audio.html?';
                var name = '';
                var artist = '';
                var cover = '';
                var lrc = '';
                var url = '';
                var align = this.element.getStyle( 'text-align' );

                // If there's a child (the audio element)
                if ( iframeElement ) {
                    // get it's attributes.
                    name = iframeElement.getAttribute( 'name' );
                    artist = iframeElement.getAttribute( 'artist' );
                    url = iframeElement.getAttribute( 'url' );
                    cover = iframeElement.getAttribute( 'cover' );
                    lrc = iframeElement.getAttribute( 'lrc' );
                    if ( name ) {
                        this.setData( 'name', name );
                    }
                    if ( artist ) {
                        this.setData( 'artist', artist );
                    }
                    if ( cover ) {
                        this.setData( 'cover', cover );
                    }
                    if ( lrc ) {
                        this.setData( 'lrc', lrc );
                    }

                    if ( url ) {
                        this.setData( 'url', url );
                        if ( align ) {
                            this.setData( 'align', align );
                        } else {
                            this.setData( 'align', 'none' );
                        }
                    }
                }
                src += name ? 'name=' + name + '&' : "";
                src += artist ? 'artist=' + artist + '&' : "";
                src += cover ? 'cover=' + cover + '&' : "";
                src += lrc ? 'lrc=' + lrc + '&' : "";
                src += url ? 'url=' + url + '&' : "";
                this.setData( 'src', src.substring(0, src.length - 1));
            },
            data: function() {
                var iframeElement = this.element.findOne( 'iframe' );
                // If there is an audio source
                if ( this.data.url ) {
                    var src = '/lams/ckeditor/plugins/html5audio/iframe/audio.html?';
                    // and there isn't a child (the audio element)
                    if ( !iframeElement ) {
                        // Create a new <audio> element.
                        iframeElement = new CKEDITOR.dom.element( 'iframe' );
                        iframeElement.setAttribute( 'name', this.data.name ? this.data.name : "");
                        iframeElement.setAttribute( 'artist', this.data.artist ? this.data.artist : "");
                        iframeElement.setAttribute( 'url', this.data.url ? this.data.url : "");
                        iframeElement.setAttribute( 'cover', this.data.cover ? this.data.cover : "");
                        iframeElement.setAttribute( 'lrc', this.data.lrc ? this.data.lrc : "");
                        this.element.append( iframeElement );
                    } else {
                        iframeElement.setAttribute( 'name', this.data.name ? this.data.name : "");
                        iframeElement.setAttribute( 'artist', this.data.artist ? this.data.artist : "");
                        iframeElement.setAttribute( 'url', this.data.url ? this.data.url : "");
                        iframeElement.setAttribute( 'cover', this.data.cover ? this.data.cover : "");
                        iframeElement.setAttribute( 'lrc', this.data.lrc ? this.data.lrc : "");
                    }

                    src += this.data.name ? 'name=' + this.data.name + '&' : "";
                    src += this.data.artist ? 'artist=' + this.data.artist + '&' : "";
                    src += this.data.cover ? 'cover=' + this.data.cover + '&' : "";
                    src += this.data.lrc ? 'lrc=' + this.data.lrc + '&' : "";
                    src += this.data.url ? 'url=' + this.data.url + '&' : "";
                    iframeElement.setAttribute( 'src', src.substring(0, src.length - 1));
                }

                this.element.removeStyle( 'margin-left' );
                this.element.removeStyle( 'margin-right' );

                if ( this.data.align === 'none' ) {
                    this.element.removeStyle( 'text-align' );
                } else {
                    this.element.setStyle( 'text-align', this.data.align );
                }
            }
        } );

        if ( editor.contextMenu ) {
            editor.addMenuGroup( 'html5audioGroup' );
            editor.addMenuItem( 'html5audioPropertiesItem', {
                label: editor.lang.html5audio.audioProperties,
                icon: 'html5audio',
                command: 'html5audio',
                group: 'html5audioGroup'
            });

            editor.contextMenu.addListener( function( element ) {
                var iframeElement = element && element.findOne( 'iframe' );
                if ( iframeElement &&
                    iframeElement.hasClass &&
                    iframeElement.hasClass( 'ckeditor-html5-audio' ) ) {
                    return { html5audioPropertiesItem: CKEDITOR.TRISTATE_OFF };
                }
            });
        }

        CKEDITOR.dialog.add( 'html5audio', this.path + 'dialogs/html5audio.js' );
    }
} );
