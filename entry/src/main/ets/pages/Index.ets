import { Home } from '../views/home/Home'
import { Project } from '../views/project/Project'
import { Interview } from '../views/interview/Interview'
import MineContentPartView from '../views/mine/MineContentView'
import { window } from '@kit.ArkUI'


@Entry
@Component
struct Index {
  @State currentIndex: number = 0

  @Builder
  TabBarBuilder(txt: string, index: number, defaultIcon: ResourceStr, activeInco: ResourceStr) {
    Column({space:3}){
      Image(this.currentIndex === index?activeInco:defaultIcon)
        .height(22)
        .aspectRatio(1)
      Text(txt)
        .fontSize(10)
    }
  }

  onPageShow(): void {
    window.getLastWindow(getContext()).then(win => {
      let area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      win.setWindowLayoutFullScreen(true)  // true：设置全屏
      win.setWindowSystemBarProperties({statusBarContentColor:'#FFFFFF'}) // 白色

      let h = area.topRect.height  // 获取安全区域高度，单位px
      let hvp = px2vp(h)  // 将px单位转换成vp单位
      console.log(`hvp:${hvp}`)
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
    Row() {
      Tabs({barPosition:BarPosition.End}) {
        TabContent() {
          if(this.currentIndex === 0){
            Home()
          }
        }.tabBar(this.TabBarBuilder('首页', 0, $r('app.media.ic_tabbar_home'),
          $r('app.media.ic_tabbar_home_select')))

        TabContent() {
          if(this.currentIndex === 1){
            Project()
          }
        }.tabBar(this.TabBarBuilder('项目', 1, $r('app.media.ic_tabbar_project'),
          $r('app.media.ic_tabbar_project_select')))

        TabContent() {
          if(this.currentIndex === 2){
            Interview()
          }
        }.tabBar(this.TabBarBuilder('面经', 2, $r('app.media.ic_tabbar_interview'),
          $r('app.media.ic_tabbar_interview_select')))

        TabContent() {
          if(this.currentIndex === 3){
            MineContentPartView()
          }
        }.tabBar(this.TabBarBuilder('我的', 3, $r('app.media.ic_tabbar_interview'),
          $r('app.media.ic_tabbar_interview_select')))
      }
      .onChange((index) => {
        this.currentIndex = index
      })
    }
    .height('100%')
    .padding({bottom:15})
  }
}


