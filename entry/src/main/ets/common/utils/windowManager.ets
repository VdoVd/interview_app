import { window } from '@kit.ArkUI'

class WindowManager {
  // 开启安全区域（开启沉浸式模式）
  enableFullScreen() {
    window.getLastWindow(getContext()).then((windowStage: window.Window) => {
      const area = windowStage.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      const topHeight = px2vp(area.topRect.height)
      if (topHeight > 0) {
        windowStage.setWindowLayoutFullScreen(true)
        AppStorage.setOrCreate('topHeight', topHeight)
      }
    })
  }

  // 取消安全区域 （取消沉浸式模式）
  disableFullScreen() {
    window.getLastWindow(getContext()).then((windowStage: window.Window) => {
      windowStage.setWindowLayoutFullScreen(false)
      AppStorage.setOrCreate('topHeight', 0)
    })
  }

  // 安全区域状态栏颜色设置为白色
  settingStatusBarLight() {
    this.settingStatusBar({ statusBarContentColor: '#FFFFFF' })
  }

  // 安全区域状态栏颜色设置为黑色
  settingStatusBarDark() {
    this.settingStatusBar({ statusBarContentColor: '#000000' })
  }

  settingStatusBar(config: window.SystemBarProperties) {
    window.getLastWindow(getContext()).then((windowStage: window.Window) => {
      windowStage.setWindowSystemBarProperties(config)
    })
  }
}

export const windowManager = new WindowManager()