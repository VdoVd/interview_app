import { HdTag } from '../../common/components/HdTag'
import { router, window } from '@kit.ArkUI'
import { allResponse, getQuestionType } from '../../common/utils/myReq'

export interface ProjectTag {
  tagName: string
}

export interface ProjectItem {
  id: number
  name: string
  icon: ResourceStr
  describeInfo: string | null
  tags: ProjectTag[]
}

export class ProjectItemModel implements ProjectItem {
  id: number
  name: string
  icon: ResourceStr
  describeInfo: string | null
  tags: ProjectTag[]

  constructor(model: ProjectItem) {
    this.id = model.id
    this.name = model.name
    this.icon = model.icon
    this.describeInfo = model.describeInfo
    this.tags = model.tags
  }
}

export const ProjectItemData: ProjectItem[] = [
  {
    id: 1,
    name: '后台管理系统',
    icon: $r('app.media.project02'),
    describeInfo: '以Vue技理后台后台管理系统面试题面试整理',
    tags: [{ tagName: '后台系统' }]
  },
  {
    id: 2,
    name: '在线问医生平台（医疗类）',
    icon: $r('app.media.project01'),
    describeInfo: '通过vue3+ts实现的在线医疗问诊相关技术整理',
    tags: [{ tagName: 'H5项目' }]
  },
  {
    id: 3,
    name: '鸿蒙知识点',
    icon: $r('app.media.project03'),
    describeInfo: '以 ArkTS 与 ArkUI 为主的鸿蒙基础知识点讲解',
    tags: [{ tagName: '鸿蒙应用' }]
  }
]

@Component
export struct Project {

  @StorageLink('topHeight') topHeight:number=0
  @State
  list: ProjectItemModel[] = ProjectItemData

  async aboutToAppear(): Promise<void> {
    const res=await getQuestionType()
    this.list=[...(JSON.parse(res.result.toString()) as allResponse<ProjectItem[]>).data]
    console.log(`res:${JSON.stringify(this.list)}`)
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

  @Builder
  ProjectItemBuilder(item: ProjectItemModel) {
    Row({ space: 15 }) {
      Image(item.icon)
        .size({ width: 60, height: 80 })
        .sharedTransition(item.id.toString(), { duration: 300 })
      Column({ space: 15 }) {
        Text(item.name)
          .fontWeight(500)
        Text(item.describeInfo)
          .fontSize($r('app.float.common_font12'))
          .fontColor($r('app.color.common_gray_02'))
        Blank()
        Row({ space: 4 }) {
          ForEach(item.tags, (tag: ProjectTag) => {
            HdTag({ text: tag.tagName })
          })
        }
      }
      .layoutWeight(1)
      .height(80)
      .alignItems(HorizontalAlign.Start)
    }
    .padding({
      top: $r('app.float.common_gutter'),
      bottom: $r('app.float.common_gutter')
    })
    .alignItems(VerticalAlign.Top)
    .onClick(() => {
      router.pushUrl({ url: 'pages/ProjectDetailComp', params: item })
    })
  }

  build() {
    Column() {
      Text('项目')
        .height(44)
        .width('100%')
        .fontWeight(500)
        .textAlign(TextAlign.Center)
        .border({
          width: { bottom: $r('app.float.common_border_width') },
          color: $r('app.color.common_gray_border')
        })

      List() {
        ForEach(this.list, (item: ProjectItemModel) => {
          ListItem() {
            this.ProjectItemBuilder(item)

          }
        })
      }
      .divider({
        strokeWidth: $r('app.float.common_border_width'),
        color: $r('app.color.common_gray_border')
      })
      .padding({
        left: $r('app.float.common_gutter'),
        right: $r('app.float.common_gutter')
      })

      Blank()

      Stack() {
        Text()
          .width('100%')
          .height($r('app.float.common_border_width'))
          .backgroundColor($r('app.color.common_gray_01'))
        Text('其他项目正在赶来的路上…')
          .padding($r('app.float.common_space10'))
          .backgroundColor(Color.White)
          .fontColor($r('app.color.common_gray_01'))
          .fontSize($r('app.float.common_font12'))
      }
      .width('80%')
      .padding($r('app.float.common_gutter'))
    }
    .width('100%')
    .height('100%')
    .padding({top:this.topHeight})
  }
}