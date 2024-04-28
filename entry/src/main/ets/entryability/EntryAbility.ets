import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { Logger } from '../common/utils/Logger';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info('Ability onCreate')
  }

  onDestroy(): void {
    Logger.info('Ability onDestroy')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info('Ability onWindowStageCreate')

    windowStage.loadContent('pages/LoginPage', (err,data) => {
      if (err.code) {
        Logger.info('Failed to load the content', JSON.stringify(err))
        return;
      }
      Logger.info('Succeeded in loading the content', JSON.stringify(data));
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info( 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info('Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info('Ability onBackground');
  }
}
