import { HdSearch } from '../../common/components/HdSearch'
import { allResponse, getInterviewList } from '../../common/utils/myReq'
import { homeSubItemModel, homeSubListModel } from '../../models/homeSubListModel'
import { InterviewItemComp } from './InterviewItemComp'
import { router } from '@kit.ArkUI'

// 热门企业实体
interface Company {
  icon: ResourceStr
  count: number
}

interface TabItem {
  name: string
  value?: number
  onAreaChange?: (area: Area) => void
}

export interface InterviewItem {
  id: string
  stem: string
  content: string
  likeCount: number
  views: number
  creatorName: string
  creatorAvatar: ResourceStr
  createdAt: string
  tags: string[]
  likeFlag: 0 | 1 | null
}

export interface getId{
  Iid:string
}

@Entry
@Component
export struct Interview {
  @State
  left: number = 16
  @State
  sort: number | undefined = 30
  @StorageProp('topHeight') topHeight: number = 0

  @State
  list: InterviewItem[] = [
    {
      id: '10001',
      stem: '微软谷歌面试算法难度 | 你想象不到的简单',
      content: '内推 候选人可以找到认识的微软员工,员工会把简历提交到微软人才库。这样微软HR就可以在人才库的系统中查看到你的简历。',
      likeCount: 13,
      views: 347,
      creatorName: '凡人的积累',
      creatorAvatar: $r('app.media.ic_interview_avatar'),
      createdAt: '一周前',
      tags: ['大厂', '算法'],
      likeFlag: 1
    },
    {
      id: '10002',
      stem: '美团-工程效能组-开发工程师实习生(工程基建方向)-一面',
      content: '项目介绍网页音视频项目项目代码量多少？是一个人完成的吗？介绍SaaS视频项目SpringSpring框架有什么特性？(不知道这个问题要问什么，答的扩展性、封装性啥的)控制反转了解吗？',
      likeCount: 32,
      views: 503,
      creatorName: '响亮的名字',
      creatorAvatar: $r('app.media.ic_interview_avatar'),
      createdAt: '10 小时前',
      tags: ['大厂', 'Java'],
      likeFlag: 0
    },
    {
      id: '10003',
      stem: '中邮消费金融AI算法工程师（实习生）',
      content: '这个是在猎聘上投递的 能收到面试属实是意外之喜面试官是nlp方向的，主要是问nlp相关 首先自我介绍说一个在上段实习中的项目 这里说了一个搭建智能客服对话助手',
      likeCount: 10,
      views: 98,
      creatorName: '不想秃头的夜猫子',
      creatorAvatar: $r('app.media.ic_interview_avatar'),
      createdAt: '23 分钟前',
      tags: ['国企', '实习'],
      likeFlag: 1
    }
  ]

  setLineLeft(area: Area) {
    const width = area.width as number
    const x = area.position.x as number
    this.left = x + (width - 16) / 2
  }

  async aboutToAppear(): Promise<void> {
    console.log('interview before')
    const res = await getInterviewList(9,1,this.sort)
    const result=(JSON.parse(res.result.toString()) as allResponse<homeSubListModel>).data.rows
    this.list=JSON.parse(JSON.stringify(result)) as InterviewItem[]
    console.log(`res:${JSON.stringify(this.list[0])}`)
  }

  // 热门企业
  @Builder
  companyBuilder(com: Company) {
    Column({ space: 12 }) {
      Image(com.icon)
        .width(36)
        .aspectRatio(1)
        .margin({ top: 20 })
        .objectFit(ImageFit.Contain)
      Text() {
        Span('热门指数')
        Span(`${com.count}K`)
          .fontColor($r('app.color.common_green'))
      }
      .fontSize(13)
      .fontColor($r('app.color.common_gray_01'))

      Button({ type: ButtonType.Normal }) {
        Text('查看')
          .fontSize(14)
      }
      .backgroundColor($r('app.color.common_gray_bg'))
      .padding(0)
      .height(30)
      .width(80)
      .borderRadius(8)

    }
    .backgroundColor(Color.White)
    .borderRadius(8)
    .height(140)
    .width(100)
  }

  // 标签页
  @Builder
  tabBuilder(tab: TabItem) {
    Text(tab.name)
      .fontSize(14)
      .padding(10)
      .fontColor(this.sort === tab.value ? '#000' : '#979797')
      .animation({
        duration: 300
      })
      .onClick((e) => {
        this.setLineLeft(e.target.area)
        this.sort = tab.value
      })
      .onAreaChange((_o, n) => tab.onAreaChange && tab.onAreaChange(n))
  }

  build() {
    Column() {
      Row({ space: 16 }) {
        Image($r('app.media.ic_interview_text'))
          .width(54)
          .height(20)
          .objectFit(ImageFit.Contain)
          .layoutWeight(1)
        HdSearch({ ph: '请输入关键词', bg: '#f3f4f5' })
          .layoutWeight(3)
      }
      .padding({ left: 16, right: 16 })
      .height(64)

      // 热门企业
      Scroll() {
        Row({ space: 10 }) {
          this.companyBuilder({ icon: $r('app.media.ic_company_hw'), count: 1.5 })
          this.companyBuilder({ icon: $r('app.media.ic_company_wr'), count: 2.9 })
          this.companyBuilder({ icon: $r('app.media.ic_company_gg'), count: 3.1 })
          this.companyBuilder({ icon: $r('app.media.ic_company_zj'), count: 5.3 })
          this.companyBuilder({ icon: $r('app.media.ic_company_wy'), count: 3.6 })
        }
      }
      .width('100%')
      .height(160)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .padding(10)

      .edgeEffect(EdgeEffect.Spring)
      .backgroundColor($r('app.color.common_gray_bg'))

      // 标签页
      Row() {
        Row() {
          this.tabBuilder({
            name: '推荐', value: 30,
            onAreaChange: (area) => {
              this.setLineLeft(area)
            }
          })
          this.tabBuilder({ name: '最新', value: undefined })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
        .height(40)
        .border({
          width: { bottom: $r('app.float.common_border_width') },
          color: $r('app.color.common_gray_border')
        })

        Text()
          .width(16)
          .height(2)
          .backgroundColor('#000000')
          .position({ x: this.left, y: 38 })
          .animation({
            duration: 300
          })
      }

      // 文章列表
      List() {
        ForEach(this.list, (item: InterviewItem, index: number) => {
          ListItem() {
            InterviewItemComp({ item })
              .padding(16)
          }
        })
      }
      .padding({ bottom: 50 })

    }
    .width('100%')
    .height('100%')
    .padding({top:this.topHeight})
  }
}