import { HdClockIn } from '../../common/components/HdClockIn'
import { window } from '@kit.ArkUI'

interface content{
  imgPath:Resource
  text:string
}
@Component
export struct Mine {
  @StorageProp('topHeight') topHeight: number = 0

  @State middleList:content[]=[
    {imgPath:$r('app.media.ic_mine_history'),text:'历史记录'},
    {imgPath:$r('app.media.ic_mine_collect'),text:'我的收藏'},
    {imgPath:$r('app.media.ic_mine_like'),text:'我的点赞'},
    {imgPath:$r('app.media.ic_mine_study'),text:'累计学时'},
  ]

  aboutToAppear(): void {
    window.getLastWindow(getContext()).then(win => {
      let area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      win.setWindowLayoutFullScreen(true)  // true：设置全屏
      win.setWindowSystemBarProperties({statusBarContentColor:'#FFFFFF'}) // 白色

      let h = area.topRect.height  // 获取安全区域高度，单位px
      let hvp = px2vp(h)  // 将px单位转换成vp单位
      AppStorage.setOrCreate('topHeight',hvp)  // 将高度保存到AppStorage中共享给其他页面使用
    })
  }

  aboutToDisappear(): void {
    window.getLastWindow(getContext()).then(win => {

      win.setWindowSystemBarProperties({statusBarContentColor:'#FFFFFF'}) // 白色

      AppStorage.setOrCreate('topHeight',0)
    })
  }

  build() {
    Column({space:20}){
      Row({space:15}){
        Image($r('app.media.ic_mine_avatar')).width(50)
        Column({space:10}){

          Text('微信用户')
            .fontWeight(FontWeight.Bold)
            .fontSize(20)

          Text('编辑信息')
            .fontColor(Color.Gray)
            .fontSize(15)

        }.layoutWeight(1).alignItems(HorizontalAlign.Start)
        HdClockIn()
      }.width('100%').backgroundColor(Color.White)
      .padding(20).borderRadius(15)

      Row(){

        ForEach(this.middleList,(item:content,index:number)=>{

          Column({space:10}){

            Image(item.imgPath)
              .width(30)

            Text(item.text)
              .fontColor(Color.Gray)
              .width('100%')
              .textAlign(TextAlign.Center)

          }.width('25%')

        })

      }.backgroundColor(Color.White)
      .padding(20).borderRadius(14)
      .padding({bottom:40,top:20})

      Row(){
        Text('前端常用词').fontSize(15)
        Image($r('app.media.icon_my_new')).width(50)
      }.width('100%').justifyContent(FlexAlign.SpaceBetween).backgroundColor(Color.White).padding(20).borderRadius(14)

      Column({space:10}){
        Text('推荐分享').width('100%').textAlign(TextAlign.Start).fontSize(15)
        Text('意见反馈').width('100%').textAlign(TextAlign.Start).fontSize(15)
        Text('关于我们').width('100%').textAlign(TextAlign.Start).fontSize(15)
      }.backgroundColor(Color.White).padding(20).borderRadius(14)

    }
    .width('100%')
    .height('100%')
    .padding(this.topHeight)
    .backgroundColor('rgba(0,0,0,0.1)')
  }
}