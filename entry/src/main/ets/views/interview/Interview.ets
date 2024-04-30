import { window } from '@kit.ArkUI'

@Component
export struct Interview {
  @StorageProp('topHeight') topHeight: number = 0
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
    Column(){
      Text('面经')
    }
    .width('100%')
    .height('100%')
    .padding(this.topHeight)
  }
}