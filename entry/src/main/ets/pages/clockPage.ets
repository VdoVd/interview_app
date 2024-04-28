import { allResponse, getClockIn, getClockInDays } from '../common/utils/myReq'
import { clockIn, ClockInData } from '../models/clockInModel'
import { promptAction } from '@kit.ArkUI'
import { HmCalendar,HmCalendarSelectedDay } from '@ohmos/calendar'
import { http } from '@kit.NetworkKit'

export interface calenderFormat{
  date:string
}
@Entry
@Component
struct clockPage{

  @State isLoading:boolean=true

  @State obj:clockIn={} as clockIn

  @State clockDays:calenderFormat[]=[]

  change(){



  }

  async aboutToAppear(): Promise<void> {

    await this.clockIn()

    let req=http.createHttp()

    const res=await getClockInDays()

    let clockInfoClass=JSON.parse(res.result.toString()) as allResponse<ClockInData>

    clockInfoClass.data.clockins.forEach(item=>{
      this.clockDays.push({date:item.createdAt})
    })

    this.clockDays.push({date:new Date().toLocaleDateString()})

    this.isLoading=false

    promptAction.showDialog({
      message:'打卡成功'
    })

  }

  private async clockIn() {
    const res = await getClockIn()

    let result = JSON.parse(res.result.toString()) as allResponse<clockIn>

    this.obj = result.data

    console.log(`clock Page:${JSON.stringify(this.obj)}`)
  }

  build() {

    Column(){
       Navigation(){
         if(this.isLoading===false)
        Column(){
          Column({space:17}){
            Row({space:10}){
              Text('今日已打卡')
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
                .onClick(()=>{
                  console.log(`print obj:${JSON.stringify(this.obj)}`)
                })
              Image($r('app.media.icon_clock_card')).width(30)
            }.width('100%').justifyContent(FlexAlign.Start)
            Row(){
              this.clockDay(this.obj.clockinTotal,'累计打卡')
              this.clockDay(this.obj.clockinNumbers,'连续打卡')

            }.width('100%').justifyContent(FlexAlign.Start)
            HmCalendar({
              selectedDays:this.clockDays,
              // 切换月份更新当前月份打卡数据
              onChangeMonth: (yearmonth: string) => {
                promptAction.showToast({ message: yearmonth })
              },
              // 点击当前日期触发 2024-01-24
              onClickDate: (currentDate: string) => {
                promptAction.showToast({ message: currentDate })
              }
            })
              .borderRadius(8)
              .border({ width: 0.5, color: '#ededed' })
              .shadow({ color: '#ededed', radius: 16 })
              .backgroundColor('#FFFFFF')
          }
        }
        .padding(20)
         else
         {
           Column(){
             Text('加载中。。。').width('100%').textAlign(TextAlign.Center)
           }
         }
       }.title('每日打卡')
      .titleMode(NavigationTitleMode.Mini)
      .onAppear(async ()=>{
        const res=await getClockIn()

        let result=JSON.parse(res.result.toString()) as allResponse<clockIn>

        this.obj=result.data

        this.obj=JSON.parse(JSON.stringify(this.obj))

        console.log(`clock Page:${JSON.stringify(this.obj)}`)
      })

    }

  }

  @Builder
  calenderBuilder(){
    Column({ space: 16 }) {
      Text('单周日历')
    }
    .padding(16)
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  clockDay(day?:number,type?:string) {

    Column({space:15}) {

      Row({space:25}){

        Text(`${day===undefined?0:day}`)
          .fontSize(30)
          .fontWeight(FontWeight.Bolder)

        Text('天').fontColor(Color.Gray)
          .fontSize(15)

      }

      Text(type===undefined?'累计打卡':type).fontSize(15)
        .fontColor(Color.Gray)

    }

  }

}

