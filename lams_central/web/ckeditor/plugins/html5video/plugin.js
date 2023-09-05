CKEDITOR.plugins.add( 'html5video', {
    requires: 'widget',
    lang: 'bg,ca,de,en,eu,es,ru,uk,fr,ko,pt,pt-br,pl',
    icons: 'html5video',
    init: function( editor ) {
        editor.widgets.add( 'html5video', {
            button: editor.lang.html5video.button,
            template: '<div class="ckeditor-html5-video"></div>',
            /*
             * Allowed content rules (http://docs.ckeditor.com/#!/guide/dev_allowed_content_rules):
             *  - div-s with text-align,float,margin-left,margin-right inline style rules and required ckeditor-html5-video class.
             *  - video tags with src, controls, width and height attributes.
             */
            allowedContent: 'div[data-responsive](!ckeditor-html5-video){text-align,float,margin-left,margin-right}; video[src,poster,controls,autoplay,width, height,loop]{max-width,height};',
            requiredContent: 'div(ckeditor-html5-video); video[src];',
            upcast: function( element ) {
                return element.name === 'div' && element.hasClass( 'ckeditor-html5-video' );
            },
            dialog: 'html5video',
            init: function() {
                var src = '';
                var track = '';
                var autoplay = '';
                var loop = '';
                // var controls = '';
                var align = this.element.getStyle( 'text-align' );

                var width = '';
                var height = '';
                var poster = '';

                // If there's a child (the video element)
                if ( this.element.getChild( 0 ) ) {
                    // get it's attributes.
                    src = this.element.getChild( 0 ).getAttribute( 'src' );
                    width = this.element.getChild( 0 ).getAttribute( 'width' );
                    height = this.element.getChild( 0 ).getAttribute( 'height' );
                    autoplay = this.element.getChild(0).getAttribute('autoplay');
                    // allowdownload = !this.element.getChild( 0 ).getAttribute( 'controlslist' );
                    loop = this.element.getChild( 0 ).getAttribute( 'loop' );
                    advisorytitle = this.element.getChild( 0 ).getAttribute( 'title' );
                    responsive = this.element.getAttribute( 'data-responsive' );
                    poster = this.element.getChild( 0 ).getAttribute( 'poster' );
                    if (this.element.getChild( 0 ).getChild( 0 )){
                        track = this.element.getChild( 0 ).getChild( 0 ).getAttribute( 'src' );
                    }
                }

                if ( src ) {
                    this.setData( 'src', src );

                    if ( align ) {
                        this.setData( 'align', align );
                    } else {
                        this.setData( 'align', 'none' );
                    }

                    if ( width ) {
                        this.setData( 'width', width );
                    }

                    if ( height ) {
                        this.setData( 'height', height );
                    }

                    if ( autoplay ) {
                        this.setData( 'autoplay', 'yes' );
                    }

                    // if ( allowdownload ) {
                    //     this.setData( 'allowdownload', 'no' );
                    // }

                    if ( loop ) {
                        this.setData( 'loop', 'yes' );
                    }

                    if ( advisorytitle ) {
                        this.setData( 'advisorytitle', advisorytitle );
                    }

                    if ( responsive ) {
                        this.setData( 'responsive', responsive );
                    }
                    //
                    // if (controls) {
                    //     this.setData('controls', controls);
                    // }

                    if ( poster ) {
                        this.setData('poster', poster);
                    }
                    if ( track ) {
                        this.setData('track', track);
                    }
                }
            },
            data: function() {
                // If there is an video source
                if ( this.data.src ) {
                    // and there isn't a child (the video element)
                    if ( !this.element.getChild( 0 ) ) {
                        // Create a new <video> element.
                        var videoElement = new CKEDITOR.dom.element( 'video' );
                        // Set the controls attribute.
                        // if (this.data.controls) {
                            videoElement.setAttribute('controls', 'controls');
                        // }
                        // Append it to the container of the plugin.
                        this.element.append( videoElement );
                    }
                    this.element.getChild( 0 ).setAttribute( 'src', this.data.src );
                    if (this.data.width) this.element.getChild( 0 ).setAttribute( 'width', this.data.width );
                    if (this.data.height) this.element.getChild( 0 ).setAttribute( 'height', this.data.height );

                    if ( this.data.responsive ) {
                            this.element.setAttribute("data-responsive", this.data.responsive);
                            this.element.getChild( 0 ).setStyle( 'max-width', '100%' );
                            this.element.getChild( 0 ).setStyle( 'height', 'auto' );
                    } else {
			    this.element.removeAttribute("data-responsive");
                            this.element.getChild( 0 ).removeStyle( 'max-width' );
                            this.element.getChild( 0 ).removeStyle( 'height' );
                    }

                    if (this.data.poster) this.element.getChild( 0 ).setAttribute('poster', this.data.poster);
                    // 设置字幕节点
                    var trackElement = this.element.getChild( 0 ).getChild( 0 );
                    if (trackElement) {
                        if ( this.data.track ){
                            trackElement.setAttribute('src', this.data.track);
                        } else {
                            trackElement.remove();
                        }
                    } else {
                        trackElement = new CKEDITOR.dom.element('track');
                        if (this.data.track){
                            trackElement.setAttribute('src', this.data.track);
                            this.element.getChild(0).append(trackElement)
                        }
                    }


                    // // 设置视频的快进快退
                    // var vol = 0.1; //1代表100%音量，每次增减0.1
                    // var time = 30; //单位秒，每次增减30秒
                    // this.element.onkeyup = function (event) {//鼠标键盘事件，上下左右和空格键功能
                    //     var e = event || window.event || arguments.callee.caller.arguments[0];
                    //     //鼠标上下键控制视频音量
                    //     if (e && e.keyCode === 38) {
                    //         // 按 向上键
                    //         videoElement.volume !== 1 ? videoElement.volume += vol : 1;
                    //         return false;
                    //     } else if (e && e.keyCode === 40) {
                    //         // 按 向下键
                    //         videoElement.volume !== 0 ? videoElement.volume -= vol : 1;
                    //         return false;
                    //     } else if (e && e.keyCode === 37) {
                    //         // 按 向左键
                    //         videoElement.currentTime !== 0 ? videoElement.currentTime -= time : 1;
                    //         return false;
                    //     } else if (e && e.keyCode === 39) {
                    //         // 按 向右键
                    //         videoElement.volume !== videoElement.duration ? videoElement.currentTime += time : 1;
                    //         return false;
                    //     } else if (e && e.keyCode === 32) {
                    //         // 按空格键 判断当前是否暂停
                    //         videoElement.paused === true ? videoElement.play() : videoElement.pause();
                    //         return false;
                    //     }
                    // };
                }

                this.element.removeStyle( 'float' );
                this.element.removeStyle( 'margin-left' );
                this.element.removeStyle( 'margin-right' );

                if ( this.data.align === 'none' ) {
                    this.element.removeStyle( 'text-align' );
                } else {
                    this.element.setStyle( 'text-align', this.data.align );
                }

                if ( this.data.align === 'left' ) {
                    this.element.setStyle( 'float', this.data.align );
                    this.element.setStyle( 'margin-right', '10px' );
                } else if ( this.data.align === 'right' ) {
                    this.element.setStyle( 'float', this.data.align );
                    this.element.setStyle( 'margin-left', '10px' );
                }

                if ( this.element.getChild( 0 ) ) {
                    if ( this.data.autoplay === 'yes' ) {
                        this.element.getChild( 0 ).setAttribute( 'autoplay', 'autoplay' );
                    } else {
                        this.element.getChild( 0 ).removeAttribute( 'autoplay' );
                    }

                    if ( this.data.loop === 'yes' ) {
                        this.element.getChild( 0 ).setAttribute( 'loop', 'loop' );
                    } else {
                        this.element.getChild( 0 ).removeAttribute( 'loop' );
                    }

                    // 删除下载功能
                    // if ( this.data.allowdownload === 'yes' ) {
                    //     this.element.getChild( 0 ).removeAttribute( 'controlslist' );
                    // } else {
                    this.element.getChild( 0 ).setAttribute( 'controlslist', 'nodownload' );
                    this.element.getChild( 0 ).oncontextmenu = function(){
                        return false;
                    }
                    // }

                    if ( this.data.advisorytitle ) {
                        this.element.getChild( 0 ).setAttribute( 'title', this.data.advisorytitle );
                    } else {
                        this.element.getChild( 0 ).removeAttribute( 'title' );
                    }
                }
            }
        } );

        if ( editor.contextMenu ) {
            editor.addMenuGroup( 'html5videoGroup' );
            editor.addMenuItem( 'html5videoPropertiesItem', {
                label: editor.lang.html5video.videoProperties,
                icon: 'html5video',
                command: 'html5video',
                group: 'html5videoGroup'
            });

            editor.contextMenu.addListener( function( element ) {
                if ( element &&
                     element.getChild( 0 ) &&
                     element.getChild( 0 ).hasClass &&
                     element.getChild( 0 ).hasClass( 'ckeditor-html5-video' ) ) {
                    return { html5videoPropertiesItem: CKEDITOR.TRISTATE_OFF };
                }
            });
        }

        CKEDITOR.dialog.add( 'html5video', this.path + 'dialogs/html5video.js' );
    }
} );
