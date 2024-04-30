@Component
export struct Project {
  @StorageProp('topHeight') topHeight: number = 0

  build() {
    Column(){

      Navigation(){
          Column(){

          }
        Text('其他项目正在赶来的路上')
          .width('100%')
          .fontColor(Color.Gray)
          .fontSize(15)
          .layoutWeight(1)
      }.title('项目')
      .titleMode(NavigationTitleMode.Mini)
      .backgroundColor(Color.Blue)



    }
    .width('100%')
    .height('100%')
    .padding({top:this.topHeight})

  }
}