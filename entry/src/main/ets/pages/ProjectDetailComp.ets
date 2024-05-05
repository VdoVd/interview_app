import { router } from '@kit.ArkUI'
import { HdSearch } from '../common/components/HdSearch'
import { allResponse, getQuestionList } from '../common/utils/myReq'
import { homeSubItemModel, homeSubListModel } from '../models/homeSubListModel'
import HomeSubListItemView from '../views/home/HomeSubListItemView'

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

@Entry
@Component
export struct ProjectDetailComp {

  @StorageLink('topHeight') topHeight:number=0

  @State isLoading:boolean=false

  @State reqId:number=0

  // 0 默认 21 降序 20 升序
  @Watch('getList') @State sort: number = 0

  // 可选排序
  sortArr: number[] = [0, 21, 20]

  @State
  projectItem: ProjectItemModel = new ProjectItemModel({} as ProjectItem)

  @State
  questionList:homeSubItemModel[]=[]

  async aboutToAppear(): Promise<void> {
    // 获取项目列表页传入的路由数据

    this.projectItem = router.getParams() as ProjectItemModel

    this.reqId=this.projectItem.id

    await this.getList()

  }

  private async getList() {

    this.isLoading=true

    const res = await getQuestionList(this.reqId, this.sort)

    this.questionList = (JSON.parse(res.result.toString()) as allResponse<homeSubListModel>).data.rows

    this.isLoading=false
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Top }) {
        Image($r('app.media.project_bg'))
          .width('100%')
          .height(236)
          .opacity(0.2)
        Column() {
          Row() {
            Image($r('sys.media.ohos_ic_public_arrow_left'))
              .size({ width: 24, height: 24 })
              .fillColor(Color.White)
              .onClick(() => router.back())
            Blank()
              .layoutWeight(1)
            HdSearch({ bg: 'rgba(246, 247, 249, 0.5)', color: '#333333' })
              .layoutWeight(3)
          }
          .height(56)
          .width('100%')

          Row({ space: 15}) {
            Image(this.projectItem.icon)
              .width(86)
              .height(114)
              .sharedTransition(this.projectItem.id.toString(), { duration: 300 })
            Column({ space: 15 }) {
              Text(this.projectItem.name)
                .fontWeight(500)
                .fontColor(Color.White)
              Text(this.projectItem.describeInfo)
                .fontSize($r('app.float.common_font14'))
                .fontColor(Color.White)
              Blank()
              Text('学习进度：10%')
                .fontColor($r('app.color.common_gray_01'))
                .fontSize($r('app.float.common_font14'))
            }
            .layoutWeight(1)
            .height(114)
            .alignItems(HorizontalAlign.Start)
          }
          .padding({ top: 20 })
          .alignItems(VerticalAlign.Top)
          .width('100%')
        }
        .padding({ left: $r('app.float.common_space16'), right: $r('app.float.common_space16') })
      }
      .height(210)

      Column() {
        Row({ space:15}) {
          Text('问题列表')
            .fontWeight(500)
          Blank()
          Row() {
            Text('浏览量')
              .fontSize($r('app.float.common_font14'))
              .fontColor(this.sort > 0 ? $r('app.color.common_main_color') : Color.Black)
            Column() {
              Image($r('sys.media.ohos_ic_public_arrow_up'))
                .size({ width: 16, height: 6 })
                .fillColor(this.sort === 20 ? $r('app.color.common_main_color') : Color.Black)
              Image($r('sys.media.ohos_ic_public_arrow_down'))
                .size({ width: 16, height: 6 })
                .fillColor(this.sort === 21 ? $r('app.color.common_main_color') : Color.Black)
            }
            .alignItems(HorizontalAlign.Start)
          }
          .onClick(() => {
            const index = this.sortArr.findIndex(i => i === this.sort)
            this.sort = this.sortArr[(index + 1) % this.sortArr.length]
            console.log(`sort:${this.sort}`)
          })
        }
        .height(44)
        .width('100%')
        .padding({ left: $r('app.float.common_space16'), right: $r('app.float.common_space16') })
        .border({
          width: { bottom: $r('app.float.common_border_width') },
          color: $r('app.color.common_gray_border')
        })

        Column() {
          // 项目题目列表
          if(this.isLoading===false)
          ForEach(this.questionList,(item:homeSubItemModel)=>{
            HomeSubListItemView({item:item})
          })
          else if(this.isLoading===true)
            Text('正在加载中.....').width('100%').textAlign(TextAlign.Center)
        }
        .layoutWeight(1)
      }
      .layoutWeight(1)
      .backgroundColor(Color.White)
      .width('100%')
      .borderRadius({ topLeft: 16, topRight: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#5D2B05')
    .padding({top:this.topHeight})
  }
}