@Component
export  struct richTextView{
  @Link content:string

  build() {
    RichText(
  `
 <!doctype html>
        <html>
          <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.3" />
            <style>
              body {
                background: "pink";
              }
            </style>
          </head>
          <body>
           <!--真机next系统文字太小，需要增加div设置字体大小和结合initial-scale=1.3兼容一下-->
          <div style="font-size: 30px;">
          kkk
            ${ this.content}
          </div>
          </body>
        </html>
`)
  }

}