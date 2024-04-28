import { Home } from '../views/home/Home'
import { Project } from '../views/project/Project'
import { Interview } from '../views/interview/Interview'
import { Mine } from '../views/mime/Mine'


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
            Mine()
          }
        }.tabBar(this.TabBarBuilder('我的', 3, $r('app.media.ic_tabbar_interview'),
          $r('app.media.ic_tabbar_interview_select')))
      }
      .onChange((index) => {
        this.currentIndex = index
      })
    }
    .height('100%')
  }
}