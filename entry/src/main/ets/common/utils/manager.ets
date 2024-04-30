import { window } from '@kit.ArkUI'

export class untilWinManagerClass{
  public fullScreen(){
    window.getLastWindow(getContext()).then(win => {
      win.setWindowLayoutFullScreen(true)  // true：设置全屏
    })
  }
  public setWindowBarFontColor(){
    window.getLastWindow(getContext()).then(win => {
      win.setWindowSystemBarProperties({statusBarContentColor:'#FFFFFF'}) // 白色
    })
  }
  public setWindowBarHeight(){
    window.getLastWindow(getContext()).then(win => {
      const area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      const height = px2vp(area.topRect.height)
      AppStorage.setOrCreate('topHeight',height)
    })

  }
}