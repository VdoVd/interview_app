import { homeSubItemModel } from '../../models/homeSubListModel'

@Component
export default struct HomeSubListItemView{

  @Prop item:homeSubItemModel={} as homeSubItemModel

  @State difficulty:number=this.item.difficulty

  @State difficultyText:string=''

  @State isLike:boolean=false

  build() {

      Column({space:12}){

        Row({space:18}){

          Text(this.difficultyText)
            .onAppear(()=>{
              this.difficultyText=this.difficulty===1||this.difficulty===2?'简单':(this.difficulty===3||this.difficulty===4?'一般':'困难')
            })
            .padding(2)
            .fontSize(12)
            .fontColor(this.difficultyText==='简单'?Color.Green:(this.difficultyText==='一般'?Color.Blue:Color.Orange))
            .backgroundColor('rgba(0,0,0,0.1)')

          Text(`${this.item.stem}`)
            .textOverflow({overflow:TextOverflow.Ellipsis})
            .layoutWeight(1)
            .fontWeight(FontWeight.Bold)
            .fontSize(15)

        }.width('100%')
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)

        Row({space:15}){

          //isLike
          if(this.item.likeFlag===0){

            Text(`点赞 ${this.item.likeCount}`)
              .styleOfText()

          }else {

            Image($r('app.media.ic_mine_like'))
              .fillColor(Color.White)
              .backgroundColor(Color.Orange)

          }
          Text('|')
            .styleOfText()
          //viewNum
          Text(`浏览 ${this.item.views}`)
            .styleOfText()
          //review
          Text(this.item.readFlag===0?'未读':'已读')
            .styleOfText()
        }.width('100%')
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)

      }

  }

}

@Extend(Text)
function styleOfText() {
  .fontColor('rgba(0,0,0,0.3)')
  .fontSize(14)
}
