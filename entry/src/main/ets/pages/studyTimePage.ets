import { allResponse, studyInfo } from '../common/utils/myReq'
import { windowManager } from '../common/utils/windowManager'
import { ListItemStudy, StudyData } from '../models/StudyInfo'



@Entry
@Component
struct studyTimePage {

  @State
  knowledge: ListItemStudy[] = [
    {
      id: "1",
      name: "ArkTS",
      total: 100,
      done: 20,
      undone: 80
    },
    {
      id: "1",
      name: "ArkUI",
      total: 100,
      done: 40,
      undone: 60
    }
  ]
  @State
  project: ListItemStudy[] = [
    {
      id: "1",
      name: "鸿蒙应用",
      total: 100,
      done: 20,
      undone: 80
    }
  ]
  @State
  totalTime: number = 300

  @StorageProp('topHeight')
  topHeight: number = 0

  async onPageShow(): Promise<void>{

    const res=await studyInfo()

    let result=JSON.parse(res.result.toString()) as allResponse<StudyData>

    console.info(`study data:${JSON.stringify(result)}`)

    this.totalTime=result.data.totalTime

    this.knowledge=result.data.studyData[0].list

    this.project=result.data.studyData[1].list
  }

  // 秒转换成分钟或者小时
  getTimeText(time: number = 0, hasUnit = true) {
    if (time < 3600) {
      return String(Math.floor(time / 60)) + (hasUnit ? ' 分钟' : '')
    } else {
      return String(Math.round(time / 3600 * 10) / 10) + (hasUnit ? ' 小时' : '')
    }
  }

  //  转换成百分比
  getPercentText(value: number, total: number) {
    return Math.round(value / total * 100) + '%'
  }

  aboutToAppear(): void {
    windowManager.settingStatusBarDark()
  }

  aboutToDisappear(): void {
    windowManager.settingStatusBarLight()
  }

  build() {
    Navigation() {
      Scroll() {
        Column() {
          Row() {
            Text('累计学习时长').margin({ right: (4) })
            Image($r('app.media.icon_study_clock')).width((14)).height((14))
          }.width('100%').margin({ bottom: (10) })

          Row() {
            Text(this.getTimeText(this.totalTime, false)).fontSize((40)).fontWeight(FontWeight.Bold)
            Text(this.totalTime < 3600 ? '分钟' : '小时').margin({ bottom: (8), left: (8) })
          }.width('100%').alignItems(VerticalAlign.Bottom).margin({ bottom: (20) })

          Column() {
            Text('知识点学习进度').margin({ bottom: (10) })
            GridRow({ columns: 2, gutter: 20 }) {
              ForEach(this.knowledge, (item: ListItemStudy) => {
                GridCol() {
                  Column() {
                    Row() {
                      Text(item.name).fontColor('#c3c4c5').fontSize((14))
                      Text(this.getPercentText(item.done, item.total)).fontColor('#c3c4c5').fontSize((14))
                    }.width('100%').justifyContent(FlexAlign.SpaceBetween)
                    .margin({ bottom: (5) })

                    Progress({ value: item.done, total: item.total }).color('#87E0CD')
                  }
                }
              })

              GridCol({ span: 2 }) {
                Row() {
                  Text()
                    .width((7))
                    .height((7))
                    .borderRadius((4))
                    .backgroundColor('#87E0CD')
                    .margin({ right: (4) })
                  Text('已学占比').fontSize((12)).margin({ right: (20) })
                  Text()
                    .width((7))
                    .height((7))
                    .borderRadius((4))
                    .backgroundColor('#c3c4c5')
                    .margin({ right: (4) })
                  Text('未学占比').fontSize((12))
                }.justifyContent(FlexAlign.Center)
              }
            }.backgroundColor('#fff').borderRadius((4)).padding((15))

          }.width('100%').alignItems(HorizontalAlign.Start).margin({ bottom: (25) })

          Column() {
            Text('项目常问学习进度').margin({ bottom: (10) })
            GridRow({ columns: 1 }) {
              ForEach(this.project, (item: ListItemStudy) => {
                GridCol() {
                  Column() {
                    Row() {
                      Text(item.name).fontColor('#c3c4c5').fontSize((14))
                      Text(this.getPercentText(item.done, item.total)).fontColor('#c3c4c5').fontSize((14))
                    }.width('100%').justifyContent(FlexAlign.SpaceBetween)
                    .margin({ bottom: (5) })

                    Progress({ value: item.done, total: item.total }).color('#c7b5ed').width('100%')
                  }.margin({ bottom: (25) })
                }
              })

              GridCol({ span: 2 }) {
                Row() {
                  Text()
                    .width((7))
                    .height((7))
                    .borderRadius((4))
                    .backgroundColor('#c7b5ed')
                    .margin({ right: (4) })
                  Text('已学占比').fontSize((12)).margin({ right: (20) })
                  Text()
                    .width((7))
                    .height((7))
                    .borderRadius((4))
                    .backgroundColor('#c3c4c5')
                    .margin({ right: (4) })
                  Text('未学占比').fontSize((12))
                }.justifyContent(FlexAlign.Center)
              }
            }.backgroundColor('#fff').borderRadius((4)).padding((15))
          }.width('100%').alignItems(HorizontalAlign.Start)

        }.padding((15))
      }
    }
    .title('学习数据')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    // .margin({ top: this.topHeight })
    .linearGradient({
      angle: 163,
      colors: [['#defbee', 0], ['#dbf4f1', 0.2], ['#f6f7f9', 1]]
    })
    .padding({ top: this.topHeight })
  }
}